# Implementation Plan

## Validated facts

### Priority-relevant flow facts
- `Wi-Fi setup` is multi-step (`WIFI_SSID` write, `WIFI_PASSWORD` write, discovery/reconnect, `WIFI_STATUS == 3` verification) and currently allows continuation after password-write errors.
- `Device setup` creates a device row before full `fetchAllParams(...)` convergence, which can leave partial onboarding state when later steps fail.
- `OTA / upgrade` relies on an app-hosted ephemeral HTTP server and post-upgrade `OTA_TIMESTAMP` readback, making it sensitive to transport/network path issues.
- `Pairing / remote onboarding` stores signing after pairing writes, but explicit post-write verification is weak/uneven in current flow handling.
- `Refresh parameters` performs some network reads before the main guarded refresh block, so early failures are not always normalized into one outcome shape.

### Existing outcome language
- The existing taxonomy already defines normalized outcomes: `success`, `partial_success`, `timeout`, `controller_offline`, `controller_rebooting`, `auth_failed`, `schema_error`, `stale_state`, `unexpected_response`.
- Existing roadmap/review docs already prioritize reliability work over new primitives, and point to orchestration, verification, and messaging consistency as current gaps.

## Recommendations

### Applied in this cycle (OTA quick win)
- `settings_upgrade_device_bloc.dart` now requires strong OTA convergence before terminal success:
  - `OTA_TIMESTAMP == target` on 2 consecutive reads.
  - explicit failure if convergence is not proven within retry budget.
  - post-OTA readability checks (`TIME`, `BROKER_CLIENTID`) before allowing `UpgradeDone`.
- This keeps OTA “done” semantics aligned with verified convergence, not with timeout expiry.

### Priorities by flow
1. `Wi-Fi setup` (highest near-term impact): distinguish credential-write failures from rediscovery failures; avoid misleading late-stage errors.
2. `Device setup` (partial state control): make partial onboarding explicit and recoverable instead of silently leaving ambiguous state.
3. `OTA / upgrade` (high risk, long-running): add preflight gates and stage telemetry to reduce late, opaque failures.
4. `Pairing / remote onboarding` (trust and correctness): add lightweight post-pair verification before terminal success.
5. `Refresh parameters` (consistency): unify early and late read errors under one stage/outcome model.
6. `Reachability synthesis` (stability polish): reduce local-poll vs websocket flapping with debounced health state.

### Quick wins
- Add per-stage reason codes in all five core flows (`write_failed`, `discovery_failed`, `verify_failed`, `auth_failed`, `timeout`).
- Gate terminal success behind proof checks; when proof is missing, emit `partial_success` with explicit user action (`retry`, `resume`, `fix credentials`).
- In Wi-Fi flow, treat password-write failure as first-class failure outcome (not just log-and-continue).
- Wrap refresh pre-reads and main refresh under one error mapping path so UI and logs stay consistent.
- Add normalized operation logging envelope (`flow`, `stage`, `outcome`, `reason_code`, `attempt`, `duration_ms`, `operation_id`).

### Medium changes
- Introduce a shared controller-operation state machine used by setup, pairing, Wi-Fi, refresh, and upgrade.
- Add reusable preflight validators for OTA/Wi-Fi/pairing (auth readiness, required params, network suitability).
- Add resumable recovery entry points for interrupted setup and upgrade flows.
- Create a single device-health synthesizer that fuses local daemon and websocket liveness with debounce/hysteresis.

### Candidates for first implementation
1. `Wi-Fi outcome normalization + password-write terminal semantics`
Reason: small scope, immediate UX clarity, and directly addresses a known fragile path.
2. `Setup partial-onboarding explicit state + resume action`
Reason: reduces confusing “created but unusable” devices with limited architectural risk.
3. `Pairing verification checkpoint before success`
Reason: raises correctness/trust without a broad refactor.
4. `Refresh unified try/catch and reason-code mapping`
Reason: low complexity and improves consistency across multiple screens.
5. `OTA preflight checklist + stage logging`
Reason: high leverage on longest, most failure-prone flow while still incremental.

### Mapping: failure modes -> outcome taxonomy
| Failure mode | Primary outcome | Secondary/alternative outcome | Notes |
| --- | --- | --- | --- |
| SSID write rejected | `unexpected_response` | `auth_failed` | If explicit unauthorized/credentials issue is returned, prefer `auth_failed`. |
| Password write rejected | `unexpected_response` | `auth_failed` | Should be surfaced immediately; do not defer to discovery retries. |
| Device not rediscovered after Wi-Fi change | `controller_offline` | `timeout` | Use `timeout` when retry budget is exhausted after intermittent reachability. |
| `WIFI_STATUS` never reaches connected state | `partial_success` | `timeout` | Credentials may be applied but convergence not proven. |
| Device row created, then `fetchAllParams` fails | `partial_success` | `stale_state` | Keep explicit recovery path (`resume setup`). |
| Early refresh name/mDNS read throws | `controller_offline` | `timeout` | Normalize into same refresh outcome path as later failures. |
| `fetchAllParams` schema/parse mismatch | `schema_error` | `unexpected_response` | Use `schema_error` when required keys/types are missing or invalid. |
| Pairing write succeeds locally but verification missing/fails | `partial_success` | `unexpected_response` | Never emit terminal success without verification proof. |
| OTA server unreachable from controller | `controller_offline` | `timeout` | Local app server/network path issue; include transport context. |
| OTA reboot disconnect window | `controller_rebooting` | `timeout` | Non-error transitional state until retry window expires. |
| OTA timestamp unchanged after completion window | `partial_success` | `timeout` | Side effects may exist without converged version proof. |
| Remote command unauthorized | `auth_failed` | `unexpected_response` | Applies to JWT or signing invalidity depending on endpoint response. |

## Hypotheses
- Shipping the first two candidates (`Wi-Fi normalization`, `setup partial-state recovery`) should produce the fastest reduction in user-visible confusion and support churn.
- A single shared operation-state abstraction should reduce duplicated orchestration bugs, but only after quick wins establish consistent reason-code semantics.
- Explicit use of `partial_success` plus recovery CTAs will improve trust more than increasing retry counts alone.

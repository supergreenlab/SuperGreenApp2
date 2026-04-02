# Outcome Taxonomy

## Validated facts
- The highest-risk app<->controller flows are multi-step (`setup/refresh`, `pairing/remote`, `OTA`), and each can observe transient controller states (offline, rebooting, partial/incoherent responses).
- Current codebase already emits success/error states, but failures are not consistently classified by cause in UI/logging.
- False positives are possible in at least some flows when downstream verification is weak or omitted.

## Recommendations

### Outcome definitions
| Outcome | Meaning | When to use | UI implication | Logging implication |
| --- | --- | --- | --- | --- |
| `success` | Flow completed and final proof passed | Terminal checks are true | Show success + next step | `info`: flow, stage, duration, device_id |
| `partial_success` | Core step done, verification incomplete/failed | Side effects persisted but convergence not proven | Show warning + explicit “resume/fix” CTA | `warn`: completed_stages, failed_stage, reason_code |
| `timeout` | Operation exceeded retry/time budget | HTTP/ws read-write/poll deadline exceeded | Show retry-first message with context | `warn/error`: timeout_s, attempts, stage |
| `controller_offline` | Controller unreachable on current transport | Local HTTP unreachable and no remote fallback | Show connectivity guidance | `warn`: path(local/remote), ip/mdns, last_seen |
| `controller_rebooting` | Controller in expected reboot window | OTA/reboot action triggered and transient disconnect observed | Show non-error waiting/reconnect UI | `info`: reboot_triggered_at, elapsed_s |
| `auth_failed` | Credentials/token invalid or missing | 401/unauthorized or signed command rejected | Show credential/login corrective action | `warn`: auth_mode, endpoint, status_code |
| `schema_error` | Response structure/type incompatible | JSON parse/type check fails or required key missing | Show compatibility/data-format warning | `error`: parser_context, payload_fingerprint |
| `stale_state` | Local/app state likely outdated vs controller/backend | Cached value used after failed refresh or conflicting freshness signals | Show “state may be outdated” + refresh CTA | `warn`: local_value vs observed_value, age_s |
| `unexpected_response` | Transport succeeded but semantic contract violated | Wrong identifier, unsupported field, mismatched value constraints | Show generic failure with support hint | `error`: endpoint, status/body fingerprint |

### Mapping by flow
| Flow | Typical success proof | Common degraded outcomes |
| --- | --- | --- |
| OTA / Upgrade | `OTA_TIMESTAMP == target` on stable readback (+ device reachable) | `partial_success`, `timeout`, `controller_offline`, `controller_rebooting`, `unexpected_response` |
| Setup / Refresh | Mandatory key-set fetched and consistent (`TIME`, `STATE`, `WIFI_STATUS`, identity keys) | `partial_success`, `stale_state`, `schema_error`, `timeout`, `auth_failed` |
| Pairing / Remote onboarding | Signing write + verified remote command round-trip | `partial_success`, `timeout`, `auth_failed`, `controller_offline`, `unexpected_response` |

### UX implications
- Prefer explicit phase labels (`writing`, `waiting_reconnect`, `verifying`, `done`) over single “loading”.
- Never show terminal success for `partial_success`; require explicit user acknowledgment and follow-up action.
- Show cause-specific remediation:
  - `timeout`: retry now
  - `controller_offline`: network/device reachability checks
  - `auth_failed`: re-login/re-enter credentials
  - `schema_error`: app/firmware compatibility message
  - `stale_state`: forced refresh action

### Logging implications
- Emit one normalized event per stage transition:
  - `flow`, `stage`, `outcome`, `reason_code`, `attempt`, `duration_ms`, `device_id`, `transport`.
- Include `operation_id` across retries to correlate one user action.
- For `partial_success` and `stale_state`, always log both:
  - what succeeded
  - what failed or remains unverified.

## Hypotheses
- Consistent adoption of this taxonomy should reduce false-positive UX confirmations and support triage time.
- `stale_state` as first-class outcome is likely to reduce user confusion during transient controller windows.

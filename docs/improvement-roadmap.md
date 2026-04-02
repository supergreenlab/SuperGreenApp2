# Improvement Roadmap

## Validated facts summary

### Validated facts
- Controller communication currently uses two paths: local HTTP (`DeviceAPI`) and backend websocket (`DeviceWebsocket`).
- Add-device lifecycle is split across setup, pairing, and Wi-Fi blocs, with setup fetching identity/config and Wi-Fi requiring `WIFI_STATUS == 3`.
- Parameter/model refresh is centered on `DeviceAPI.fetchAllParams(...)` and updates both params/modules and key device flags (`isSetup`, `needsRefresh`, role/capabilities).
- Reachability is maintained by a periodic local daemon (`DeviceDaemonBloc`, 5s cadence for non-remote devices) plus websocket-driven remote liveness checks.
- Firmware upgrades use bundled assets plus an in-app HTTP server flow and post-upgrade `OTA_TIMESTAMP` verification.
- Remote-control enablement depends on login state, firmware threshold checks, and pairing/signing setup.

### Recommendations
- None in this section.

### Hypotheses
- Standardizing outcome naming and reason-code taxonomy across flows will improve cross-team alignment during reliability triage.

## Top fragile flows

### Validated facts
- Pairing stores signing locally immediately after posting signing to device, with no explicit pairing verification step in the pairing blocs.
- Wi-Fi setup continues discovery even if password write fails (error logged), while SSID write failure is terminal.
- Setup can create a device row before full parameter fetch completes.
- Refresh flow performs name/mDNS reads before the protected `fetchAllParams(...)` try/catch block.
- OTA success depends on the controller being able to reach an app-hosted ephemeral HTTP endpoint.

### Recommendations
- Treat these as first-priority reliability targets in this order: Wi-Fi setup, setup partial state handling, OTA preflight/observability, pairing verification, refresh consistency.

### Hypotheses
- The current incident volume is likely concentrated in these top fragile flows, with Wi-Fi and setup partial-state behavior driving disproportionate user-visible failures.

## Quick wins (small changes)

### Validated facts
- Existing flows already expose progress/error states, but failure classification is not uniformly stage-specific.
- Most fragilities are around orchestration and messaging boundaries, not missing core primitives.

### Recommendations
- Priority: `P0`
- Standardize per-stage error reasons in all controller flows (write failure vs discovery failure vs auth failure vs timeout).
- Surface explicit “partial setup” state when device creation succeeded but full param sync did not.
- Priority: `P1`
- Add lightweight post-pair verification before surfacing “done”.
- Wrap all refresh-network reads in unified error handling so early failures map to consistent UI states.
- Add concise structured logging tags per flow stage to improve diagnosis without major refactors.

### Hypotheses
- Quick-win changes can reduce avoidable retries and ambiguous error reports without needing deep architectural refactors.

## OTA quick win status

### Validated facts
- OTA/Upgrade success criteria were tightened in app code:
  - no terminal success without `OTA_TIMESTAMP` convergence to target on 2 consecutive reads;
  - no terminal success when convergence times out;
  - post-OTA readability checks (`TIME`, `BROKER_CLIENTID`) are now required before `UpgradeDone`.

### Recommendations
- Next step is runtime validation on device for edge cases (`partial_success`/timeout messaging), not additional flow refactors.

### Hypotheses
- Stronger convergence checks should reduce false-positive “done” outcomes in reboot/transient controller windows.

## Medium-term improvements

### Validated facts
- Reachability currently combines periodic local polling and websocket activity, each with separate timing behavior.
- OTA and Wi-Fi flows are multi-step and time-based, with several retries/sleeps and late failure points.

### Recommendations
- Priority: `P1`
- Introduce a shared controller-operation state machine abstraction used by setup/pairing/Wi-Fi/upgrade flows.
- Add preflight check layers for OTA and Wi-Fi operations (network suitability, required params, auth readiness) before long-running steps.
- Priority: `P2`
- Build a unified device-health model that fuses local/remote signals with debounce/hysteresis to reduce status flapping.
- Add resumable recovery entry points for interrupted onboarding and upgrade operations.

### Hypotheses
- A shared operation abstraction and preflight gates should lower multi-step failure rates, while health-model unification primarily improves perceived stability and trust.

## Longer-term architectural opportunities

### Validated facts
- Core behavior today is spread across multiple blocs and helper classes, with repeated flow orchestration patterns.
- The app already has both local and remote control primitives and durable local storage that can support stronger orchestration.

### Recommendations
- Priority: `P2`
- Consolidate controller operations into a domain service layer with explicit command/result contracts and idempotent retries.
- Define a capability/version contract between app and firmware (instead of threshold-only checks) to reduce implicit coupling.
- Priority: `P3`
- Move toward event-sourced operation timelines for major flows (setup, upgrade, remote pairing) to improve recoverability and support tooling.
- Add a dedicated diagnostics surface (user-readable and support-oriented) powered by normalized operation events and failure codes.

### Hypotheses
- Architectural consolidation will improve long-term correctness and maintainability, but delivery impact depends on sequencing to avoid disrupting near-term reliability work.

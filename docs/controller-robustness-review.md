# Controller Robustness Review

## Validated facts

### Facts
- Local controller IO uses HTTP endpoints (`/s`, `/i`, `/fs/config.json`, `/fs/<filename>`) through `DeviceAPI`.
- Setup flow (`device_setup_bloc`) fetches `BROKER_CLIENTID`, creates the local device row, fetches all params, updates `TIME`, and applies first-run defaults when `STATE == 0`.
- Pairing flow (`device_pairing_bloc`) checks `OTA_TIMESTAMP` against `BackendAPI.lastBeforeRemoteControlTimestamp`, then runs `DeviceHelper.pairDevice(...)`.
- Wi-Fi setup flow (`device_wifi_bloc`) writes `WIFI_SSID` and `WIFI_PASSWORD`, then re-searches up to 10 times (5s interval) and validates `WIFI_STATUS == 3`.
- Upgrade flow (`settings_upgrade_device_bloc`) compares local firmware `timestamp` with device `OTA_TIMESTAMP`, uploads `config.json` and `app.html`, starts an in-app HTTP server, sets OTA server params, triggers `OTA_START` (or `REBOOT` fallback), serves firmware, then re-checks `OTA_TIMESTAMP`.
- Reachability daemon (`DeviceDaemonBloc`) runs every 5 seconds for non-remote devices, checks `BROKER_CLIENTID`, updates `isReachable`, attempts mDNS re-resolution on failures, and may trigger login-required state on auth errors.
- Refresh parameters flow (`refresh_parameters_bloc`) refreshes `DEVICE_NAME` and `MDNS_DOMAIN`, then calls `fetchAllParams(...)`.
- Remote settings flow (`settings_remote_control_bloc`) requires login and acceptable firmware timestamp, then reuses `pairDevice(...)` for remote-control pairing.
- Remote command mode uses signing from app KV (`AppDB`) and websocket command signing in `DeviceWebsocket`.

### Hypotheses
- None in this section; items above are directly validated from current repo code and existing controller docs.

## Fragilities by flow (pairing, wifi setup, device setup, ota/upgrade, reachability/daemon, refresh/remote settings)

### Facts
- Pairing and remote-control pairing both rely on writing `/signing?key=...` and then storing signing locally; there is no explicit post-write readback in the pairing bloc itself.
- Wi-Fi setup treats SSID write failure as terminal, but password write errors are logged and flow continues into discovery anyway.
- Device setup stores the device as soon as identity/name/mDNS are fetched; later param-refresh failure transitions to loading error but does not roll back created device row.
- OTA upgrade binds an ephemeral local HTTP server and depends on controller reaching that app-hosted endpoint (`last_timestamp`, `firmware.bin`) before completion checks.
- Reachability daemon has an internal per-device worker lock and periodic polling, but remote-device connectivity health is primarily websocket-driven.
- Refresh parameters performs pre-refresh name/mDNS reads before entering its try/catch around `fetchAllParams(...)`.
- Remote settings screen can show needs-upgrade/login gates before allowing pairing, based on local JWT and `OTA_TIMESTAMP`.

### Hypotheses
- Pairing success may be over-reported if local signing is persisted but controller-side signing write was not durably applied.
- In Wi-Fi setup, continuing after password-write failure can produce confusing outcomes (late "not found" rather than credential-write error).
- Setup may leave partially onboarded devices that look present but are not fully usable when `fetchAllParams` fails mid-flow.
- OTA flow may be sensitive to phone networking constraints (NAT, IPv4/IPv6 behavior, hotspot/client isolation), causing non-deterministic upgrade failures.
- Reachability can oscillate around network transitions because local polling and websocket remote status have different timing models.
- Refresh can fail before progress UI/error handling if name/mDNS reads throw before `fetchAllParams` is attempted.
- Remote settings may appear inconsistent if cached signing/JWT state differs from actual backend or controller state.

## Likely user-facing failure modes

### Facts
- Setup/login flow can explicitly surface auth-required state (401 path).
- Wi-Fi setup can end in "not found" after repeated discovery attempts when IP or `WIFI_STATUS` validation fails.
- Upgrade flow can end in explicit upgrade error state if timestamp verification does not complete.
- Remote-control setup can block on login requirement and firmware-upgrade requirement.

### Hypotheses
- Users may see "paired" expectations but fail to control remotely if pairing state is stale or partially applied.
- Users may experience confusing Wi-Fi outcomes when password acceptance is uncertain but discovery still proceeds.
- Users may see intermittent "device unreachable" behavior during network changes even when controller is physically online.
- Users may perceive refresh as hanging/failing without clear stage messaging when failures happen early.
- OTA failures may be reported late (after long waiting states), increasing perceived app instability.

## Recommended next improvements (recommendations only, no implementation)

### Facts
- Current flows already include retries, progress states, and fallback behaviors, but stage-level error classification is uneven across blocs.

### Hypotheses
- Add explicit stage-result telemetry and user-visible reason codes per flow step (credential write, discovery, handshake, timestamp check) to reduce ambiguous failures.
- Make pairing and remote-control pairing include a lightweight verification step before marking done.
- Align Wi-Fi setup error semantics so credential-write failures are surfaced distinctly from discovery failures.
- Introduce a consistent "partial onboarding" recovery path for setup failures (resume/repair instead of silent leftover state).
- Harden OTA preflight checks (network path suitability, asset availability, required params) before entering long-running upgrade steps.
- Unify reachability state synthesis (local poll + websocket) into a debounced, user-facing health model to reduce status flapping.
- Ensure refresh flow wraps all network calls in uniform error handling and stage progress updates.

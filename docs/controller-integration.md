# Controller Integration

## Validated facts

- Device/controller communication supports both local HTTP and backend websocket modes.
- Local device HTTP access patterns are implemented in `DeviceAPI`:
  - Read string param: `GET /s?k=<PARAM>`
  - Read int param: `GET /i?k=<PARAM>`
  - Write string param: `POST /s?k=<PARAM>&v=<VALUE>`
  - Write int param: `POST /i?k=<PARAM>&v=<VALUE>`
  - Config fetch: `GET /fs/config.json`
  - File upload: `POST /fs/<filename>`
- Local name resolution uses mDNS conventions and normalizes names via `DeviceAPI.mdnsDomain(...)`.
- `DeviceAPI.fetchAllParams(...)` pulls device config and materializes module/param rows in Drift (`modules`, `params`), then updates device metadata:
  - `isController`
  - `isScreen`
  - `isSetup`
  - `needsRefresh`
  - `nBoxes`, `nSensorPorts`, `nLeds`, `nMotors`
  - raw `config` JSON
- Add-device flow includes setup/pairing/wifi stages:
  - Setup (`device_setup_bloc`) fetches `BROKER_CLIENTID`, creates device record, fetches all params, sets `TIME`, and applies initial controller defaults when `STATE == 0`.
  - Pairing (`device_pairing_bloc`) checks `OTA_TIMESTAMP` threshold and calls `DeviceHelper.pairDevice(...)`.
  - Wi-Fi (`device_wifi_bloc`) writes `WIFI_SSID` and `WIFI_PASSWORD`, then re-discovers IP through remote/local path and validates `WIFI_STATUS == 3`.
- Remote command path is available when device signing is present and device is remote:
  - `DeviceHelper` sends `seti/sets/geti/gets` commands through `DeviceWebsocket.sendRemoteCommand(...)`.
  - Commands are signed with `sha256(signing + ":" + command-with-id)` style payloading before sending.
- `DeviceWebsocket` connects to `${BackendAPI.websocketServerHost}/device/<serverID>/stream` with bearer auth.
- Websocket stream updates local param values and tracks remote liveness through periodic `geti -k TIME` checks.
- `DeviceDaemonBloc` periodically checks local device reachability every 5 seconds (for non-remote devices), handles auth failures, and can recover IP using mDNS lookup.

## Firmware upgrade path (validated facts)

- Firmware assets are bundled under `assets/firmware/<variant>/` and include:
  - `firmware.bin`
  - `timestamp`
  - `html_app/app.html`
  - `html_app/config.json`
- Upgrade flow (`settings_upgrade_device_bloc`) does the following:
  - Compares device `OTA_TIMESTAMP` with local asset `timestamp`.
  - Uploads `config.json` and `app.html` to device filesystem.
  - Starts an embedded HTTP server in-app.
  - Writes `OTA_SERVER_IP` and `OTA_SERVER_PORT` to the device.
  - Triggers OTA via `OTA_START` or fallback `REBOOT`.
  - Serves `last_timestamp` and `firmware.bin` to the device and later verifies `OTA_TIMESTAMP`.

## Hypotheses / follow-ups

- Signature scheme appears custom and shared-secret based; confirm exact firmware-side verifier behavior and replay protection guarantees.
- Remote/local mode transitions rely on timers plus websocket heartbeat behavior; edge conditions (network flaps, dual-path ambiguity) should be validated with scenario tests.
- Credential handling uses base64 basic auth from `AppDB` device data; confirm storage/security expectations for production threat model.


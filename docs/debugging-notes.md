# Debugging Notes

## Validated facts

- Logging is file-backed via `Logger` and written to `<application documents>/log.txt`.
- `Logger.init()` deletes any existing log file on app startup.
- Global error capture points include:
  - `FlutterError.onError` in `initApp()`
  - outer `runZonedGuarded` error handler in `main()`
- Device reachability/runtime behavior:
  - `DeviceDaemonBloc` runs periodic checks (every 5 seconds) for non-remote devices.
  - A 401-like failure triggers `DeviceDaemonBlocStateRequiresLogin`.
  - On local failure, the daemon attempts mDNS-based IP re-resolution before marking unreachable.
- Remote connectivity/runtime behavior:
  - `DeviceWebsocket` reconnects on stream error/done after a delay.
  - Remote command ack waits on command-id correlation from `CMD` logs in websocket messages.
  - Command retries and timeout behavior are timer-driven.
- Sync runtime behavior:
  - `SyncerBloc` runs periodic inbound/outbound sync loops.
  - Sync is blocked when on non-WiFi unless `syncOverGSM` is enabled in app data.
  - Sync progress text is surfaced to UI (`SyncerBlocStateSyncing`) and shown in main red bar.
- Notification/runtime behavior:
  - `NotificationsBloc` routes many notification types into main navigation events.
  - Local reminder scheduling is handled by `LocalNotifications`.

## Practical checks (validated from implementation behavior)

- Device auth issues:
  - Symptoms: setup/load fails and state indicates auth needed.
  - Check stored auth via `AppDB`-backed device data and retry setup with credentials.
- Wrong device/IP mismatch:
  - Symptoms: daemon logs wrong identifier for IP.
  - Check `BROKER_CLIENTID` response against stored `device.identifier`.
  - Re-resolve mDNS and verify `device.mdns` consistency.
- Wi-Fi onboarding stalls:
  - Confirm writes to `WIFI_SSID` and `WIFI_PASSWORD` succeeded.
  - Confirm rediscovery produced IP and `WIFI_STATUS == 3`.
- Remote control not active:
  - Confirm device has signing (`AppDB.getDeviceSigning(...)` not null).
  - Confirm websocket connection exists for device `serverID`.
  - Watch remote ping behavior (`geti -k TIME`) and `isRemote` field updates.
- Firmware upgrade issues:
  - Verify `OTA_BASEDIR` points to an existing asset variant under `assets/firmware`.
  - Verify app can bind local HTTP server and device can reach served `firmware.bin`.
  - Verify post-upgrade `OTA_TIMESTAMP` matches bundled `timestamp`.

## Hypotheses / follow-ups

- Because logs are reset on startup, historical failure analysis across sessions may be limited; consider optional log rotation instead of delete-on-init if needed.
- Some retry/error handling paths swallow details or log without user-facing surfacing; confirm whether additional telemetry is desired.
- `DeviceWebsocket.deleteIfExists` removes from map using object value instead of `serverID` key; confirm if this is intentional or latent cleanup bug.


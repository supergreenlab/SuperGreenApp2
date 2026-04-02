# Agents Documentation Index

This repository currently has no dedicated `docs/` architecture set in source control history here, so this file acts as an entry point for docs curation work.

## Scope

This docs set is intentionally implementation-facing and limited to:

- app architecture
- controller/device integration
- practical debugging notes

No app code was refactored while preparing these docs.

## Document Map

- `docs/app-architecture.md`
- `docs/controller-integration.md`
- `docs/debugging-notes.md`

## Evidence Policy

Each document separates:

- `Validated facts`: statements directly verified from repository files.
- `Hypotheses / follow-ups`: likely interpretations, unknowns, or checks to run later.

## Primary Evidence Files Used

- `lib/main.dart`
- `lib/main/main_page.dart`
- `lib/main/main_navigator_bloc.dart`
- `lib/data/kv/app_db.dart`
- `lib/data/rel/rel_db.dart`
- `lib/data/api/backend/backend_api.dart`
- `lib/data/api/backend/devices/websocket.dart`
- `lib/data/api/device/device_api.dart`
- `lib/data/api/device/device_helper.dart`
- `lib/device_daemon/device_daemon_bloc.dart`
- `lib/device_daemon/device_reachable_listener_bloc.dart`
- `lib/syncer/syncer_bloc.dart`
- `lib/notifications/notifications.dart`
- `lib/pages/add_device/device_setup/device_setup_bloc.dart`
- `lib/pages/add_device/device_pairing/device_pairing_bloc.dart`
- `lib/pages/add_device/device_wifi/device_wifi_bloc.dart`
- `lib/pages/settings/devices/refresh_parameters/refresh_parameters_bloc.dart`
- `lib/pages/settings/devices/remote_control/settings_remote_control_bloc.dart`
- `lib/pages/settings/devices/upgrade/settings_upgrade_device_bloc.dart`


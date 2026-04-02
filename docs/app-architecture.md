# App Architecture

## Validated facts

- The app is a Flutter project with entrypoint at `lib/main.dart`.
- Startup runs inside `runZonedGuarded` and calls `initApp()` before `runApp(...)`.
- `initApp()` initializes logging, Firebase, notification channel setup, Hive storage, app directories, orientation lock, recaptcha key setup, and backend singleton warm-up.
- Dependency/state composition is bloc-based with top-level providers created in `main()`:
  - `PinLockBloc`
  - `MainNavigatorBloc`
  - `TowelieBloc`
  - `DeviceDaemonBloc`
  - `SyncerBloc`
  - `NotificationsBloc`
  - `DeepLinkBloc`
- `MainPage` builds a `MaterialApp` and centralizes route generation through `onGenerateRoute`.
- Route handling uses `MainPage._onGenerateRoute(...)` and creates per-page blocs around route widgets.
- Localization delegates are configured for custom app localizations plus Flutter material/widgets delegates; supported locales include `en`, `es`, and `fr`.
- The app uses two local persistence layers:
  - Hive (`AppDB`) for app settings, auth tokens, device auth/signing data, and lightweight flags/cache.
  - Drift SQLite (`RelDB`) for relational domain data (devices, params, modules, plants, boxes, feeds, checklists, deletes, etc.).
- `RelDB` schema version is `18`, with in-code migration/data-change logic.
- Backend access is centralized in `BackendAPI` singleton and includes API modules for users, feeds, products, services, time-series, and checklists.
- Notification processing (`NotificationsBloc`) maps notification payloads to navigation events and state actions.
- Sync is performed by `SyncerBloc` with periodic in/out loops, gated by connectivity and `syncOverGSM` setting.
- Device reachability/login prompts and remote websocket lifecycle are coordinated by `DeviceDaemonBloc`.

## Hypotheses / follow-ups

- `MainPage` currently imports a very large route surface; this may be a maintainability hotspot and could benefit from route registration extraction.
- Backend environment logic in `BackendAPI.initAndroidDevUrls()` contains `if (true || ...)`, which forces the same branch for Android dev URL selection; confirm whether this is intentional.
- There may be opportunities to document or formalize bounded contexts (feeds/checklists/devices) as architecture modules for easier onboarding.


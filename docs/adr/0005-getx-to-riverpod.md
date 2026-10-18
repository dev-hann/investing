# ADR-0005: Replace GetX with Riverpod for state management and DI

- **Date:** 2026-10-18
- **Status:** Accepted

## Context

GetX provided state management, dependency injection, navigation, and snackbars in a single package, but three forces made replacement necessary:

1. **Testability.** Controllers were only reachable through `Get.put`/`Get.find`, and full-app widget tests deadlock under `flutter_test` fake async (ADR-0001). There was no way to exercise a controller in isolation.
2. **Upcoming streaming data layer.** The planned WebSocket quote redesign needs a natural home for live streams; GetX offers no equivalent of `StreamProvider`/`AsyncValue`.
3. **Runtime-only DI.** `Get.put`/`Get.find` failures surface at runtime, not compile time, and GetX's documentation (testing especially) has fallen behind bloc/Riverpod.

Migration scope measured before starting: 31 of 100 `lib/` files imported `get`; 8 controllers; 18 `Obx`/`GetBuilder` sites; 15 navigation calls; 8 DI registrations; 3 snackbar calls; 1 `GetMaterialApp`; 0 `GetConnect` (services were already dio-based).

## Decision

Replace `get` with `flutter_riverpod` 3.x. The one-way layering is unchanged — only the state/DI mechanism inside each layer changes:

- **Providers live with their layer.** Each `xxx_repo.dart` declares `xxxRepoProvider`, each use case declares `xxxUseCaseProvider`, each controller file declares its `NotifierProvider` next to the notifier. Wiring is compile-checked and lazy.
- **Controllers become `Notifier<T>`** with immutable state classes (`Equatable`, `copyWith`) instead of scattered `Rx` fields. Screen-local reactive state (chart tabs, search results) moved to plain `setState` in the widget.
- **Navigation uses the plain `Navigator`** via the `pushView` helper (`util/navigator.dart`). go_router was deliberately *not* introduced: the app has no named routes, deep links, or URL state today — add it when one of those becomes real.
- **Snackbars from non-widget code** go through a global `scaffoldMessengerKey` (`widget/snackbar.dart`) wired into `MaterialApp`.
- **Theme mode is provider state**: `settingControllerProvider` (a `Notifier<ThemeMode>`) is watched by `MaterialApp` in `main.dart`.
- `GetMaterialApp` → `MaterialApp` inside a `ProviderScope`; dialogs use `showDialog`, bottom sheets `showModalBottomSheet`.

## Consequences

- Controllers are unit-testable with a bare `ProviderContainer` (see `test/controller_test.dart`) — no widget tree, no fake-async deadlock for pure notifiers (`Setting`, `Home`). Notifiers that start network/Hive IO in `build()` (news, event, market, stock) still must not be watched in plain unit tests.
- One new convention to keep: notifiers obtain their use case via `ref.watch(...UseCaseProvider)` assigned to a `late final` field in `build()`. This assumes use-case providers are static (`Provider`, never rebuilt) — do not make them depend on mutable state.
- Local UI state that used `Rx` is now `setState`; widgets that used `GetBuilder`/`Obx` are `ConsumerWidget`/`ConsumerStatefulWidget` using `ref.watch` (rebuild scope) and `ref.read(...notifier)` (actions).
- `GetX` string extensions are gone (`capitalize` is a local helper in `event_view.dart`).
- Rollback: revert the migration commit and restore `get: ^4.7.3` — no data or API changes are involved.

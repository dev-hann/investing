# Changelog

All notable changes to this project are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning follows SemVer with `v`-prefixed git tags that trigger automatic releases.

## [Unreleased]

### Changed

- **State management migrated from GetX to Riverpod** ([ADR-0005](docs/adr/0005-getx-to-riverpod.md)): controllers are now `Notifier`s with immutable state classes; DI is a compile-checked provider graph declared per layer (`repo` → `use_case` → `controller`); `GetMaterialApp` → `MaterialApp` + `ProviderScope`; theme mode is provider state watched by `MaterialApp`.
- Navigation moved from `Get.to`/`Get.back` to the `Navigator` (`pushView` helper in `util/navigator.dart`); dialogs via `showDialog`; bottom sheets via `showModalBottomSheet`; snackbars via global `scaffoldMessengerKey`.
- Screen-local reactive state (`Rx`/`Obx` in views) converted to `setState`; reactive widgets are now `ConsumerWidget`/`ConsumerStatefulWidget`.

### Added

- Controller unit tests via `ProviderContainer` (`test/controller_test.dart`) — the first tests that exercise controllers without a widget tree.

### Removed

- `get` dependency.

## [1.0.0] — 2026-10-18

### Added
- GitHub Actions CI (analyze + test + debug APK on push/PR). [`ci.yml`](.github/workflows/ci.yml)
- Strict analysis profile: `strict-casts` / `strict-inference` / `strict-raw-types` plus an extended lint set (explicit casts at the JSON boundary, `unawaited` discipline, const/quotes/formatting rules); formatting enforced in CI via `dart format --set-exit-if-changed`.
- Misspelled filenames corrected: `home_use_cas.dart`→`home_use_case.dart`, `stock_search_contrller.dart`→`stock_search_controller.dart`, `earming_event_card.dart`→`earning_event_card.dart`, `stock_summay.dart`→`stock_summary.dart`, `evnet_search_view.dart`→`event_search_view.dart`.
- Tag-driven release pipeline: `v*` tag builds a keystore-signed release APK and publishes it to GitHub Releases. [`release.yml`](.github/workflows/release.yml)
- Release signing with dedicated keystore via GitHub Secrets (`debug`-signed fallback for local builds without `key.properties`).
- Documentation set: rewritten README, `AGENTS.md` for AI assistants, `docs/ARCHITECTURE.md`, ADR index + records 0001–0004, this changelog.

### Changed
- **Migrated to Dart 3 / Flutter 3.47**: SDK constraint `^3.13.0`; all dependencies updated to latest resolvable versions (dio 5.11, fl_chart 1.2, table_calendar 3.3, flutter_inappwebview 6.1, get 4.7.3, …).
- Replaced Dart-3-incompatible packages: `hive`→`hive_ce`, `pull_to_refresh`→`pull_to_refresh_flutter3`, `auto_size_text`→`auto_size_text_plus`, `treemap`→`any_treemap` (market heatmap rewritten declaratively, tiles now colored by percent change).
- Android project regenerated with the modern Gradle plugin DSL: AGP 8.13.0, Gradle 8.14.3, Kotlin 2.4.0, JDK 17.
- Dart 3 conformance: `Comparable` via `implements`, `final class` for `LinkedListEntry` subclasses, `WebUri` for inappwebview 6, `CardThemeData`/`TabBarThemeData`, URI-based `part of` directives.

### Fixed
- Market chart cache lookup always missed (`containsKey(symbolList)` → `containsKey(symbol)`).
- Watch-list reorder applied the index adjustment twice after `onReorderItem` migration.
- Error handling in `IVService.get` and `requestStockDividend`: futures are now awaited inside `try`, so `catch` actually runs.
- CI gate: `print` in `IVService.get` error logging replaced with `debugPrint` (analyze must be issue-free for CI to pass).

### Notes
- `equatable` remains 2.x — `fl_chart 1.x` requires `^2.0.7`.
- Test suite replaced: legacy counter widget test (deadlocked on controller IO) → model parsing smoke tests.

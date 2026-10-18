# Changelog

All notable changes to this project are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning follows SemVer with `v`-prefixed git tags that trigger automatic releases.

## [Unreleased]

### Added

- **Forui (shadcn-style) design system** ([ADR-0008](docs/adr/0008-forui-design-system.md)): `forui 0.27.6` wired via `MaterialApp.builder` (`FTheme` + `FToaster` + `FTooltipGroup`) with `FLocalizations`; brand theme in `IVTheme` (`const/theme.dart`) — Forui neutral palette with the app orange as primary. A companion Material layer maps the same `FColors` onto flutter/material's `ColorScheme`, so unmigrated Material screens stay palette-consistent. `CustomTextfield` → `FTextField`, `IVTextButton` → `FButton` (ghost), `IVAlert` → `FDialog` behind unchanged public APIs.
- Controller unit tests via `ProviderContainer` (`test/controller_test.dart`) — the first tests that exercise controllers without a widget tree.
- Testing guide (`docs/TESTING.md`): hermetic-test principles, per-layer strategy, repo-override pattern for IO notifiers.
- **Live heatmap percents via Alpaca IEX WebSocket** ([ADR-0006](docs/adr/0006-alpaca-realtime-quotes.md)): quotes streamed per symbol with exact percent math against previous closes, auto-reconnect, and a last-known-good Hive cache that colors the map instantly on cold start. Credentials live in a gitignored asset, `assets/config/alpaca.json` (template: `alpaca.example.json`), loaded at startup by `IVConfig` — without the file the app falls back to a single Finviz percent fetch. Live REST smoke test auto-skips when the file is absent (`test/alpaca_service_test.dart`).
- **Market movers screen** via the keyless Nasdaq screener endpoint ([ADR-0007](docs/adr/0007-nasdaq-screener-movers.md)): Advancers / Decliners / Most Active tabs, per-category lazy loading with shimmer + retry; reachable from the new Movers section on the Market tab.
- **Offline last-known-good caching** for the news first page and calendar events (Hive): network failures now fall back to the previously fetched rows instead of an empty screen.
- HTTP hardening in `IVService`: 10s/15s connect/receive timeouts, browser-like headers, and a response interceptor that surfaces Nasdaq `status.rCode != 200` envelopes as errors.
- Pull-to-refresh on the WatchList; loading shimmer on the Market tab.

### Changed

- **State management migrated from GetX to Riverpod** ([ADR-0005](docs/adr/0005-getx-to-riverpod.md)): controllers are now `Notifier`s with immutable state classes; DI is a compile-checked provider graph declared per layer (`repo` → `use_case` → `controller`); `GetMaterialApp` → `MaterialApp` + `ProviderScope`; theme mode is provider state watched by `MaterialApp`.
- Navigation moved from `Get.to`/`Get.back` to the `Navigator` (`pushView` helper in `util/navigator.dart`); dialogs via `showDialog`; bottom sheets via `showModalBottomSheet`; snackbars via global `scaffoldMessengerKey`.
- Screen-local reactive state (`Rx`/`Obx` in views) converted to `setState`; reactive widgets are now `ConsumerWidget`/`ConsumerStatefulWidget`.
- Market data sources: heatmap structure still Finviz/Nasdaq; percents now Alpaca live or Finviz fallback. Removed the dead 5-second polling chain (controller → use case → repo → service).
- **Market tab rework**: the old single-heatmap "Map" tab is now a Market tab with heatmap, sector performance list (tap → sector detail with sparklines), and movers entry points; the Screener entry moved here from Settings.
- `SectorDetailView` revived with per-symbol sparklines and change percents; `FinancialView` re-enabled in the stock detail page.
- Favorite swipe-delete and the edit (reorder) flow are wired to the controller — previously no-op callbacks.
- Event calendar `lastDay` is now dynamic (was pinned to 2024); news search directory renamed to `search_view/` (was `search_view.dart/`).
- Refresh chains (favorites, indices, market data/status, news) keep the last-known state on network errors; market-status timer no longer schedules negative durations and no longer spams the "Market is Opened!" snackbar.
- Repo layer returns typed models across all four domains — JSON parsing no longer leaks above `repo/`; typo methods renamed (`requestStockChart`, `requestStockCompany`, `requestDividendEventList`); deprecated unused `requestStock` removed.

### Removed

- `get` dependency.
- Dead experimental `SectorView` (superseded by the `any_treemap` heatmap).

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

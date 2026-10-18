# Architecture

This document describes the layering, ownership rules, and data flow of the `investing` app. For specific past decisions see the [ADR index](adr/README.md).

## Overview

The app is a single-module Flutter application structured as a strict one-way layered architecture. Every feature (stock watch list, news, calendar, market map, settings) follows the same slice through the layers.

```
┌────────────────────────────────────────────────────────────┐
│ view/            Feature screens (ConsumerWidget, setState)│
├────────────────────────────────────────────────────────────┤
│ controller/      Riverpod Notifiers — immutable state      │
├────────────────────────────────────────────────────────────┤
│ use_case/        Feature orchestration, one class per feed │
├────────────────────────────────────────────────────────────┤
│ repo/            Interfaces + implementations per domain   │
├──────────────────────────┬─────────────────────────────────┤
│ data/service/ (dio)      │ data/db/ (Hive CE)              │
│ api.nasdaq.com            │ favorite list, settings cache   │
└──────────────────────────┴─────────────────────────────────┘
```

Dependencies point downward only. A repo must not import a controller; a service must not import a repo.

## Layers

### View (`lib/view/`)

Screens grouped by feature (`stock_view/`, `news_view/`, `event_view/`, `market_view/`, `home_view/`, `setting_view/`). Views watch provider state via `ref.watch` (`ConsumerWidget`/`ConsumerStatefulWidget`) and dispatch user actions with `ref.read(...Provider.notifier)`. Screen-local state uses plain `setState`. Navigation goes through the `pushView` helper (`util/navigator.dart`). Reusable components live in `lib/widget/`.

### Controller (`lib/controller/`)

One Riverpod `Notifier` per feature, colocated with its `NotifierProvider` in the same file. Notifiers obtain their use case by watching the layer's provider:

```dart
class NewsController extends Notifier<List<News>> {
  late final NewsUseCase useCase;

  @override
  List<News> build() {
    useCase = ref.watch(newsUseCaseProvider); // static provider — build runs once
    return [];
  }
}
```

State is an immutable class (`Equatable` + `copyWith`) for multi-field controllers (`StockState`, `MarketState`, `EventState`); single-value controllers use the value directly (`ThemeMode`, `PageType`, `List<News>`).

### Use case (`lib/use_case/`)

Thin orchestration layer. `abstract class UseCase<T extends Repo>` holds one repository and forwards `init()`. Use cases combine repo calls for a single feature action (e.g. "refresh index list" = cache read + network refresh).

### Repository (`lib/repo/`)

Each domain has a library pair:

* `xxx_repo.dart` — `abstract class XxxRepo extends Repo` (public contract) + imports shared by the implementation + the `xxxRepoProvider` declaration,
* `xxx_impl.dart` — `class XxxImpl extends XxxRepo`, declared as `part of 'xxx_repo.dart';`.

Repos map raw service responses into domain models (`model/`) and own caching policy (Hive box reads/writes, stream updates).

### Data sources (`lib/data/`)

* `service/` — `IVService` wraps a `dio` instance with a shared `get(url, query)` and error logging. Domain services (`StockService`, `NewsService`, `EventService`, `MarketService`) are thin URL builders against `api.nasdaq.com` / Finviz. `AlpacaService` is separate: previous-close snapshots (REST) and a reconnecting IEX quote websocket, credentials from the gitignored `assets/config/alpaca.json` via `IVConfig` (see [ADR-0006](adr/0006-alpaca-realtime-quotes.md)).
* `db/` — `IVDataBase` opens a named Hive CE box (`Hive.initFlutter` is called in `main()`). Boxes: `Favorite` (watch list), `MarketPercent` (last-known-good heatmap cache).
* `config.dart` — `IVConfig`, loaded once in `main()` from a gitignored asset; empty values mean "feature disabled".

### Models (`lib/model/`)

Equatable classes with `factory Xxx.fromMap(dynamic)` constructors. Parsing stops at the repo boundary; layers above only see typed models. Market data is a recursive composite: `MarketData → MarketSector → MarketItem` sharing abstract `Market<T>` with `sumValue` aggregation.

## Data flow example — stock search

```
StockSearchView (input, ConsumerWidget)
  → StockSearchController.search(query)        [ref.read(...notifier)]
    → StockUseCase.searchStockList(query)
      → StockImpl.searchStockList(query)
        → StockService.searchStock(query)         [dio GET /api/search/site]
      ← List<Stock> (fromMap parsed)
    ← state = result
  ← ref.watch(stockSearchControllerProvider) rebuild
```

## App shell

`main.dart` wraps a `MaterialApp` in a `ProviderScope`, watches `settingControllerProvider` for `themeMode`, wires the global `scaffoldMessengerKey` (so controllers can show snackbars), and shows `HomeView` as the tab shell over the feature views.

## Testing

Pure notifiers (`SettingController`, `HomeController`) are unit-tested with a bare `ProviderContainer` (`test/controller_test.dart`). Notifiers that start network or Hive IO in `build()` (news, event, market, stock) deadlock `flutter_test` fake async the same way the old GetX controllers did — don't watch them in plain tests; test models/leaf widgets, or wrap real IO in `tester.runAsync`. Full conventions and copy-paste patterns live in [TESTING.md](TESTING.md). One exception runs for real: `test/alpaca_service_test.dart` hits the live Alpaca REST API when the gitignored `assets/config/alpaca.json` is present, and auto-skips otherwise (CI-safe).

## Build & release

* Android: AGP 8.13.0, Gradle 8.14.3, Kotlin 2.4.0, JDK 17 (see [ADR-0004](adr/0004-github-actions-release-signing.md) for why AGP is not 9.x yet).
* CI (`.github/workflows/ci.yml`): analyze + test + debug APK on every push/PR.
* Release (`.github/workflows/release.yml`): `v*` tag → keystore restore from secrets → signed release APK → GitHub Release.

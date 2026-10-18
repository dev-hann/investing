# Architecture

This document describes the layering, ownership rules, and data flow of the `investing` app. For specific past decisions see the [ADR index](adr/README.md).

## Overview

The app is a single-module Flutter application structured as a strict one-way layered architecture. Every feature (stock watch list, news, calendar, market map, settings) follows the same slice through the layers.

```
┌────────────────────────────────────────────────────────────┐
│ view/            Feature screens (StatefulWidget, Obx)     │
├────────────────────────────────────────────────────────────┤
│ controller/      GetX controllers — Rx state + actions     │
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

Screens grouped by feature (`stock_view/`, `news_view/`, `event_view/`, `market_view/`, `home_view/`, `setting_view/`). Views read controller state through `Obx`/`Get.find` and dispatch user actions to controller methods. Reusable components live in `lib/widget/`.

### Controller (`lib/controller/`)

One `GetX` controller per feature. All controllers extend the project base class:

```dart
abstract class Controller<T extends UseCase> extends GetxController {
  Controller(this.useCase);
  final T useCase;
  Future get loading;           // completes when onReady fired
  Future<O?> bottomSheet<O>(...);
  Future<O> showOverlay<O>(...);
  static T put<T extends Controller>(T controller); // Get.put wrapper
}
```

Controllers expose `Rx` state (`RxList`, `RxMap`, …), perform no HTTP calls themselves, and are registered in `main.dart` via `initialBinding: BindingsBuilder(...)`.

### Use case (`lib/use_case/`)

Thin orchestration layer. `abstract class UseCase<T extends Repo>` holds one repository and forwards `init()`. Use cases combine repo calls for a single feature action (e.g. "refresh index list" = cache read + network refresh).

### Repository (`lib/repo/`)

Each domain has a library pair:

* `xxx_repo.dart` — `abstract class XxxRepo extends Repo` (public contract) + imports shared by the implementation,
* `xxx_impl.dart` — `class XxxImpl extends XxxRepo`, declared as `part of 'xxx_repo.dart';`.

Repos map raw service responses into domain models (`model/`) and own caching policy (Hive box reads/writes, stream updates).

### Data sources (`lib/data/`)

* `service/` — `IVService` wraps a `dio` instance with a shared `get(url, query)` and error logging. Domain services (`StockService`, `NewsService`, `EventService`, `MarketService`) are thin URL builders against `api.nasdaq.com`.
* `db/` — `IVDataBase` opens a named Hive CE box (`Hive.initFlutter` is called in `main()`).

### Models (`lib/model/`)

Equatable classes with `factory Xxx.fromMap(dynamic)` constructors. Parsing stops at the repo boundary; layers above only see typed models. Market data is a recursive composite: `MarketData → MarketSector → MarketItem` sharing abstract `Market<T>` with `sumValue` aggregation.

## Data flow example — stock search

```
StockSearchView (input)
  → StockSearchController.search(query)
    → StockUseCase.searchStockList(query)
      → StockImpl.searchStockList(query)
        → StockService.searchStock(query)         [dio GET /api/search/site]
      ← List<Stock> (fromMap parsed)
    ← Stream<List<Stock>>
  ← Obx rebuild
```

## App shell

`main.dart` builds a `GetMaterialApp` with light/dark Material 3 themes (orange primary), registers all controllers in `initialBinding`, and shows `HomeView` as the tab shell over the feature views.

## Testing

Controllers start real network and Hive IO in `onInit`, so full-app widget tests deadlock under `flutter_test` fake async. Current suite covers model parsing (`test/widget_test.dart`). Prefer model/leaf-widget tests, or wrap real IO in `tester.runAsync` when adding tests.

## Build & release

* Android: AGP 8.13.0, Gradle 8.14.3, Kotlin 2.4.0, JDK 17 (see [ADR-0004](adr/0004-github-actions-release-signing.md) for why AGP is not 9.x yet).
* CI (`.github/workflows/ci.yml`): analyze + test + debug APK on every push/PR.
* Release (`.github/workflows/release.yml`): `v*` tag → keystore restore from secrets → signed release APK → GitHub Release.

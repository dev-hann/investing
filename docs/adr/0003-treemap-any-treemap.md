# ADR-0003: Replace `treemap` with `any_treemap` for the market heatmap

- **Date:** 2026-10-18
- **Status:** Accepted

## Context

The S&P500 heatmap (`market_view.dart`) used the abandoned `treemap` package (last release 2021, SDK-capped below Dart 3). Candidates: `any_treemap` (actively maintained, declarative API), `syncfusion_flutter_treemap` (feature-rich, commercial license), or vendoring the old source as a local package. The old view also carried dead code: a non-treemap sector list rendering and an unused percent-based color helper.

## Decision

Adopt `any_treemap ^4.0.0` and rewrite `market_view.dart` around its declarative pipeline: build `TreemapNode<String>` per sector/stock from `MarketData` composites, `TreemapNormalizer.normalize` once per data change, then render `TreemapChart` with `TreemapTiles` + `TreemapCanvasLabels` inside a rotated bounded parent. Leaf tiles take a direct `Color` from the existing percent-threshold helper (`stockColor`), with `IVColor.blueGrey` as the neutral fallback — wiring the Finviz-style coloring that was previously dead code. The dead sector-list branch was deleted.

## Consequences

- The heatmap is colored by real-time percent change and driven by a maintained package (updated 2026-10).
- Color/label styling now comes from `any_treemap`'s layers, so future restyles are configuration, not custom paint.
- `any_treemap` requires finite chart bounds and Flutter ≥3.32 — constrains future Flutter minimums slightly.
- Weights come from `sumValue` (market-cap-ish ints); if the data source later supplies cleaner weights, only the node builder changes.

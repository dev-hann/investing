# ADR-0006: Live market heatmap via Alpaca IEX WebSocket

- **Date:** 2026-10-18
- **Status:** Accepted

## Context

The market heatmap's percent data had two problems:

1. **Never live.** `MarketController` owned a 5-second polling loop
   (`refreshMarketPercentRealTimeData`, batched 100 symbols per Nasdaq request)
   that nothing invoked — the startup call was commented out — so
   `marketPercentData` stayed empty and every heatmap tile rendered the
   fallback color.
2. **No offline story.** Nothing persisted percent data, so a cold start with
   no network showed an uncolored map.

The planned real-time redesign (ADR-0005 follow-up) chose Alpaca over
Finnhub: the most generous free-tier real-time US equity feed. The free tier
serves the **IEX feed** (subset of consolidated volume), which is acceptable
for a personal heatmap.

## Decision

Add an `AlpacaService` (`data/service/`) that talks to Alpaca's IEX
data — REST snapshots for previous closes and a WebSocket for live quotes —
and wire it through the existing layers into `MarketController`:

- **Credentials are compile-time only.** `--dart-define=ALPACA_KEY=…` /
  `--dart-define=ALPACA_SECRET=…`, read via `String.fromEnvironment`. Keys are
  never written to any file in the repository (same discipline as
  `android/key.properties`).- **Percent math is exact, not drift-prone.** Live percent is computed as
  `(midPrice / previousClose − 1) × 100` where previous closes come from a
  batched snapshot request at subscribe time — no accumulating error relative
  to an initial fetch.
- **Graceful degradation.** Without both defines, `isConfigured` is false:
  the websocket path yields nothing and the controller falls back to a single
  Finviz percent fetch (`map_perf.ashx`) — still an improvement over the
  previous never-loaded state.
- **Last-known-good caching.** The merged percent map persists to a Hive box
  (`MarketPercent`), debounced to one write per 5 seconds of quiet. On
  startup the cache is applied to state *before* any network call, so the
  heatmap is colored instantly and survives offline starts. Empty responses
  never wipe the cache.
- **Reconnect.** The stream client reconnects every 5 seconds after a drop;
  subscription batches are chunked at 200 symbols.

The obsolete polling chain was deleted end-to-end:
`MarketController.refreshMarketPercentRealTimeData` →
`MarketUseCase.refreshMarketPercentRealTimeData` →
`MarketRepo.requestMarketPercentRealTimeData` →
`MarketService.requestStockList`.

## Consequences

- The heatmap now colors from cache instantly, then switches to live values
  when credentials exist and the market is open.
- IEX-only quotes mean sparse pre/post-market updates and no quotes while all
  venues are closed — the map simply holds last-known values.
- New test surface: pure percent math, `Quote` parsing, and the controller
  fallback path via a fake repo (`test/market_test.dart`); a live REST smoke
  test that auto-skips without credentials (`test/alpaca_live_test.dart`).
- Trading hours matter: the websocket delivers nothing on closed days, so
  live quote handling was verified at the protocol level (connect/auth/
  subscribe) plus the live REST test; first open-market run should be
  observed on a device.

## Update (2026-10-18) — credential delivery

Replaced the `--dart-define` mechanism with a **gitignored config asset**:
credentials live in `assets/config/alpaca.json` (gitignored, with a
committed `alpaca.example.json` template and `README.md` keeping the asset
directory alive in git), loaded once in `main()` by `IVConfig`
(`lib/data/config.dart`). Everything else stands. Rationale: plain
`flutter run`/`flutter test` now picks keys up automatically; CI and fresh
clones still build without the file and keep the non-live fallback. The
live smoke test moved to `test/alpaca_service_test.dart` and reads the same
file, auto-skipping when it is absent.


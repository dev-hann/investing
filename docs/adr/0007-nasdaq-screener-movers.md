# ADR-0007: Market movers via the keyless Nasdaq screener endpoint

- **Date:** 2026-10-18
- **Status:** Accepted

## Context

The app had no way to browse daily movers (top gainers / losers / most active) — a standard section in reference apps (Yahoo Finance, Investing.com). The existing data sources are the keyless Nasdaq public API (quotes, news, calendars, financials) plus Finviz (heatmap) and Alpaca (live quotes). Adding movers meant choosing an endpoint that fits the keyless constraint and the existing layered stack (`service → repo → use_case → controller → view`), without a new dependency or credential.

## Decision

We use the Nasdaq screener endpoint `GET https://api.nasdaq.com/api/screener/stocks?tableonly=true&limit=40&offset=0&marketstatus={gainers|losers|mostactive}` — same host, same keyless contract and `{data: {rows: [...]}}` envelope as the rest of the Nasdaq calls. `MarketService.requestMovers` performs the call, `MarketRepo.requestMovers` parses rows into `Stock` models (raw maps never leave the repo layer), and `MarketMoverCategory` (`model/market.dart`) models the three categories. The `MoversView` tab screen (Advancers / Decliners / Most Active) is reachable from the reworked Market tab.

## Consequences

- No new dependency or API key; the endpoint inherits the browser-header and rCode handling already enforced in `IVService`.
- The endpoint is undocumented and rate-limited like the rest of the Nasdaq public API; failure degrades to an empty list with an in-screen retry rather than crashing.
- Row field names (`lastsale`, `netchange`, `pctchange`) are parsed defensively via `IVNumberFormat`; schema drift only zeroes prices, it does not throw.
- If the endpoint ever disappears, only `MarketService.requestMovers` + `MarketRepo.requestMovers` need repointing — the view/controller contracts stay.

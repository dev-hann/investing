# ADR-0002: Migrate to Dart 3 with community package forks

- **Date:** 2026-10-18
- **Status:** Accepted

## Context

Flutter tooling moved to 3.47 / Dart 3.13 while the app pinned `sdk: >=2.19.3 <3.0.0` — it could not even `pub get` with a current toolchain. Five runtime dependencies had upper bounds excluding Dart 3: `hive`, `hive_flutter`, `pull_to_refresh`, `auto_size_text`, `treemap`. Staying on Dart 2 was not an option (no toolchain support).

## Decision

Migrate the SDK constraint to `^3.13.0`, bump all compatible dependencies to latest, and replace the five incompatible packages with maintained equivalents:

| Old (Dart 2 only) | Replacement | Migration cost |
|---|---|---|
| `hive` / `hive_flutter` | `hive_ce` / `hive_ce_flutter` | imports only — API identical |
| `pull_to_refresh` | `pull_to_refresh_flutter3` | imports only — API identical |
| `auto_size_text` | `auto_size_text_plus` | imports only — widget name identical |
| `treemap` | `any_treemap` | full rewrite of `market_view.dart` (see ADR-0003) |

`equatable` stays on 2.x because `fl_chart 1.x` requires `^2.0.7`.

## Consequences

- App builds and analyzes clean on Flutter 3.47.5 / Dart 3.13; 59 lockfile entries updated.
- Dart 3 class-modifier fixes were required (`Comparable` → `implements`, `final class` for `LinkedListEntry` subclasses), plus `WebUri` for flutter_inappwebview 6 and `*ThemeData` renames.
- Community forks carry abandonment risk; before any Flutter upgrade, re-check whether upstreams revived (then prefer upstream) — record as a new ADR.
- `dart fix --apply` on this `part of` codebase breaks part directives and deletes part-only imports (documented in AGENTS.md pitfalls); always analyze + restore from `git diff` afterwards.

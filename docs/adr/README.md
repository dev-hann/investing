# Architecture Decision Records

ADRs capture *why* the codebase looks the way it does. Each record is immutable once accepted; superseding a decision creates a new ADR that links back and marks the old one as superseded.

## Index

| # | Title | Status | Date |
|---|---|---|---|
| [0001](0001-getx-layered-architecture.md) | GetX-based one-way layered architecture | Accepted | 2023 (recorded 2026-10-18) |
| [0002](0002-dart3-migration.md) | Migrate to Dart 3 with community package forks | Accepted | 2026-10-18 |
| [0003](0003-treemap-any-treemap.md) | Replace `treemap` with `any_treemap` for the market heatmap | Accepted | 2026-10-18 |
| [0004](0004-github-actions-release-signing.md) | Tag-driven GitHub Actions releases with dedicated signing keystore | Accepted | 2026-10-18 |
| [0005](0005-getx-to-riverpod.md) | Replace GetX with Riverpod for state management and DI | Accepted | 2026-10-18 |

## Creating a new ADR

1. Copy [`_template.md`](_template.md) to `NNNN-short-title.md` (next free number, zero-padded).
2. Fill in all sections; keep it under one screen per section.
3. Add a row to the index above.
4. Update `CHANGELOG.md` in the same commit if user-visible.

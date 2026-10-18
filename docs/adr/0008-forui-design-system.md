# ADR-0008: Adopt Forui (shadcn-style) as the design system

- **Date:** 2026-10-18
- **Status:** Accepted

## Context

The app's visual style was hand-rolled: a `ThemeData.copyWith` in `main.dart` plus ad-hoc `IVColor` references scattered across ~40 view/widget files. Buttons, text fields and dialogs were raw Material widgets with per-file styling tweaks, so every new screen drifted slightly. Alternatives considered:

* **flex_color_scheme** — drop-in Material theming, lowest risk, but only unifies colors; component look stays stock Material.
* **pure Material 3** — no dependency, but every component theme is hand-maintained.
* **Forui** — a shadcn/ui-style kit (436+ likes, verified publisher, actively maintained, requires Flutter ≥3.44). Version 0.x (breaking-change risk), and it is built on the new standalone `material_ui` package, so `toApproximateMaterialTheme()` returns `material_ui`'s ThemeData — not directly assignable to flutter/material's `MaterialApp.theme`.

The owner chose the shadcn-style direction for a distinct, opinionated look.

## Decision

Adopt `forui 0.27.6` (pinned exact — 0.x may break on minor bumps) with a two-layer integration in `lib/const/theme.dart` (`IVTheme`):

1. **Forui layer**: `FThemeData` built from the neutral palette with the app orange as `primary` (light/dark, touch variants). `main.dart` wraps the app via `MaterialApp.builder` → `FTheme` → `FToaster` → `FTooltipGroup`, plus `FLocalizations` delegates. Works identically with Riverpod's `ConsumerWidget` root.
2. **Material layer**: because of the `material_ui` type mismatch (above), `IVTheme.materialLight/Dark` maps the same `FColors` (background, foreground, primary, muted, border, card, error) onto a flutter/material `ColorScheme`/`ThemeData`. All not-yet-migrated Material widgets (Scaffold, AppBar, ListTile, table_calendar, fl_chart…) inherit the Forui palette — consistency without rewriting every screen.

First component sweep: `CustomTextfield` → `FTextField`, `IVTextButton` → `FButton` (ghost), `IVAlert` → `FDialog`; wrappers keep the legacy parameter surface so call sites are unchanged. Market semantic colors (up/down green/red) stay in `IVColor` untouched — financial convention, not themeable chrome.

## Consequences

- New UI should use Forui widgets (`FButton`, `FTextField`, `FCard`, `FTile`, `FDialog`, …) styled by `FTheme`; Material widgets remain acceptable and stay palette-consistent via the Material layer.
- `forui` is 0.x: upgrades need a changelog review and possibly code changes; re-pin deliberately and record in an ADR if breaking.
- Two theme layers must stay in sync when the brand changes — both read from the same `FColors` instance in `IVTheme`, so changing the brand color is a single edit.
- `IVColor.stockColor` and the red/green families are exempt from theming forever.

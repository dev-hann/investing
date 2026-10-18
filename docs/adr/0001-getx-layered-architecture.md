# ADR-0001: GetX-based one-way layered architecture

- **Date:** 2023 (recorded retroactively 2026-10-18)
- **Status:** Accepted

## Context

The app grew several features (stock watch list, news, event calendar, market map, settings) each needing remote data, local caching, and UI state. An unstructured approach would scatter HTTP calls and parsing across widgets, making features impossible to test or reuse. The project chose GetX for state management and needed a layering that keeps GetX ergonomics without coupling UI to the network stack.

## Decision

Every feature slice flows through five one-way layers: `view → controller (GetX) → use_case → repo (interface + part-of impl) → data (dio services, Hive CE boxes)`. Base classes enforce ownership: `Controller<T extends UseCase>`, `UseCase<T extends Repo>`, `Repo`. Raw maps are parsed in repos into Equatable models; controllers expose only `Rx` state and action methods; dependency wiring happens once in `main.dart` bindings.

## Consequences

- Features are uniform — adding a feed means the same five small classes.
- Controllers stay testable in principle (use cases/repos are constructor-injected).
- The `part of` repo structure couples each interface to a single implementation file; acceptable now, but swapping implementations (e.g. a different data source) means editing the impl, not adding one — see ADR-0002 for the package-replacement practice this enabled.
- Full-app widget tests deadlock because controllers start IO in `onInit`; testing stays at model level for now.

# AGENTS.md

Guidelines for AI coding assistants working in this repository. Follow these rules when modifying code, reviewing changes, or answering questions about the project.

## Project

`investing` — a Flutter stock market information app (Android) backed by the Nasdaq public API (`api.nasdaq.com`). State management: GetX. Local storage: Hive CE. Networking: dio.

## Commands

```bash
flutter pub get          # install dependencies (run after checkout / pubspec changes)
flutter analyze          # MUST pass with 0 errors before committing
flutter test             # unit/smoke tests
flutter build apk --debug    # quick native build verification
flutter build apk --release  # signed release build (needs android/key.properties, falls back to debug signing)
```

Deployment is tag-driven: push a `v*` tag to trigger the Release workflow (GitHub Actions). Never commit `android/key.properties` or `*.keystore` — both are gitignored.

## Architecture (enforced layering)

Data flows one way. Never skip a layer or let a lower layer reference an upper one.

```
view/ (Widgets)
  → controller/ (GetX controllers, Rx state)
    → use_case/ (feature orchestration)
      → repo/ (interfaces + impls, part-of structure)
        → data/service/ (dio HTTP)  +  data/db/ (Hive CE)
          → api.nasdaq.com / local box
```

Rules:
* Controllers never call services directly — always through a use case + repo.
* Repos are declared as `abstract class XxxRepo` in `xxx_repo.dart`, implemented in `xxx_impl.dart` as a `part of` the repo library. Keep that structure when adding repos.
* Models live in `model/`, are `Equatable`, and parse via `factory Xxx.fromMap(...)`. Raw `Map<String, dynamic>` must not leak above the repo layer.
* New app-wide constants go in `const/` (colors) or `util/` (formatters).

## Known pitfalls

* **`dart fix --apply` + `part of`**: this codebase uses named-library `part of` files. `dart fix` may (a) break `part of X;` directives after removing library names and (b) delete imports in `*_repo.dart` that are only used by `*_impl.dart` parts. After running it, always `flutter analyze` and restore imports from `git diff` if part files broke.
* **equatable is pinned to 2.x**: `fl_chart 1.x` requires `equatable ^2.0.7`. Do not bump to 3.x until fl_chart allows it.
* **Android toolchain is pinned**: AGP 8.13.0 / Gradle 8.14.3 / Kotlin 2.4.0. AGP 9.x breaks `flutter_inappwebview_android 1.1.3` (removed `proguard-android.txt` support). Only bump after verifying that plugin released a fix.
* **Dart3-incompatible packages were replaced** — do not reintroduce: `hive` (→ `hive_ce`), `pull_to_refresh` (→ `pull_to_refresh_flutter3`), `auto_size_text` (→ `auto_size_text_plus`), `treemap` (→ `any_treemap`).
* **Full-app widget tests hang**: controllers start network/Hive IO in `onInit`, which deadlocks flutter_test's fake async. Test models/leaf widgets instead, or wrap real IO in `tester.runAsync`.

## Decision records (ADR)

Any non-trivial architectural decision (new dependency, layering change, build/toolchain change, data-source change) must be recorded in `docs/adr/` using the template, with the next free number, and linked from `docs/adr/README.md`. Update `CHANGELOG.md` in the same commit for user-visible changes.

## Commit style

Emoji prefix, English, imperative — e.g. `:rocket: ...` (release/infra), `:zap: Fix: ...` (bugfix), `:art: Feat: ...` (feature). Keep the existing history's style.

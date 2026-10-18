# AGENTS.md

Guidelines for AI coding assistants working in this repository. Follow these rules when modifying code, reviewing changes, or answering questions about the project.

## Project

`investing` — a Flutter stock market information app (Android) backed by the Nasdaq public API (`api.nasdaq.com`). State management: Riverpod (`flutter_riverpod`). Local storage: Hive CE. Networking: dio.

## Commands

```bash
flutter pub get          # install dependencies (run after checkout / pubspec changes)
dart format .            # formatter is enforced in CI (--set-exit-if-changed)
flutter analyze          # MUST report zero issues (info counts as failure in CI)
flutter test             # unit/smoke tests
flutter build apk --debug    # quick native build verification
flutter build apk --release  # signed release build (needs android/key.properties, falls back to debug signing)
```

## Strictness & conventions

`analysis_options.yaml` enables strict analyzer modes — `strict-casts`, `strict-inference`, `strict-raw-types` — plus an extended lint set on top of `flutter_lints`. Rules are never disabled to silence findings; fix the code instead.

* **JSON boundary**: values from `dynamic` JSON must be cast explicitly (`as String`, `as Map<String, dynamic>`, `as num` + `.toDouble()`). Preserve nullability exactly (`as String?` when the receiver is nullable). Bind through a typed local before indexing.
* **Fire-and-forget futures**: wrap intentional ones in `unawaited(...)` (`dart:async`). Navigation: `unawaited(pushView(context, ...))` from `util/navigator.dart`.
* **No raw generics**: `List()`/`Map`/`Future<List>` must carry type arguments (`List<Stock>()`, `Future<List<dynamic>>`).
* **Callbacks**: type as `void Function(Param)` (or `Future<void> Function(...)` when awaited), never bare `Function`.
* **Formatting**: `dart format` defaults (80 cols, trailing commas). CI rejects unformatted code.
* **Naming**: files are `snake_case.dart` matching the class they contain (`stock_summary.dart` holds `StockSummary`). Keep names typo-free — renames use `git mv` plus import updates.
* **pubspec**: dependencies sorted alphabetically including SDK deps (`sort_pub_dependencies`).

Deployment is tag-driven: push a `v*` tag to trigger the Release workflow (GitHub Actions). Never commit `android/key.properties` or `*.keystore` — both are gitignored.

## Architecture (enforced layering)

Data flows one way. Never skip a layer or let a lower layer reference an upper one.

```
view/ (Widgets — ConsumerWidget/ConsumerStatefulWidget, ref.watch)
  → controller/ (Riverpod Notifiers, immutable state + NotifierProvider)
    → use_case/ (feature orchestration)
      → repo/ (interfaces + impls, part-of structure; xxxRepoProvider declared here)
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
* **Full-app widget tests hang**: notifiers (news/event/market/stock) start network/Hive IO in `build()`, which deadlocks flutter_test's fake async. Test pure notifiers with a bare `ProviderContainer` (see `test/controller_test.dart`), test models/leaf widgets, or wrap real IO in `tester.runAsync`.
* **Notifier/use-case convention**: notifiers bind `late final useCase = ref.watch(xxxUseCaseProvider)` in `build()` — this only works because use-case providers are static (`Provider`, never rebuilt). Never make them depend on mutable state, or `late final` reassignment throws.

## Decision records (ADR)

Any non-trivial architectural decision (new dependency, layering change, build/toolchain change, data-source change) must be recorded in `docs/adr/` using the template, with the next free number, and linked from `docs/adr/README.md`. Update `CHANGELOG.md` in the same commit for user-visible changes.

## Commit style

Emoji prefix, English, imperative — e.g. `:rocket: ...` (release/infra), `:zap: Fix: ...` (bugfix), `:art: Feat: ...` (feature). Keep the existing history's style.

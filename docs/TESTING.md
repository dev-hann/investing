# Testing Guide

How the `investing` app is tested, and the patterns to follow when adding tests. Layer context lives in [ARCHITECTURE.md](ARCHITECTURE.md); the state-management rationale is [ADR-0005](adr/0005-getx-to-riverpod.md).

## Principles

1. **Hermetic by default.** A test must not reach `api.nasdaq.com` or open real Hive boxes. Anything that does IO gets a fake (see *Overriding repos* below).
2. **The fake-async trap.** Notifiers `News`/`Event`/`Market`/`Stock` start network or Hive IO inside `build()`. Watching them from a plain `test()`/`testWidgets()` deadlocks `flutter_test`'s fake async (the clock never advances past the pending IO). This is inherited from the GetX era and still true — see the pitfalls in `AGENTS.md`.
3. **CI gates every push**: `flutter analyze` (0 issues, info counts) + `flutter test` + debug APK build (`.github/workflows/ci.yml`).

## What to test per layer

| Layer | Testable? | How |
|---|---|---|
| `model/` | Always | Plain `test()` on `fromMap` factories — no IO exists here. See `test/widget_test.dart` |
| `controller/` (pure notifiers: `Setting`, `Home`) | Yes | Bare `ProviderContainer` — see pattern 1 |
| `controller/` (IO notifiers: `News`, `Event`, `Market`, `Stock`) | Yes, with fakes | Override the repo provider — see pattern 2 |
| `view/` + `widget/` | Leaf widgets | `testWidgets` with constructors-injected data; wrap unavoidable IO in `tester.runAsync` |
| `repo/`, `data/` | Integration territory | Skip until there is a contract worth pinning; services are thin URL builders |

## Patterns

### 1. Pure notifier test — `test/controller_test.dart`

```dart
test('SettingController changes theme mode', () {
  final container = ProviderContainer();
  addTearDown(container.dispose);

  expect(container.read(settingControllerProvider), ThemeMode.system);

  container.read(settingControllerProvider.notifier).themeMode =
      ThemeMode.dark;
  expect(container.read(settingControllerProvider), ThemeMode.dark);
});
```

No widget tree, no `ProviderScope`, no fake async involved. Read state with
`container.read(provider)`; drive actions through
`container.read(provider.notifier)`.

### 2. Overriding repos for IO notifier tests

Repo providers are ordinary `Provider<XxxRepo>`s, so a fake repo makes an IO
notifier hermetic:

```dart
class FakeNewsRepo extends NewsRepo {
  @override
  Future<dynamic> requestNewsList(int page) async => [
        {'title': 't', 'publisher': 'p'},
      ];
  // ...remaining members: throw UnimplementedError()
}

test('NewsController loads first page', () async {
  final container = ProviderContainer(
    overrides: [newsRepoProvider.overrideWithValue(FakeNewsRepo())],
  );
  addTearDown(container.dispose);

  // Providers are lazy: read once to initialize the notifier, then drain
  // the microtask-scheduled initial fetch.
  container.read(newsControllerProvider);
  await Future<void>.delayed(Duration.zero);

  expect(container.read(newsControllerProvider), isNotEmpty);
});
```

Notes:
- Fake the **repo**, not the use case — the use case owns the parsing you want covered.
- The fake must return *already-parsed-shaped* raw maps (`List<dynamic>`, `Map<String, dynamic>`); `dynamic` JSON boundary rules apply here too.
- `NewsController.build()` kicks its first fetch via `Future.microtask`, hence the `Duration.zero` drain. Watch out for `_init()` chains in `StockController` (Hive `init()` first) — drain with a longer pump or make the fake's `init()` a no-op (it is, by default, on `Repo`).

### 3. Widget tests that must touch real async

Wrap the real IO in `tester.runAsync` so the fake-async clock is suspended
while the future resolves:

```dart
testWidgets('leaf widget', (tester) async {
  await tester.runAsync(() async {
    await tester.pumpWidget(const LeafWidget());
    await tester.pump();
  });
});
```

### 4. What not to do

- Do **not** `pumpWidget` the app shell or `HomeView` — the tab shell mounts
  IO notifiers immediately and hangs the suite.
- Do **not** make `xxxUseCaseProvider` depend on mutable state just for tests —
  controllers bind use cases into `late final` fields, which throws on rebuild
  (`AGENTS.md` pitfalls).

## Running

```bash
flutter test                     # everything
flutter test test/controller_test.dart   # one file
flutter test --coverage          # lcov.info (not yet wired into CI)
```

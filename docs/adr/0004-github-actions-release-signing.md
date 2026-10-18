# ADR-0004: Tag-driven GitHub Actions releases with dedicated signing keystore

- **Date:** 2026-10-18
- **Status:** Accepted

## Context

The repo had no CI and no release story; Android used the pre-Flutter-3.29 Gradle setup (`apply from: flutter.gradle`) that current Flutter cannot build at all. The first regenerated template pinned AGP 9.1.0, which broke the only native plugin (`flutter_inappwebview_android 1.1.3` uses `getDefaultProguardFile('proguard-android.txt')`, removed in AGP 9 — only 6.2.0-beta fixes it). Distribution target is sideloading for personal use, so GitHub Releases suffice; Google Play is unnecessary.

## Decision

1. **Toolchain pin:** AGP 8.13.0 / Gradle 8.14.3 / Kotlin 2.4.0 / JDK 17 — latest stable combination that builds every current dependency. Revisit when `flutter_inappwebview_android` ships a stable AGP-9-compatible release.
2. **CI** (`.github/workflows/ci.yml`): on `main` push and PRs — `pub get`, `analyze`, `test`, debug APK build (catches native breakage like the AGP issue at PR time). Flutter pinned to 3.47.5.
3. **Release** (`.github/workflows/release.yml`): on `v*` tag — restore keystore from `KEYSTORE_BASE64` secret, write `android/key.properties` from secrets, build release APK, publish as a GitHub Release asset named `investing-<tag>-release.apk`.
4. **Signing:** dedicated keystore (`investing-release.keystore`, alias `investing`, RSA 2048, 10000 days) generated locally, registered as four GitHub Secrets. `build.gradle.kts` uses it when `key.properties` exists and falls back to debug signing otherwise, so local builds need no secrets. Keystore and `key.properties` are gitignored and never committed.

## Consequences

- `git tag vX.Y.Z && git push origin vX.Y.Z` produces an installable, consistently-signed APK; signature stability across versions is guaranteed by the fixed keystore (backed up by the owner — losing it permanently blocks update installs).
- CI fails fast on analyze/test/build regressions before they reach a release.
- Tag-based releases imply README badge drift if workflow filenames change; keep filenames stable.
- AGP stays behind latest; upgrades require checking plugin compatibility first (recorded in AGENTS.md pitfalls).

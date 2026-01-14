# Build Guide

This document covers all build commands, testing, and version configuration for the KMPandAI project.

## Build Commands

Use `./gradlew` on macOS/Linux or `.\gradlew.bat` on Windows for all commands.

### Android

- Build: `./gradlew :androidApp:assembleDebug`
- Build release: `./gradlew :androidApp:assembleRelease`
- Lint: `./gradlew :androidApp:lintDebug`

### Desktop (JVM)

- Run: `./gradlew :composeApp:run`
- Package: `./gradlew :composeApp:packageDistributionForCurrentOS`

### Server (Ktor)

- Run: `./gradlew :server:run`
- Run in dev mode: `./gradlew :server:run -Pdevelopment`

### Web

- Wasm (modern browsers): `./gradlew :composeApp:wasmJsBrowserDevelopmentRun`
- JS (older browsers): `./gradlew :composeApp:jsBrowserDevelopmentRun`

### iOS

- Open `/iosApp` directory in Xcode, or use IDE run configurations
- Framework name: `ComposeApp` (static framework)
- Supported targets: `iosArm64`, `iosSimulatorArm64`

## Testing

- Run all tests: `./gradlew test`
- Run specific module tests: `./gradlew :shared:test` or `./gradlew :server:test`
- Run common tests: `./gradlew :composeApp:commonTest` or `./gradlew :shared:commonTest`

## Code Quality

### Static Analysis

- Run Detekt: `./gradlew detekt`
- Generate Detekt baseline: `./gradlew detektBaseline`

### Code Formatting

- Format all Kotlin files: `./scripts/ktfmt.sh --all`
- Format only changed files: `./scripts/ktfmt.sh --changed`
- Format changed files vs specific branch: `./scripts/ktfmt.sh --changed --base-branch develop`
- Install pre-commit hook (one-time setup): `./scripts/setup-hooks.sh`

**Note:** Pre-commit hook automatically formats staged Kotlin files before commit. To bypass: `git commit --no-verify`

## Version Configuration

All versions are managed in `gradle/libs.versions.toml`:

- **Android Gradle Plugin (AGP):** 9.0.0-rc03
- **Gradle:** 9.3.0-rc-3
- **Kotlin:** 2.3.0
- **Compose Multiplatform:** 1.10.0
- **Detekt:** 2.0.0-alpha.1
- **Ktfmt:** 0.61 (maintained in scripts, not version catalog)
- **Ktor:** 3.3.3
- **Android SDK:** compileSdk 36, minSdk 24, targetSdk 36
- **JVM Target:** Java 11

## Important Build Notes

- Use version catalog references (`libs.`) in build files, not hardcoded versions
- Android modules use Java 11 compatibility (`JvmTarget.JVM_11` or `sourceCompatibility/targetCompatibility`)
- iOS framework is static (`isStatic = true`)
- Compose Hot Reload is bundled in Compose Multiplatform 1.10.0 (no separate plugin needed)
- Server uses typesafe project accessors (enabled in `settings.gradle.kts`)
- AGP 9.0+ has built-in Kotlin support - **do not** use `org.jetbrains.kotlin.android` plugin in Android application modules
- KMP modules with Android targets must use `com.android.kotlin.multiplatform.library` plugin
- Android configuration in KMP modules uses `kotlin { androidLibrary { } }` instead of top-level `android { }`
- Detekt static analysis is configured via build-logic convention plugin for all modules
- Ktfmt code formatting uses Kotlinlang style (4-space indent, 120-char line length) configured in `.editorconfig`
- Pre-commit hook automatically formats Kotlin files on commit

## Build Verification

After making code changes, verify the build works by running:

```bash
./gradlew assembleDebug
./gradlew lintDebug
./gradlew detekt
./gradlew test
```

See [DEVELOPMENT-RULES.md](DEVELOPMENT-RULES.md) for detailed build verification requirements.

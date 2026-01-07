# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Kotlin Multiplatform project (KMPandAI) targeting multiple platforms: Android, iOS, Web (JS/Wasm), Desktop (JVM), and Server (Ktor). The project demonstrates KMP capabilities alongside AI and agentic development.

Package namespace: `io.petros.kmp.ai`

## Build Commands

Use `./gradlew` on macOS/Linux or `.\gradlew.bat` on Windows for all commands.

### Android
- Build: `./gradlew :androidApp:assembleDebug`
- Build release: `./gradlew :androidApp:assembleRelease`

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

### Testing
- Run all tests: `./gradlew test`
- Run specific module tests: `./gradlew :shared:test` or `./gradlew :server:test`
- Run common tests: `./gradlew :composeApp:commonTest` or `./gradlew :shared:commonTest`

## Architecture

### Module Structure

**Four main modules following AGP 9.0+ KMP architecture:**

1. **`/androidApp`** - Android-specific application module
   - Pure Android application module using `com.android.application` plugin
   - Contains MainActivity as the Android entry point
   - Depends on `/composeApp` for UI
   - Namespace: `io.petros.kmp.ai.android`

2. **`/composeApp`** - Compose Multiplatform UI library
   - KMP library using `com.android.kotlin.multiplatform.library` plugin
   - Contains all UI code shared across Android, iOS, Desktop, and Web
   - Uses `androidLibrary {}` configuration block (inside `kotlin {}`) instead of top-level `android {}`
   - Depends on `/shared` module for business logic
   - Main class for Desktop: `io.petros.kmp.ai.MainKt`
   - Targets: Android, iOS, Desktop (JVM), Web (JS/Wasm)

3. **`/shared`** - Shared business logic library
   - KMP library using `com.android.kotlin.multiplatform.library` plugin
   - Pure Kotlin Multiplatform library (no Compose dependency)
   - Uses `androidLibrary {}` configuration block (inside `kotlin {}`) instead of top-level `android {}`
   - Platform abstraction layer (`Platform.kt`, `Greeting.kt`, `Constants.kt`)
   - Shared across all platforms including server
   - Targets: Android, iOS, JVM, JS, Wasm

4. **`/server`** - Ktor backend application
   - JVM-only Ktor server using Netty engine
   - Depends on `/shared` for shared business logic
   - Default port defined in `SERVER_PORT` constant
   - Main class: `io.petros.kmp.ai.ApplicationKt`

### Source Set Organization

`composeApp` and `shared` follow KMP sourceSet conventions with `androidLibrary` configuration:
- `commonMain/` - Code shared across all platforms
- `androidMain/` - Android-specific implementations
- `iosMain/` - iOS-specific implementations (shared between arm64 and simulator)
- `jvmMain/` - Desktop/JVM-specific implementations
- `jsMain/` - JavaScript-specific implementations
- `wasmJsMain/` - WebAssembly-specific implementations
- `commonTest/` - Shared test code

**Key architectural principles:**
- Platform-specific implementations should be minimal. Most logic belongs in `commonMain`
- Use `expect`/`actual` for platform differences
- Android configuration now lives inside `kotlin { androidLibrary { } }` block, not at top level
- Android app logic is separated into its own `androidApp` module

### Dependency Flow

```
androidApp (Android) ──> composeApp (KMP library) ──> shared (KMP library)
server (JVM) ──────────────────────────────────────> shared (KMP library)
```

The separation of `androidApp` from `composeApp` is required by AGP 9.0+. The Android application consumes the KMP library, which keeps the Compose UI code truly multiplatform.

## Version Configuration

All versions are managed in `gradle/libs.versions.toml`:
- Android Gradle Plugin (AGP): 9.0.0-rc02
- Gradle: 9.2.1
- Kotlin: 2.3.0
- Compose Multiplatform: 1.9.3
- Ktor: 3.3.3
- Android SDK: compileSdk 36, minSdk 24, targetSdk 36
- JVM Target: Java 11

## Important Notes

- Use version catalog references (`libs.`) in build files, not hardcoded versions
- Android modules use Java 11 compatibility (`JvmTarget.JVM_11` or `sourceCompatibility/targetCompatibility`)
- iOS framework is static (`isStatic = true`)
- Compose Hot Reload is enabled for faster development iteration
- Server uses typesafe project accessors (enabled in `settings.gradle.kts`)
- AGP 9.0+ has built-in Kotlin support - **do not** use `org.jetbrains.kotlin.android` plugin in Android application modules
- KMP modules with Android targets must use `com.android.kotlin.multiplatform.library` plugin
- Android configuration in KMP modules uses `kotlin { androidLibrary { } }` instead of top-level `android { }`

## AGP 9.0+ Migration Notes

This project has been migrated to Android Gradle Plugin 9.0.0-rc02, which includes breaking changes:

### Key Changes Implemented

1. **New KMP Plugin Structure**: Both `composeApp` and `shared` now use `com.android.kotlin.multiplatform.library` plugin instead of `com.android.library`

2. **Android Configuration**: Android settings moved inside `kotlin` block:
   ```kotlin
   kotlin {
       androidLibrary {
           namespace = "..."
           compileSdk = ...
           minSdk = ...
           compilerOptions {
               jvmTarget.set(JvmTarget.JVM_11)
           }
       }
   }
   ```

3. **Separated Android App**: Android application logic moved to dedicated `/androidApp` module that consumes `/composeApp` as a dependency

4. **Built-in Kotlin Support**: AGP 9.0+ includes Kotlin support natively, so `org.jetbrains.kotlin.android` plugin is no longer needed (and will cause errors if used)

5. **Gradle Version**: Requires Gradle 9.1.0 or higher (using 9.2.1 stable)

### Migration Resources
- https://developer.android.com/kotlin/multiplatform/plugin
- https://kotl.in/gradle/agp-new-kmp
- https://kotl.in/kmp-project-structure-migration

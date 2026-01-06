# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Kotlin Multiplatform project (KMPandAI) targeting multiple platforms: Android, iOS, Web (JS/Wasm), Desktop (JVM), and Server (Ktor). The project demonstrates KMP capabilities alongside AI and agentic development.

Package namespace: `io.petros.kmp.ai`

## Build Commands

Use `./gradlew` on macOS/Linux or `.\gradlew.bat` on Windows for all commands.

### Android
- Build: `./gradlew :composeApp:assembleDebug`
- Build release: `./gradlew :composeApp:assembleRelease`

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

**Three main modules with distinct responsibilities:**

1. **`/composeApp`** - Compose Multiplatform UI application
   - Contains all UI code shared across Android, iOS, Desktop, and Web
   - Platform-specific entry points in respective sourceSet folders
   - Depends on `/shared` module for business logic
   - Main class for Desktop: `io.petros.kmp.ai.MainKt`

2. **`/shared`** - Shared business logic library
   - Pure Kotlin Multiplatform library (no Compose dependency)
   - Platform abstraction layer (`Platform.kt`, `Greeting.kt`, `Constants.kt`)
   - Shared across all platforms including server
   - Targets: Android, iOS, JVM, JS, Wasm

3. **`/server`** - Ktor backend application
   - JVM-only Ktor server using Netty engine
   - Depends on `/shared` for shared business logic
   - Default port defined in `SERVER_PORT` constant
   - Main class: `io.petros.kmp.ai.ApplicationKt`

### Source Set Organization

Both `composeApp` and `shared` follow KMP sourceSet conventions:
- `commonMain/` - Code shared across all platforms
- `androidMain/` - Android-specific implementations
- `iosMain/` - iOS-specific implementations (shared between arm64 and simulator)
- `jvmMain/` - Desktop/JVM-specific implementations
- `jsMain/` - JavaScript-specific implementations
- `wasmJsMain/` - WebAssembly-specific implementations
- `commonTest/` - Shared test code

**Key architectural principle:** Platform-specific implementations should be minimal. Most logic belongs in `commonMain`. Use `expect`/`actual` for platform differences.

### Dependency Flow

```
server (JVM) ─┐
              ├──> shared (KMP library)
composeApp ───┘
```

The `composeApp` uses Compose Multiplatform for UI, while `shared` contains pure Kotlin code that works everywhere including the server.

## Version Configuration

All versions are managed in `gradle/libs.versions.toml`:
- Kotlin: 2.3.0
- Compose Multiplatform: 1.9.3
- Ktor: 3.3.3
- Android SDK: compileSdk 36, minSdk 24, targetSdk 36
- JVM Target: Java 11

## Important Notes

- Use version catalog references (`libs.`) in build files, not hardcoded versions
- Android uses Java 11 compatibility (`JvmTarget.JVM_11`)
- iOS framework is static (`isStatic = true`)
- Compose Hot Reload is enabled for faster development iteration
- Server uses typesafe project accessors (enabled in `settings.gradle.kts`)

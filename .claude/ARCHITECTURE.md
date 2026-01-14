# Architecture

This document describes the module structure and architecture of the KMPandAI project.

## Module Structure

**Four main modules following AGP 9.0+ KMP architecture:**

### 1. `/androidApp` - Android Application Module

- Pure Android application module using `com.android.application` plugin
- Contains MainActivity as the Android entry point
- Depends on `/composeApp` for UI
- Namespace: `io.petros.kmp.ai.android`

### 2. `/composeApp` - Compose Multiplatform UI Library

- KMP library using `com.android.kotlin.multiplatform.library` plugin
- Contains all UI code shared across Android, iOS, Desktop, and Web
- Uses `androidLibrary {}` configuration block (inside `kotlin {}`) instead of top-level `android {}`
- Depends on `/shared` module for business logic
- Main class for Desktop: `io.petros.kmp.ai.MainKt`
- Targets: Android, iOS, Desktop (JVM), Web (JS/Wasm)

### 3. `/shared` - Shared Business Logic Library

- KMP library using `com.android.kotlin.multiplatform.library` plugin
- Pure Kotlin Multiplatform library (no Compose dependency)
- Uses `androidLibrary {}` configuration block (inside `kotlin {}`) instead of top-level `android {}`
- Platform abstraction layer (`Platform.kt`, `Greeting.kt`, `Constants.kt`)
- Shared across all platforms including server
- Targets: Android, iOS, JVM, JS, Wasm

### 4. `/server` - Ktor Backend Application

- JVM-only Ktor server using Netty engine
- Depends on `/shared` for shared business logic
- Default port defined in `SERVER_PORT` constant
- Main class: `io.petros.kmp.ai.ApplicationKt`

### 5. `/build-logic` - Build Convention Plugins

- Convention plugins for consistent build configuration
- Contains Detekt configuration shared across all modules
- Includes `detekt.convention` plugin with KMP source set support

## Source Set Organization

`composeApp` and `shared` follow KMP sourceSet conventions with `androidLibrary` configuration:

- `commonMain/` - Code shared across all platforms
- `androidMain/` - Android-specific implementations
- `iosMain/` - iOS-specific implementations (shared between arm64 and simulator)
- `jvmMain/` - Desktop/JVM-specific implementations
- `jsMain/` - JavaScript-specific implementations
- `wasmJsMain/` - WebAssembly-specific implementations
- `commonTest/` - Shared test code

## Key Architectural Principles

- Platform-specific implementations should be minimal. Most logic belongs in `commonMain`
- Use `expect`/`actual` for platform differences
- Android configuration now lives inside `kotlin { androidLibrary { } }` block, not at top level
- Android app logic is separated into its own `androidApp` module

## Dependency Flow

```
androidApp (Android) ──> composeApp (KMP library) ──> shared (KMP library)
server (JVM) ──────────────────────────────────────> shared (KMP library)
```

The separation of `androidApp` from `composeApp` is required by AGP 9.0+. The Android application consumes the KMP library, which keeps the Compose UI code truly multiplatform.

## Platform-Specific Files

KMP expect/actual implementations follow naming conventions:

- `Platform.android.kt` - Android implementations
- `Platform.ios.kt` - iOS implementations
- `Platform.jvm.kt` - JVM/Desktop implementations
- `Platform.js.kt` - JavaScript implementations
- `Platform.wasmJs.kt` - WebAssembly implementations

These files are excluded from Detekt's `MatchingDeclarationName` rule to accommodate KMP conventions.

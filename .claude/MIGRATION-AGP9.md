# AGP 9.0+ Migration Notes

This document describes the migration to Android Gradle Plugin 9.0.0-rc03 and its breaking changes.

## Overview

This project has been migrated to Android Gradle Plugin 9.0.0-rc03, which includes significant breaking changes for Kotlin Multiplatform projects.

## Key Changes Implemented

### 1. New KMP Plugin Structure

Both `composeApp` and `shared` now use `com.android.kotlin.multiplatform.library` plugin instead of `com.android.library`.

**Before:**
```kotlin
plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.multiplatform")
}
```

**After:**
```kotlin
plugins {
    alias(libs.plugins.kotlinMultiplatform)
    alias(libs.plugins.androidKmpLibrary)
}
```

### 2. Android Configuration Inside kotlin Block

Android settings moved inside `kotlin { androidLibrary { } }` block instead of top-level `android { }`.

**Before:**
```kotlin
android {
    namespace = "io.petros.kmp.ai"
    compileSdk = 36
    // ...
}
```

**After:**
```kotlin
kotlin {
    androidLibrary {
        namespace = "io.petros.kmp.ai"
        compileSdk = 36
        minSdk = 24

        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_11)
        }
    }
}
```

### 3. Separated Android App Module

Android application logic moved to dedicated `/androidApp` module that consumes `/composeApp` as a dependency.

This separation is required by AGP 9.0+:
- `/androidApp` - Pure Android application (`com.android.application`)
- `/composeApp` - KMP library with Android target (`com.android.kotlin.multiplatform.library`)

### 4. Built-in Kotlin Support

AGP 9.0+ includes Kotlin support natively, so `org.jetbrains.kotlin.android` plugin is no longer needed (and will cause errors if used).

**Do NOT use:**
```kotlin
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // ❌ Will cause errors
}
```

**Use instead:**
```kotlin
plugins {
    alias(libs.plugins.androidApplication) // ✅ Built-in Kotlin support
}
```

### 5. Gradle Version Requirement

AGP 9.0+ requires Gradle 9.1.0 or higher.

Current project uses:
- Gradle: 9.3.0-rc-3
- AGP: 9.0.0-rc03

## Migration Checklist

- [x] Update AGP to 9.0.0-rc03
- [x] Update Gradle to 9.3.0-rc-3
- [x] Convert KMP modules to use `com.android.kotlin.multiplatform.library`
- [x] Move Android configuration inside `kotlin { androidLibrary { } }` blocks
- [x] Separate Android app into dedicated module
- [x] Remove `org.jetbrains.kotlin.android` plugin from Android app
- [x] Update Compose Multiplatform to 1.10.0 (compatible with AGP 9.0)
- [x] Enable androidResources in KMP modules
- [x] Verify all builds and tests pass

## Common Issues and Solutions

### Issue: "Plugin with id 'org.jetbrains.kotlin.android' not found"

**Solution:** Remove the plugin. AGP 9.0+ has built-in Kotlin support.

### Issue: "Android block not found in KMP module"

**Solution:** Android configuration must be inside `kotlin { androidLibrary { } }` block, not at top level.

### Issue: "Resources not found in KMP module"

**Solution:** Explicitly enable androidResources:
```kotlin
kotlin {
    androidLibrary {
        androidResources {
            enable = true
        }
    }
}
```

## Migration Resources

- [Android KMP Plugin Documentation](https://developer.android.com/kotlin/multiplatform/plugin)
- [AGP New KMP Plugin](https://kotl.in/gradle/agp-new-kmp)
- [KMP Project Structure Migration](https://kotl.in/kmp-project-structure-migration)

## Version History

| Date | AGP Version | Gradle Version | Notes |
|------|-------------|----------------|-------|
| 2026-01-14 | 9.0.0-rc03 | 9.3.0-rc-3 | Updated to latest RC |
| 2025-XX-XX | 9.0.0-rc02 | 9.2.1 | Initial AGP 9 migration |

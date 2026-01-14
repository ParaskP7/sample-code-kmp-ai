# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Kotlin Multiplatform project (KMPandAI) targeting multiple platforms: Android, iOS, Web (JS/Wasm), Desktop (JVM), and Server (Ktor). The project demonstrates KMP capabilities alongside AI and agentic development.

**Package namespace:** `io.petros.kmp.ai`

## Documentation Structure

This documentation is split into focused files for easier navigation:

- **[ARCHITECTURE.md](.claude/ARCHITECTURE.md)** - Module structure, source sets, dependency flow
- **[BUILD.md](.claude/BUILD.md)** - Build commands, testing, version configuration
- **[DEVELOPMENT-RULES.md](.claude/DEVELOPMENT-RULES.md)** - Git rules, version catalog rules, build verification
- **[MIGRATION-AGP9.md](.claude/MIGRATION-AGP9.md)** - AGP 9.0+ migration notes and breaking changes

## Quick Reference

### Key Technologies

- **Android Gradle Plugin (AGP):** 9.0.0-rc03
- **Gradle:** 9.3.0-rc-3
- **Kotlin:** 2.3.0
- **Compose Multiplatform:** 1.10.0
- **Detekt:** 2.0.0-alpha.1
- **Ktfmt:** 0.61 (Kotlinlang style)
- **Ktor:** 3.3.3

### Build Commands

```bash
# Build
./gradlew assembleDebug

# Run quality checks
./gradlew lintDebug
./gradlew detekt
./gradlew test

# Code formatting
./scripts/ktfmt.sh --all
```

See [BUILD.md](.claude/BUILD.md) for complete build guide.

### Module Structure

```
/androidApp     - Android application (com.android.application)
/composeApp     - Compose Multiplatform UI (KMP library)
/shared         - Shared business logic (KMP library)
/server         - Ktor backend (JVM only)
/build-logic    - Build convention plugins
```

See [ARCHITECTURE.md](.claude/ARCHITECTURE.md) for detailed architecture.

### Development Rules

**IMPORTANT:** Claude Code must follow strict rules when working with this repository:

- Always ask for confirmation before creating or amending commits
- Follow commit message format (72 char limit, Co-Authored-By trailer)
- Maintain version catalog structure with alphabetical ordering
- Run build verification commands before committing

See [DEVELOPMENT-RULES.md](.claude/DEVELOPMENT-RULES.md) for complete rules.

## Important Notes

- Use version catalog references (`libs.`) in build files, not hardcoded versions
- AGP 9.0+ has built-in Kotlin support - do NOT use `org.jetbrains.kotlin.android`
- KMP modules use `com.android.kotlin.multiplatform.library` plugin
- Android configuration in KMP modules uses `kotlin { androidLibrary { } }` block
- Detekt is configured via build-logic convention plugin for all modules
- Ktfmt auto-formats code on commit (Kotlinlang style, 4-space indent, 120-char line)

## Quick Links

- [Project Architecture](.claude/ARCHITECTURE.md)
- [Build & Testing Guide](.claude/BUILD.md)
- [Development Rules](.claude/DEVELOPMENT-RULES.md)
- [AGP 9.0+ Migration](.claude/MIGRATION-AGP9.md)

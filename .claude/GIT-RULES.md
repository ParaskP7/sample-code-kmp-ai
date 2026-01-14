# Git Commit Rules

This document contains mandatory git commit rules for Claude Code when working with this repository.

**CRITICAL: Always ask for user confirmation before creating or amending commits.**

## 1. Commit Creation

- NEVER create a new commit without asking for confirmation first
- NEVER amend an existing commit without asking for confirmation first

## 2. Commit Message Format

### Title Rules

- **Single line only**, maximum 72 characters
- **Sentence case**: First letter uppercase, all remaining letters lowercase (NO exceptions)
  - This applies to the entire title after the prefix
  - No exceptions for proper nouns, acronyms, or technical terms
  - All letters after the first must be lowercase
- **Prefix required**: Use appropriate commit prefix (see section 4 below)

Examples:
- ✅ `Deps: Update compose bom to 2026.01.00`
- ✅ `Quality: Add detekt v2.0.0-alpha.1 and fix issues`
- ❌ `Deps: Update Compose BOM to 2026.01.00` (incorrect: "Compose BOM" should be lowercase)
- ❌ `Deps: Update compose bom To 2026.01.00` (incorrect: "To" should be lowercase)
- ❌ `Quality: ADD DETEKT V2.0.0-ALPHA.1 AND FIX ISSUES` (incorrect: all caps)

### Body Rules

- **Wrap all lines at 72 characters** (right margin limit)
- Include blank line between title and body
- For dependency updates (`Deps:` prefix), include release notes URL as first line after title
- Always end with: `Co-Authored-By: Claude Sonnet <VERSION> <noreply@anthropic.com>`

## 3. Commit Message Examples

### Example 1: Dependency Update

```
Deps: Update logback to 1.5.24

Release Notes: https://github.com/qos-ch/logback/releases/tag/v_1.5.24

Update logback from 1.5.23 to 1.5.24 for latest bug fixes
and performance improvements.

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

### Example 2: Dependency Update with Multiple URLs

```
Deps: Update compose bom to 2026.01.00

Release Notes: https://developer.android.com/jetpack/androidx/releases/compose
BOM Mapping: https://developer.android.com/develop/ui/compose/bom/bom-mapping

Update androidx-compose-bom from 2025.12.01 to 2026.01.00
and configure lint to ignore GradleDependency warnings to
prevent build failures on out-of-date dependency checks.

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

### Example 3: Code Quality Improvement

```
Quality: Add detekt v2.0.0-alpha.1 and fix issues

Add Detekt static code analysis with build-logic
convention plugin and resolve all warnings:
- Create build-logic module with detekt.convention
- Configure buildUponDefaultConfig in convention plugin
- Fix all code quality issues found

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

### Example 4: Code Formatting

```
Format: Add ktfmt v0.61 with kotlinlang style and pre-commit hook

Add ktfmt for automatic Kotlin code formatting:
- Create .editorconfig with Kotlinlang style configuration
- Add ktfmt.sh script with --all and --changed modes
- Create pre-commit hook for auto-formatting
- Set up shared library for script reusability

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

## 4. Commit Prefixes

All commit titles **must** start with one of these prefixes:

### Deps
**Usage:** Dependency version updates
**Format:** `Deps: Update <library> to <version>`
**Required:** Release notes URL as first line after title
**Examples:**
- `Deps: Update compose bom to 2026.01.00`
- `Deps: Update gradle to 9.3.0-rc-3 and agp to 9.0.0-rc03`
- `Deps: Update logback to 1.5.24`
- `Deps: Remove all unused libraries and versions from libs.versions.toml`

### Quality
**Usage:** Code quality improvements (static analysis, linting, code cleanup)
**Examples:**
- `Quality: Add detekt v2.0.0-alpha.1 and fix code quality issues`
- `Quality: Add jetpack compose rules v0.5.3 for detekt`
- `Quality: Fix all detekt warnings in shared module`

### Format
**Usage:** Code formatting changes (ktfmt, editorconfig, style changes)
**Examples:**
- `Format: Add ktfmt v0.61 with kotlinlang style and pre-commit hook`
- `Format: Reformat all kotlin files with kotlinlang style`
- `Format: Update editorconfig to use 4-space indentation`

### Build
**Usage:** Build configuration changes (Gradle, build scripts, version catalogs)
**Examples:**
- `Build: Restructure libs.versions.toml for better readability`
- `Build: Add build-logic convention plugin for detekt`
- `Build: Configure android library blocks in kmp modules`

### Android
**Usage:** Android-specific changes (lint configuration, Android resources, manifests)
**Examples:**
- `Android: Configure lint and fix warnings`
- `Android: Update targetsdk to 36`
- `Android: Add lint.xml configuration for gradledependency`

### Docs
**Usage:** Documentation changes (README, CLAUDE.md, code comments)
**Examples:**
- `Docs: Organize documentation into .claude directory`
- `Docs: Update build.md with ktfmt commands`
- `Docs: Add migration guide for agp 9.0+`

### Init
**Usage:** Initial setup and project scaffolding
**Examples:**
- `Init: Via kotlin multiplatform wizard`
- `Init: Set up project structure`

### AI
**Usage:** AI and agentic development related changes
**Examples:**
- `AI: Start agentic development with claude code`
- `AI: Add claude code configuration`

### Feature
**Usage:** New features or functionality
**Examples:**
- `Feature: Add dark mode support`
- `Feature: Implement user authentication`

### Fix
**Usage:** Bug fixes
**Examples:**
- `Fix: Resolve crash on startup`
- `Fix: Correct navigation bug in settings`

### Refactor
**Usage:** Code refactoring without changing functionality
**Examples:**
- `Refactor: Extract shared logic to common module`
- `Refactor: Simplify authentication flow`

### Test
**Usage:** Test additions or modifications
**Examples:**
- `Test: Add unit tests for greeting class`
- `Test: Update integration tests for api client`

## 5. Release Notes for Dependency Updates

When using the `Deps:` prefix, **always include release notes URL(s)** as the first line(s) after the title.

### Finding Release Notes

**For Maven dependencies:**
1. Check the project's GitHub repository releases page
2. Check the official documentation site
3. Use Maven Central or MVNRepository links if official docs unavailable

**For Gradle/AGP:**
- Gradle: `https://docs.gradle.org/<version>/release-notes.html`
- AGP: `https://developer.android.com/build/releases/gradle-plugin`

**For Compose:**
- Release Notes: `https://developer.android.com/jetpack/androidx/releases/compose`
- BOM Mapping: `https://developer.android.com/develop/ui/compose/bom/bom-mapping`

**For Kotlin:**
- `https://github.com/JetBrains/kotlin/releases/tag/v<version>`

**For Ktor:**
- `https://github.com/ktorio/ktor/releases/tag/<version>`

### Format

```
Deps: Update <library> to <version>

Release Notes: <URL>
[Additional URLs if relevant, e.g., BOM Mapping: <URL>]

[Detailed description of changes...]

Co-Authored-By: Claude Sonnet <VERSION> <noreply@anthropic.com>
```

## 6. Pre-commit Verification

Before creating any commit, ensure:

1. All build verification commands pass:
   ```bash
   ./gradlew assembleDebug
   ./gradlew lintDebug
   ./gradlew detekt
   ./gradlew test
   ```

2. Code is properly formatted:
   ```bash
   ./scripts/ktfmt.sh --changed
   ```

3. No unintended files are staged

See [DEVELOPMENT-RULES.md](DEVELOPMENT-RULES.md) for complete build verification requirements.

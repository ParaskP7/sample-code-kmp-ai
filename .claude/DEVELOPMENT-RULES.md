# Claude Code Development Rules

This document contains mandatory rules for Claude Code when working with this repository.

## Git Commit Rules

**All git commit rules have been moved to [GIT-RULES.md](GIT-RULES.md).**

**CRITICAL: Always ask for user confirmation before creating or amending commits.**

See [GIT-RULES.md](GIT-RULES.md) for:
- Commit creation rules
- Commit message format (title and body)
- Commit prefixes (Deps, Quality, Format, Build, etc.)
- Release notes requirements for dependency updates
- Examples and best practices

## Version Catalog Rules (gradle/libs.versions.toml)

**Always follow these rules when updating `gradle/libs.versions.toml`:**

### 1. [versions] Section

- Regular versions alphabetically ordered first
- Add comment `# Android SDK versions` before SDK versions
- Android SDK versions alphabetically ordered (compileSdk, minSdk, targetSdk)

### 2. [libraries] Section

- Regular libraries alphabetically ordered first
- Add comment `# Build-logic convention plugin dependencies` before build-logic deps
- Convention plugin dependencies alphabetically ordered

### 3. [plugins] Section

- All plugins alphabetically ordered

### 4. Structure Example

```toml
[versions]
agp = "9.0.0-rc03"
kotlin = "2.3.0"
# ... other versions alphabetically

# Android SDK versions
android-compileSdk = "36"
android-minSdk = "24"
android-targetSdk = "36"

[libraries]
androidx-activity-compose = { ... }
# ... regular libraries alphabetically

# Build-logic convention plugin dependencies
detekt-gradlePlugin = { ... }
kotlin-gradlePlugin = { ... }

[plugins]
androidApplication = { ... }
# ... all plugins alphabetically
```

## Build Verification Rules

**After making ANY code changes, ALWAYS verify the build works by running:**

### 1. Required Verification Commands

```bash
./gradlew assembleDebug
./gradlew lintDebug
./gradlew detekt
./gradlew test
```

### 2. When to Run

- After adding/modifying dependencies
- After code changes in any module
- After configuration changes
- Before creating commits

### 3. What Each Command Verifies

- `assembleDebug`: Code compiles successfully
- `lintDebug`: Android lint checks pass
- `detekt`: Static code analysis passes
- `test`: All tests pass

### 4. Handling Failures

- Fix all issues before proceeding
- Do NOT commit code that fails verification
- Report verification results to user

## Code Quality Standards

### Detekt Configuration

- All modules use the `detekt.convention` plugin from build-logic
- Detekt analyzes all KMP source sets (commonMain, androidMain, iosMain, jvmMain, jsMain, wasmJsMain)
- Custom rules configured in `config/detekt/detekt.yml`:
  - `UnusedImport`: Active
  - `FunctionNaming`: Ignores @Composable functions and iosMain sources
  - `MatchingDeclarationName`: Excludes platform-specific files (*.android.kt, *.ios.kt, etc.)

### Import Rules

- No wildcard imports allowed (replace with explicit imports)
- Remove unused imports
- Organize imports alphabetically

### File Formatting

- All files must end with a newline
- Follow Kotlin coding conventions
- Use proper indentation (4 spaces)

## Code Formatting with Ktfmt

**Automatic code formatting is enforced via ktfmt with Kotlinlang style.**

### Ktfmt Configuration

- **Style:** Kotlinlang (official Kotlin coding conventions)
- **Indent:** 4 spaces
- **Line Length:** 120 characters
- **Configuration:** `.editorconfig` in project root

### Pre-commit Hook

- Pre-commit hook automatically formats staged Kotlin files before commit
- The hook downloads ktfmt 0.61 JAR from Maven Central if not present
- Formatted files are automatically re-staged
- To bypass (not recommended): `git commit --no-verify`

### Manual Formatting Commands

```bash
# Format all Kotlin files in the project
./scripts/ktfmt.sh --all

# Format only files changed compared to main branch
./scripts/ktfmt.sh --changed

# Format only files changed compared to specific branch
./scripts/ktfmt.sh --changed --base-branch develop
```

### Setup for Team Members

New team members should install the pre-commit hook:

```bash
./scripts/setup-hooks.sh
```

### Ktfmt Version Management

- Version is maintained in `scripts/lib/ktfmt-lib.sh` (currently 0.61)
- NOT in `gradle/libs.versions.toml` (ktfmt is a CLI tool, not a Gradle dependency)
- Update version in one place: `KTFMT_VERSION` variable in `scripts/lib/ktfmt-lib.sh`

## Platform-Specific Conventions

### iOS (iosMain)

- Factory functions may use PascalCase (e.g., `MainViewController()`)
- FunctionNaming rule is excluded for all iosMain sources

### Expect/Actual Files

- Platform-specific files use naming pattern: `FileName.platform.kt`
  - `Platform.android.kt`
  - `Platform.ios.kt`
  - `Platform.jvm.kt`
  - `Platform.js.kt`
  - `Platform.wasmJs.kt`
- These files are excluded from MatchingDeclarationName rule

### Compose Functions

- @Composable functions can use PascalCase naming
- Preview functions use PascalCase (e.g., `AppAndroidPreview()`)

# Continuous Integration (CI)

This document describes the CI setup for the KMPandAI project using GitHub Actions.

## Overview

The CI workflow runs automatically on:
- Every push to the `main` branch
- All pull requests (to any branch)

The workflow is defined in `.github/workflows/ci.yml` and consists of 4 separate jobs that run in parallel for faster feedback.

## Workflow Jobs

### 1. Validate Gradle Wrapper

**Job ID:** `validate`
**Timeout:** 5 minutes
**Purpose:** Validates the integrity of the Gradle Wrapper to prevent supply chain attacks

**What it does:**
- Checks out the code
- Validates Gradle Wrapper JAR files against known good checksums
- Uses `gradle/actions/wrapper-validation@v5`

**Why it matters:** This job runs first and all other jobs depend on it. If the Gradle Wrapper is compromised, the entire workflow fails immediately.

### 2. Build - Assemble (Debug)

**Job ID:** `build`
**Timeout:** 20 minutes
**Purpose:** Verifies that the code compiles successfully

**What it does:**
- Checks out the code
- Sets up JDK 17 (Temurin distribution)
- Configures Gradle with caching
- Runs `./gradlew assembleDebug`

**Dependencies:** Runs after `validate` completes successfully

**What it verifies:**
- All Kotlin code compiles
- Android resources are valid
- All dependencies resolve correctly
- No syntax or compilation errors

### 3. Static Analysis

**Job ID:** `analysis`
**Timeout:** 20 minutes
**Purpose:** Runs static code analysis to catch bugs and maintain code quality

**What it does:**
- Checks out the code
- Sets up JDK 17 (Temurin distribution)
- Configures Gradle with caching
- Runs `./gradlew lintDebug` - Android Lint checks
- Runs `./gradlew detekt` - Detekt static analysis

**Dependencies:** Runs after `validate` completes successfully

**What it verifies:**
- Android Lint rules pass (configured in `androidApp/lint.xml`)
- Detekt rules pass (configured in `config/detekt/detekt.yml`)
- Compose Rules pass (via Detekt plugin)
- No unused imports, code style violations, or potential bugs

**Artifacts:** If the job fails, uploads analysis reports:
- `**/build/reports/lint-*.xml`
- `**/build/reports/lint-*.html`
- `**/build/reports/detekt/`

### 4. Test

**Job ID:** `test`
**Timeout:** 20 minutes
**Purpose:** Runs all unit tests to verify functionality

**What it does:**
- Checks out the code
- Sets up JDK 17 (Temurin distribution)
- Configures Gradle with caching
- Runs `./gradlew test`

**Dependencies:** Runs after `validate` completes successfully

**What it verifies:**
- All unit tests pass
- Common tests (shared across platforms) pass
- JVM-specific tests pass
- Server tests pass

**Artifacts:** If the job fails, uploads test reports:
- `**/build/reports/tests/`
- `**/build/test-results/`

## GitHub Actions Used

All actions are pinned to their latest major versions:

- **`actions/checkout@v6`** - Checks out the repository code
- **`actions/setup-java@v5`** - Sets up JDK 17 with Temurin distribution
- **`gradle/actions/setup-gradle@v5`** - Sets up Gradle with caching and build scan support
- **`gradle/actions/wrapper-validation@v5`** - Validates Gradle Wrapper integrity
- **`actions/upload-artifact@v6`** - Uploads build/test reports on failure

## Gradle Caching

Gradle caching is enabled to speed up builds:
- **On `main` branch:** Cache is read-write (can update cache)
- **On PR branches:** Cache is read-only (uses cached data but doesn't update)

This configuration is set via:
```yaml
cache-read-only: ${{ github.ref != 'refs/heads/main' }}
```

## Job Execution Flow

```
validate (5 min)
    |
    +---> build (20 min)    [runs in parallel]
    |
    +---> analysis (20 min) [runs in parallel]
    |
    +---> test (20 min)     [runs in parallel]
```

**Total CI time:** ~25 minutes (5 min validation + 20 min for parallel jobs)

If validation was sequential with other jobs, it would take ~65 minutes instead.

## Interpreting CI Results

### All Checks Pass ✅
- Green checkmark on commit/PR
- All jobs completed successfully
- Code is ready to merge

### Validation Fails ❌
- Gradle Wrapper integrity check failed
- **Action required:** Verify Gradle Wrapper hasn't been tampered with
- All other jobs are skipped

### Build Fails ❌
- Code doesn't compile
- **Action required:** Fix compilation errors before merging

### Analysis Fails ❌
- Lint or Detekt violations found
- **Action required:** Check uploaded artifacts for details, fix violations
- Download artifacts from GitHub Actions job summary

### Test Fails ❌
- One or more tests failed
- **Action required:** Check uploaded artifacts for test reports, fix failing tests
- Download artifacts from GitHub Actions job summary

## Local Verification

Before pushing code, run these commands locally to catch issues early:

```bash
# Validate Gradle Wrapper (manual check)
# No automated local equivalent, but wrapper is validated in CI

# Build
./gradlew assembleDebug

# Static Analysis
./gradlew lintDebug
./gradlew detekt

# Tests
./gradlew test
```

See [DEVELOPMENT-RULES.md](DEVELOPMENT-RULES.md) for complete build verification requirements.

## Troubleshooting

### CI Passes Locally But Fails in GitHub Actions

**Possible causes:**
- Different Java version (CI uses JDK 17)
- Different Gradle version (CI uses wrapper version)
- Local cache issues (try `./gradlew clean`)
- Platform-specific issues (CI runs on Ubuntu)

**Solution:** Check the specific job logs in GitHub Actions for detailed error messages.

### Jobs Timing Out

**Possible causes:**
- Build is hanging (check for deadlocks or infinite loops)
- Dependencies taking too long to download
- Tests running indefinitely

**Solution:**
- Check job logs for where it stopped
- Timeouts can be adjusted in `.github/workflows/ci.yml`

### Gradle Cache Not Working

**Symptoms:**
- Every build downloads all dependencies
- Build times are consistently long

**Solution:**
- Check that `gradle/actions/setup-gradle@v5` is being used
- Verify cache-read-only configuration is correct
- GitHub Actions cache might be full (cache eviction happens automatically)

## Future Enhancements

Potential improvements to consider:

- Add code coverage reporting (JaCoCo)
- Add release build job
- Add dependency vulnerability scanning
- Add automated PR labeling based on changed files
- Add build performance tracking
- Add matrix builds for multiple JDK versions
- Add iOS build job (requires macOS runner)

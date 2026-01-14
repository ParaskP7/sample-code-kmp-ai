#!/usr/bin/env bash

# Shared library for ktfmt scripts
# This file should be sourced by other scripts, not executed directly

# Ktfmt configuration
KTFMT_VERSION="0.61"
KTFMT_JAR=".ktfmt/ktfmt-$KTFMT_VERSION.jar"
KTFMT_URL="https://repo1.maven.org/maven2/com/facebook/ktfmt/$KTFMT_VERSION/ktfmt-$KTFMT_VERSION-with-dependencies.jar"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Download ktfmt if not present
download_ktfmt() {
    if [ ! -f "$KTFMT_JAR" ]; then
        echo -e "${YELLOW}Downloading ktfmt $KTFMT_VERSION...${NC}"
        mkdir -p .ktfmt

        if command -v curl &> /dev/null; then
            curl -L -o "$KTFMT_JAR" "$KTFMT_URL"
        elif command -v wget &> /dev/null; then
            wget -O "$KTFMT_JAR" "$KTFMT_URL"
        else
            echo -e "${RED}Error: Neither curl nor wget found. Please install one of them.${NC}"
            exit 1
        fi

        echo -e "${GREEN}Downloaded ktfmt $KTFMT_VERSION${NC}"
    fi
}

# Format Kotlin files with ktfmt
format_kotlin_files() {
    local files=("$@")

    if [ ${#files[@]} -eq 0 ]; then
        return 0
    fi

    java -jar "$KTFMT_JAR" --kotlinlang-style "${files[@]}"
}

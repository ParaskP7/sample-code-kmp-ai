#!/usr/bin/env bash

# Setup Git hooks for the project
# This script installs pre-commit hooks for ktfmt formatting

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Setting up Git hooks...${NC}"

# Ensure .git/hooks directory exists
mkdir -p .git/hooks

# Copy pre-commit hook
cp scripts/hooks/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

echo -e "${GREEN}Git hooks installed successfully!${NC}"
echo ""
echo "Pre-commit hook: Formats Kotlin files with ktfmt before commit"
echo ""
echo "To bypass the hook (not recommended), use: git commit --no-verify"

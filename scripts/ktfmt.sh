#!/usr/bin/env bash

# Ktfmt wrapper script for formatting Kotlin files
# Supports formatting all files or only files changed compared to base branch
# Based on: https://gist.github.com/vRallev/e9c3c59bba95521f98ffbb487ec44427

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the ktfmt library
source "$SCRIPT_DIR/lib/ktfmt-lib.sh"

CHUNK_SIZE=8000
BASE_BRANCH="main"

# Get changed Kotlin files compared to base branch
get_changed_files() {
  local base_branch="$1"

  # Check if we're in a git repository
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}Error: Not in a git repository${NC}"
    exit 1
  fi

  # Get the merge base with the base branch
  if ! git rev-parse --verify "$base_branch" > /dev/null 2>&1; then
    echo -e "${RED}Error: Base branch '$base_branch' not found${NC}"
    exit 1
  fi

  local merge_base
  merge_base=$(git merge-base HEAD "$base_branch" 2>/dev/null || echo "$base_branch")

  # Get all changed Kotlin files (staged, unstaged, and untracked)
  {
    # Changed files since merge base
    git diff --name-only --diff-filter=d "$merge_base"
    # Staged files
    git diff --cached --name-only --diff-filter=d
    # Untracked files
    git ls-files --others --exclude-standard
  } | grep -E '\.(kt|kts)$' | grep '/src/' | sort -u || true
}

# Get all Kotlin files in the project
get_all_files() {
  find . -type f \( -name "*.kt" -o -name "*.kts" \) -path "*/src/*" | sort
}

# Format files in chunks
format_files() {
  local files=("$@")
  local total=${#files[@]}

  if [ $total -eq 0 ]; then
    echo -e "${YELLOW}No Kotlin files to format${NC}"
    return 0
  fi

  echo -e "${GREEN}Formatting $total Kotlin file(s)...${NC}"

  local formatted=0
  local chunk=0

  while [ $formatted -lt $total ]; do
    local end=$((formatted + CHUNK_SIZE))
    if [ $end -gt $total ]; then
      end=$total
    fi

    chunk=$((chunk + 1))
    local chunk_files=("${files[@]:$formatted:$CHUNK_SIZE}")

    echo -e "${YELLOW}Processing chunk $chunk (files $((formatted + 1))-$end of $total)${NC}"

    if [ ${#chunk_files[@]} -gt 0 ]; then
      format_kotlin_files "${chunk_files[@]}"
    fi

    formatted=$end
  done

  echo -e "${GREEN}Formatted $total file(s)${NC}"
}

# Show usage
usage() {
  cat << EOF
Usage: $(basename "$0") [OPTIONS]

Format Kotlin files using ktfmt with Kotlinlang style.

OPTIONS:
  --all               Format all Kotlin files in the project
  --changed           Format only files changed compared to base branch (default: main)
  --base-branch NAME  Set base branch for --changed mode (default: main)
  --help              Show this help message

EXAMPLES:
  $(basename "$0") --all
  $(basename "$0") --changed
  $(basename "$0") --changed --base-branch develop

EOF
  exit 0
}

# Main script
main() {
  local mode="changed"

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      --all)
        mode="all"
        shift
        ;;
      --changed)
        mode="changed"
        shift
        ;;
      --base-branch)
        BASE_BRANCH="$2"
        shift 2
        ;;
      --help)
        usage
        ;;
      *)
        echo -e "${RED}Unknown option: $1${NC}"
        usage
        ;;
    esac
  done

  # Download ktfmt if needed
  download_ktfmt

  # Get files to format
  local files=()
  if [ "$mode" == "all" ]; then
    echo -e "${YELLOW}Formatting all Kotlin files...${NC}"
    mapfile -t files < <(get_all_files)
  else
    echo -e "${YELLOW}Formatting files changed compared to '$BASE_BRANCH'...${NC}"
    mapfile -t files < <(get_changed_files "$BASE_BRANCH")
  fi

  # Format the files
  format_files "${files[@]}"
}

# Run main function
main "$@"

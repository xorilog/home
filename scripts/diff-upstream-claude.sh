#!/usr/bin/env bash
#
# diff-upstream-claude.sh - Compare local Claude config with upstream vdemeester/home
#
# Usage: ./scripts/diff-upstream-claude.sh
#
# This script compares the local Claude Code configuration in dots/config/claude/
# with the upstream version from vdemeester/home tracked via the flake input.
#
# Workflow:
# 1. Update the vdemeester-home flake input
# 2. Compare local vs upstream using diff
# 3. Review changes and integrate manually as needed
#

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCAL_CLAUDE="${REPO_ROOT}/dots/config/claude"

echo "==> Updating vdemeester-home flake input..."
nix flake update vdemeester-home 2>&1 | grep -v "^warning:" || true

echo ""
echo "==> Comparing local Claude config with upstream..."
echo ""

# Get the locked info from flake metadata
LOCKED_INFO="$(nix flake metadata --json 2>/dev/null | jq -r '.locks.nodes."vdemeester-home".locked')"
UPSTREAM_TYPE="$(echo "$LOCKED_INFO" | jq -r '.type')"
UPSTREAM_URL="$(echo "$LOCKED_INFO" | jq -r '.url')"
UPSTREAM_REV="$(echo "$LOCKED_INFO" | jq -r '.rev')"

if [ -z "$UPSTREAM_URL" ] || [ "$UPSTREAM_URL" = "null" ]; then
    echo "Error: Could not find vdemeester-home input in flake.lock"
    echo "Make sure vdemeester-home is defined as an input in flake.nix"
    exit 1
fi

# Build the flake URL based on the type
case "$UPSTREAM_TYPE" in
    git)
        FLAKE_URL="git+${UPSTREAM_URL}?rev=${UPSTREAM_REV}"
        ;;
    github)
        OWNER="$(echo "$LOCKED_INFO" | jq -r '.owner')"
        REPO="$(echo "$LOCKED_INFO" | jq -r '.repo')"
        FLAKE_URL="github:${OWNER}/${REPO}/${UPSTREAM_REV}"
        ;;
    *)
        echo "Error: Unsupported flake input type: $UPSTREAM_TYPE"
        exit 1
        ;;
esac

# Prefetch the input to get its store path
UPSTREAM_STORE_PATH="$(nix flake prefetch "$FLAKE_URL" --json 2>/dev/null | jq -r '.storePath')"

if [ -z "$UPSTREAM_STORE_PATH" ] || [ ! -d "$UPSTREAM_STORE_PATH" ]; then
    echo "Error: Could not fetch upstream flake from $UPSTREAM_URL"
    exit 1
fi

UPSTREAM_CLAUDE="${UPSTREAM_STORE_PATH}/dots/config/claude"

if [ ! -d "$UPSTREAM_CLAUDE" ]; then
    echo "Error: Could not find Claude config at $UPSTREAM_CLAUDE"
    exit 1
fi

echo "Local:    ${LOCAL_CLAUDE}"
echo "Upstream: ${UPSTREAM_CLAUDE}"
echo ""

# Function to show diff for a directory
show_diff() {
    local subdir="$1"
    local title="$2"

    echo "==> $title"
    echo ""

    if [ -d "${LOCAL_CLAUDE}/${subdir}" ] && [ -d "${UPSTREAM_CLAUDE}/${subdir}" ]; then
        # Show which files differ
        diff -rq "${UPSTREAM_CLAUDE}/${subdir}" "${LOCAL_CLAUDE}/${subdir}" 2>/dev/null || true
        echo ""
    else
        echo "Directory not found in local or upstream"
        echo ""
    fi
}

# Compare each section
show_diff "agents" "Agents"
show_diff "skills/CORE" "CORE Skill"
show_diff "skills/golang" "Golang Skill"
show_diff "skills/Nix" "Nix Skill"
show_diff "skills/Git" "Git Skill"
show_diff "skills/GitHub" "GitHub Skill"
show_diff "skills/Docker" "Docker Skill"
show_diff "skills/Kubernetes" "Kubernetes Skill"
show_diff "skills/Python" "Python Skill"
show_diff "skills/Rust" "Rust Skill"
show_diff "plugins/session-manager" "Session Manager Plugin"

echo "==> To see detailed diffs for a specific file:"
echo "    diff ${UPSTREAM_CLAUDE}/path/to/file ${LOCAL_CLAUDE}/path/to/file"
echo ""
echo "==> To copy a file from upstream:"
echo "    cp ${UPSTREAM_CLAUDE}/path/to/file ${LOCAL_CLAUDE}/path/to/file"
echo ""

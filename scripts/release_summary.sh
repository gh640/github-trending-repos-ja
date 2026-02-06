#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  scripts/release_summary.sh [DATE]

Arguments:
  DATE  Summary date in YYYY.MM.DD format (default: today)

Examples:
  scripts/release_summary.sh
  scripts/release_summary.sh 2026.02.01
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "Error: gh command is required." >&2
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DATE="${1:-$(date +%Y.%m.%d)}"

if [[ ! "$DATE" =~ ^[0-9]{4}\.[0-9]{2}\.[0-9]{2}$ ]]; then
  echo "Error: DATE must be YYYY.MM.DD format." >&2
  exit 1
fi

SUMMARY_FILE="$ROOT_DIR/summaries/$DATE.md"
TAG="v$DATE"
REPO="gh640/github-trending-repos-ja"

if [[ ! -f "$SUMMARY_FILE" ]]; then
  echo "Error: summary file not found: $SUMMARY_FILE" >&2
  exit 1
fi

if git rev-parse -q --verify "refs/tags/$TAG" >/dev/null; then
  echo "Error: tag already exists locally: $TAG" >&2
  exit 1
fi

if gh release view "$TAG" --repo "$REPO" >/dev/null 2>&1; then
  echo "Error: release already exists on GitHub: $TAG" >&2
  exit 1
fi

echo "Creating tag: $TAG"
git tag "$TAG"

echo "Pushing tag: $TAG"
git push --tags

echo "Creating GitHub release: $TAG"
gh release create "$TAG" \
  --repo "$REPO" \
  --title "$TAG" \
  --notes-file "$SUMMARY_FILE"

echo "Done: $TAG"

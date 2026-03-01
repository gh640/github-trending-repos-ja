#!/usr/bin/env bash
set -euo pipefail

if ! command -v gh >/dev/null 2>&1; then
  echo "Error: gh command is required." >&2
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  echo "Error: git command is required." >&2
  exit 1
fi

REPO="gh640/github-trending-repos-ja"
LATEST_TAG="$(git tag --sort=-creatordate | head -n 1)"

if [[ -z "$LATEST_TAG" ]]; then
  echo "Error: no local tags found." >&2
  exit 1
fi

DATE="${LATEST_TAG#v}"
SUMMARY_PATH="summaries/${DATE}.md"

if ! git ls-remote --exit-code --tags origin "$LATEST_TAG" >/dev/null 2>&1; then
  echo "Error: latest tag is not available on origin: $LATEST_TAG" >&2
  exit 1
fi

if gh release view "$LATEST_TAG" --repo "$REPO" >/dev/null 2>&1; then
  echo "Release already exists: $LATEST_TAG"
  exit 0
fi

TMP_FILE="$(mktemp)"
trap 'rm -f "$TMP_FILE"' EXIT

if ! git show "${LATEST_TAG}:${SUMMARY_PATH}" >"$TMP_FILE" 2>/dev/null; then
  echo "Error: summary file not found in tagged commit: ${LATEST_TAG}:${SUMMARY_PATH}" >&2
  exit 1
fi

gh release create "$LATEST_TAG" \
  --repo "$REPO" \
  --title "$LATEST_TAG" \
  --notes-file "$TMP_FILE"

gh release view "$LATEST_TAG" --repo "$REPO"

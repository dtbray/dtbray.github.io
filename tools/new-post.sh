#!/usr/bin/env bash
#
# Create a new blog post scaffold.
#
# Usage:
#   bash tools/new-post.sh "My Post Title"
#   bash tools/new-post.sh              # prompts for title

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
POSTS_DIR="$SCRIPT_DIR/../content/posts"

# ── Title ────────────────────────────────────────────────────────────────────

if [[ $# -gt 0 ]]; then
  TITLE="$*"
else
  read -rp "Post title: " TITLE
fi

if [[ -z "$TITLE" ]]; then
  echo "Error: title cannot be empty"
  exit 1
fi

# ── Slug & filename ──────────────────────────────────────────────────────────

SLUG=$(echo "$TITLE" \
  | tr '[:upper:]' '[:lower:]' \
  | sed 's/[^a-z0-9 ]//g' \
  | tr -s ' ' '-' \
  | sed 's/^-//;s/-$//')

DATETIME=$(date +"%Y-%m-%d %H:%M:%S %z")
FILENAME="${SLUG}.md"
FILEPATH="$POSTS_DIR/$FILENAME"

if [[ -f "$FILEPATH" ]]; then
  echo "Error: content/posts/$FILENAME already exists"
  exit 1
fi

# ── Write scaffold ───────────────────────────────────────────────────────────

cat > "$FILEPATH" <<EOF
---
title: "$TITLE"
date: $DATETIME
categories: []
tags: []
---

## Introduction

## Key Points

-
-
-

## Conclusion

EOF

echo "Created: content/posts/$FILENAME"

# ── Open in editor ───────────────────────────────────────────────────────────

if [[ -n "${EDITOR:-}" ]]; then
  "$EDITOR" "$FILEPATH"
elif command -v code &>/dev/null; then
  code "$FILEPATH"
fi

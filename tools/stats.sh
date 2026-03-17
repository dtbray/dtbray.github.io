#!/usr/bin/env bash
#
# Print blog statistics: post counts, word counts, categories, tags.
#
# Usage:
#   bash tools/stats.sh

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
POSTS_DIR="$SCRIPT_DIR/../_posts"

# Collect posts (exclude .placeholder)
POSTS=()
for POST in "$POSTS_DIR"/*.md; do
  [[ "$(basename "$POST")" == ".placeholder" ]] && continue
  POSTS+=("$POST")
done

TOTAL=${#POSTS[@]}

if [[ $TOTAL -eq 0 ]]; then
  echo "No posts found."
  exit 0
fi

# Extract body text (strip front matter) for word counting
body() {
  awk 'NR==1{ next } /^---$/{ p=1; next } p{ print }' "$1"
}

# Extract front matter
front_matter() {
  awk 'NR>1{ if(/^---$/) exit; print }' "$1"
}

# ── Header ───────────────────────────────────────────────────────────────────

echo "╔══════════════════════════════════════╗"
echo "║        Rabid Curiosity — Stats       ║"
echo "╚══════════════════════════════════════╝"
echo ""

# ── Post count ───────────────────────────────────────────────────────────────

echo "Total posts: $TOTAL"
echo ""

# ── Word counts ──────────────────────────────────────────────────────────────

TOTAL_WORDS=0
declare -A POST_WORDS
for POST in "${POSTS[@]}"; do
  W=$(body "$POST" | wc -w | tr -d ' ')
  POST_WORDS["$POST"]=$W
  ((TOTAL_WORDS+=W))
done

AVG=$((TOTAL_WORDS / TOTAL))
printf "Total words:       %d\n" "$TOTAL_WORDS"
printf "Average per post:  %d\n" "$AVG"
echo ""

# ── Posts by month ───────────────────────────────────────────────────────────

echo "Posts by month:"
for POST in "${POSTS[@]}"; do
  basename "$POST" | grep -oE '^[0-9]{4}-[0-9]{2}'
done | sort | uniq -c | awk '{ printf "  %s  (%d)\n", $2, $1 }'
echo ""

# ── Categories ───────────────────────────────────────────────────────────────

echo "Posts by category:"
for POST in "${POSTS[@]}"; do
  front_matter "$POST"
done | awk '/^categories:/{ in_c=1; next } in_c && /^ *-/{ print } in_c && /^[a-z]/{ in_c=0 }' \
  | sed 's/^ *- *//' \
  | sort | uniq -c | sort -rn \
  | awk '{ count=$1; $1=""; sub(/^ /,""); printf "  %-32s (%d)\n", $0, count }'
echo ""

# ── Top tags ─────────────────────────────────────────────────────────────────

echo "Top 15 tags:"
for POST in "${POSTS[@]}"; do
  front_matter "$POST"
done | awk '/^tags:/{ in_t=1; next } in_t && /^ *-/{ print } in_t && /^[a-z]/{ in_t=0 }' \
  | sed 's/^ *- *//' \
  | sort | uniq -c | sort -rn | head -15 \
  | awk '{ count=$1; $1=""; sub(/^ /,""); printf "  %-32s (%d)\n", $0, count }'
echo ""

# ── Longest posts ────────────────────────────────────────────────────────────

echo "5 longest posts:"
for POST in "${POSTS[@]}"; do
  echo "${POST_WORDS[$POST]} $(basename "$POST" .md)"
done | sort -rn | head -5 \
  | awk '{ printf "  %5d words  %s\n", $1, $2 }'
echo ""

# ── Shortest posts (scaffolds to finish) ─────────────────────────────────────

echo "5 shortest posts (likely need writing):"
for POST in "${POSTS[@]}"; do
  echo "${POST_WORDS[$POST]} $(basename "$POST" .md)"
done | sort -n | head -5 \
  | awk '{ printf "  %5d words  %s\n", $1, $2 }'

#!/usr/bin/env bash
#
# Lint all posts in _posts/ for common front matter issues.
# Exits 0 if no errors, 1 if any errors found.
#
# Usage:
#   bash tools/lint-posts.sh

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
POSTS_DIR="$SCRIPT_DIR/../_posts"

ERRORS=0
WARNINGS=0

error() { echo "  ERROR: $1"; ((ERRORS+=1)); }
warn()  { echo "  WARN:  $1"; ((WARNINGS+=1)); }

# Extract YAML front matter (lines between first and second ---)
front_matter() {
  awk 'NR>1{ if(/^---$/) exit; print }' "$1"
}

# Check if a list field (categories/tags) has at least one item
has_list_items() {
  local fm="$1" field="$2"
  echo "$fm" | awk "
    /^${field}:/ { in_field=1; next }
    in_field && /^ *-/ { found=1 }
    in_field && /^[a-z]/ { in_field=0 }
    END { exit !found }
  "
}

# ── Per-post checks ──────────────────────────────────────────────────────────

for POST in "$POSTS_DIR"/*.md; do
  NAME=$(basename "$POST")
  [[ "$NAME" == ".placeholder" ]] && continue

  echo "$NAME"
  FM=$(front_matter "$POST")

  # Required scalar fields must exist and be non-empty
  for FIELD in title date; do
    VALUE=$(echo "$FM" | grep "^${FIELD}:" | sed "s/^${FIELD}: *//" | tr -d '"'"'")
    if [[ -z "$VALUE" ]]; then
      error "missing or empty '$FIELD'"
    fi
  done

  # Required list fields must exist and have at least one item
  for FIELD in categories tags; do
    if ! echo "$FM" | grep -q "^${FIELD}:"; then
      error "missing '$FIELD'"
    elif ! has_list_items "$FM" "$FIELD"; then
      error "'$FIELD' has no items"
    fi
  done

  # Filename date must match front matter date
  FILE_DATE=$(echo "$NAME" | grep -oE '^[0-9]{4}-[0-9]{2}-[0-9]{2}' || true)
  FM_DATE=$(echo "$FM" | grep "^date:" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1 || true)
  if [[ -n "$FILE_DATE" && -n "$FM_DATE" && "$FILE_DATE" != "$FM_DATE" ]]; then
    error "filename date ($FILE_DATE) != front matter date ($FM_DATE)"
  fi

  # Tags should be lowercase
  _TAGFILE=$(mktemp)
  echo "$FM" | awk '/^tags:/{ in_t=1; next } in_t && /^ *-/{ print } in_t && /^[a-z]/{ exit }' \
    | sed 's/^ *- *//' > "$_TAGFILE"
  while IFS= read -r TAG; do
    [[ -z "$TAG" ]] && continue
    if [[ "$TAG" != "${TAG,,}" ]]; then
      warn "tag '$TAG' should be lowercase: '${TAG,,}'"
    fi
  done < "$_TAGFILE"
  rm -f "$_TAGFILE"
done

# ── Cross-post checks ────────────────────────────────────────────────────────

echo ""
echo "Checking for duplicate slugs..."
declare -A SLUGS
for POST in "$POSTS_DIR"/*.md; do
  NAME=$(basename "$POST" .md)
  [[ "$NAME" == ".placeholder" ]] && continue
  SLUG=$(echo "$NAME" | sed 's/^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}-//')
  if [[ -n "${SLUGS[$SLUG]+x}" ]]; then
    warn "duplicate slug '$SLUG': ${SLUGS[$SLUG]} and $NAME"
  fi
  SLUGS["$SLUG"]="$NAME"
done

# ── Summary ──────────────────────────────────────────────────────────────────

echo ""
if [[ $ERRORS -gt 0 ]]; then
  echo "Lint failed: $ERRORS error(s), $WARNINGS warning(s)"
  exit 1
else
  echo "Lint passed: 0 errors, $WARNINGS warning(s)"
fi

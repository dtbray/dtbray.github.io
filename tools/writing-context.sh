#!/usr/bin/env bash
#
# Print a session-start context snapshot for writing with Claude Code.
# Paste the output into a new session to bootstrap context quickly.
#
# Usage:
#   bash tools/writing-context.sh

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
POSTS_DIR="$SCRIPT_DIR/../_posts"

front_matter() { awk 'NR>1{ if(/^---$/) exit; print }' "$1"; }
body()         { awk 'NR==1{ next } /^---$/{ p=1; next } p{ print }' "$1"; }

# Collect posts
POSTS=()
for POST in "$POSTS_DIR"/*.md; do
  [[ "$(basename "$POST")" == ".placeholder" ]] && continue
  POSTS+=("$POST")
done

TOTAL=${#POSTS[@]}
DATE=$(date +"%Y-%m-%d")

echo "## Blog Context — $DATE"
echo ""
echo "Site: Rabid Curiosity (blog.thomas-bray.com)"
echo "Total posts: $TOTAL"
echo ""

# ── Post inventory by status ──────────────────────────────────────────────────

SCAFFOLD=()
PARTIAL=()
COMPLETE=()

for POST in "${POSTS[@]}"; do
  W=$(body "$POST" | wc -w | tr -d ' ')
  NAME=$(basename "$POST" .md)
  ENTRY="$W $NAME"
  if   [[ $W -lt 200 ]]; then SCAFFOLD+=("$ENTRY")
  elif [[ $W -lt 500 ]]; then PARTIAL+=("$ENTRY")
  else                        COMPLETE+=("$ENTRY")
  fi
done

echo "### Needs writing (< 200 words)"
if [[ ${#SCAFFOLD[@]} -eq 0 ]]; then
  echo "  (none)"
else
  for E in "${SCAFFOLD[@]}"; do
    printf "  %4d words  %s\n" $(echo "$E" | awk '{print $1, $2}')
  done
fi
echo ""

echo "### In progress (200–500 words)"
if [[ ${#PARTIAL[@]} -eq 0 ]]; then
  echo "  (none)"
else
  for E in "${PARTIAL[@]}"; do
    printf "  %4d words  %s\n" $(echo "$E" | awk '{print $1, $2}')
  done
fi
echo ""

echo "### Complete (500+ words)"
if [[ ${#COMPLETE[@]} -eq 0 ]]; then
  echo "  (none)"
else
  for E in "${COMPLETE[@]}"; do
    printf "  %4d words  %s\n" $(echo "$E" | awk '{print $1, $2}')
  done
fi
echo ""

# ── Series progress ───────────────────────────────────────────────────────────

echo "### Public Finance of the States series"
PF_POSTS=()
for POST in "${POSTS[@]}"; do
  FM=$(front_matter "$POST")
  if echo "$FM" | grep -q "Public Finance of the States"; then
    W=$(body "$POST" | wc -w | tr -d ' ')
    PF_POSTS+=("$W $(basename "$POST" .md)")
  fi
done
echo "  Posts in series: ${#PF_POSTS[@]}"
echo "  States covered: $(ls "$POSTS_DIR"/2*-public-finance-[a-z]*.md 2>/dev/null \
  | xargs -I{} basename {} .md \
  | grep -v 'overview\|northeast\|midwest\|south\|west\|states' \
  | wc -l | tr -d ' ')"
echo "  States remaining: roughly $((50 - $(ls "$POSTS_DIR"/2*-public-finance-[a-z]*.md 2>/dev/null \
  | xargs -I{} basename {} .md \
  | grep -v 'overview\|northeast\|midwest\|south\|west\|states' \
  | wc -l | tr -d ' ')))"
echo ""

# ── Tag vocabulary ────────────────────────────────────────────────────────────

echo "### Tag vocabulary (use these before inventing new ones)"
for POST in "${POSTS[@]}"; do
  front_matter "$POST"
done | awk '/^tags:/{ in_t=1; next } in_t && /^ *-/{ print } in_t && /^[a-z]/{ in_t=0 }' \
  | sed 's/^ *- *//' \
  | sort -u \
  | awk '{ printf "%s, ", $0 }' | sed 's/, $/\n/'
echo ""

# ── Recently added ────────────────────────────────────────────────────────────

echo "### Most recently added (last 5)"
for POST in "${POSTS[@]}"; do
  basename "$POST" .md
done | sort -r | head -5 | sed 's/^/  /'

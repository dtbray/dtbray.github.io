#!/usr/bin/env bash
#
# Claude Code SessionStart hook for dtbray.github.io
#
# Runs at the start of every remote session. Installs Ruby dependencies
# and surfaces writing context so Claude starts each session oriented.

set -euo pipefail

# Only run full setup in remote (web) sessions
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

# ── Install Ruby dependencies ─────────────────────────────────────────────────

if bundle check &>/dev/null; then
  : # gems already installed, nothing to do
else
  bundle install --quiet 2>&1 || echo "Warning: bundle install failed — Jekyll build tools may be unavailable"
fi

# ── Writing context ───────────────────────────────────────────────────────────

echo ""
echo "================================================================"
echo "  SESSION START — Rabid Curiosity"
echo "================================================================"
echo ""
echo "IMPORTANT: Before writing or editing any post, read WRITING.md."
echo "It contains voice guidance, structural patterns, and thematic"
echo "threads that must inform all content work."
echo ""

bash "$CLAUDE_PROJECT_DIR/tools/writing-context.sh"

echo ""
echo "================================================================"

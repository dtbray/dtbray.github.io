#!/usr/bin/env bash
#
# Claude Code SessionStart hook for dtbray.github.io
#
# Runs at the start of every session. Installs Ruby dependencies
# and surfaces writing context so Claude starts each session oriented.

set -euo pipefail

cd "$CLAUDE_PROJECT_DIR"

# ── Install Ruby dependencies ─────────────────────────────────────────────────

if ! bundle check &>/dev/null; then
  bundle install 2>&1 | tail -5 || echo "Warning: bundle install failed — run 'bundle install' manually before building"
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

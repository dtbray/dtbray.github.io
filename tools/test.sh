#!/usr/bin/env bash
#
# Build the Hugo site.

set -euo pipefail

if command -v hugo >/dev/null 2>&1; then
  exec hugo --gc --minify
fi

exec docker run --rm \
  -v "$PWD:/src" \
  -w /src \
  ghcr.io/gohugoio/hugo:v0.164.0 \
  --noBuildLock --noTimes --gc --minify

#!/usr/bin/env bash
# Build killswitch.mpackage for Mudlet (ZIP archive).
# Usage: ./scripts/build-mpackage.sh [version]
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="${1:-0.1.0}"
DIST="$ROOT/dist"
OUT="$DIST/killswitch-${VERSION}.mpackage"
mkdir -p "$DIST"
rm -f "$OUT"
(
  cd "$ROOT"
  zip -r "$OUT" config.lua killswitch.xml README.md src
)
echo "Built: $OUT"
echo "In Mudlet command line:"
echo "  lua installPackage([[$OUT]])"

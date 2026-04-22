#!/usr/bin/env bash
# Build killswitch.mpackage for Mudlet (ZIP archive).
# Usage (from repo root):
#   bash scripts/build-mpackage.sh
#   bash scripts/build-mpackage.sh 0.2.0
#
# If "nothing happens", run with bash explicitly — not `sh` (pipefail needs bash).

set -eu
if [ -n "${BASH_VERSION:-}" ]; then
  set -o pipefail
fi

echo "==> Killswitch: building .mpackage ..."

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="${1:-0.1.0}"
DIST="$ROOT/dist"
OUT="$DIST/killswitch-${VERSION}.mpackage"

if ! command -v zip >/dev/null 2>&1; then
  echo "ERROR: 'zip' not found. Install it (macOS: xcode-select --install provides it; or: brew install zip)" >&2
  exit 1
fi

for f in "$ROOT/config.lua" "$ROOT/killswitch.xml" "$ROOT/README.md" "$ROOT/src"; do
  if [ ! -e "$f" ]; then
    echo "ERROR: missing $f — run this script from the killswitch repo (use: bash scripts/build-mpackage.sh from repo root)." >&2
    exit 1
  fi
done

mkdir -p "$DIST"
rm -f "$OUT"

echo "==> Writing: $OUT"

(
  cd "$ROOT"
  zip -r "$OUT" config.lua killswitch.xml README.md src
)

if [ ! -f "$OUT" ]; then
  echo "ERROR: zip did not create $OUT" >&2
  exit 1
fi

BYTES=$(wc -c <"$OUT" | tr -d ' ')
echo "==> Done. Size: $BYTES bytes"
ls -la "$OUT"
echo ""
echo "Install in Mudlet command line:"
echo "  lua installPackage([[$OUT]])"
echo ""

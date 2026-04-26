#!/usr/bin/env bash
# Bundle cubiomes-viewer.app into a redistributable DMG via macdeployqt.
# Builds the .app first if it doesn't exist.
#
# Usage:
#   ./scripts/dist-macos.sh                # build + macdeployqt + .dmg
#   BUILD_DIR=release-build ./scripts/dist-macos.sh
#
# Requires Qt 6 (with macdeployqt) on PATH.
set -euo pipefail

cd "$(dirname "$0")/.."

if [ "$(uname -s)" != "Darwin" ]; then
    echo >&2 "ERROR: dist-macos.sh only runs on macOS"
    exit 1
fi

BUILD_DIR=${BUILD_DIR:-build}
APP="$BUILD_DIR/cubiomes-viewer.app"

if [ ! -d "$APP" ]; then
    echo "==> $APP not found; building"
    "$(dirname "$0")/build.sh"
fi

if QT_PREFIX=$(brew --prefix qt 2>/dev/null) && [ -x "$QT_PREFIX/bin/macdeployqt" ]; then
    MACDEPLOYQT="$QT_PREFIX/bin/macdeployqt"
elif command -v macdeployqt >/dev/null 2>&1; then
    MACDEPLOYQT=$(command -v macdeployqt)
else
    echo >&2 "ERROR: macdeployqt not found. Install Qt 6 with macdeployqt: brew install qt"
    exit 1
fi

# Drop a stale DMG so macdeployqt doesn't refuse to overwrite.
DMG="$BUILD_DIR/cubiomes-viewer.dmg"
rm -f "$DMG"

echo "==> $MACDEPLOYQT $APP -dmg"
"$MACDEPLOYQT" "$APP" -dmg

if [ -f "$DMG" ]; then
    echo
    echo "==> Built $DMG"
fi

cat <<EOF

Note: unsigned builds may be blocked by Gatekeeper. To run a local build
without code signing, strip the quarantine attribute:
    xattr -dr com.apple.quarantine $APP

To codesign + notarize for distribution, see the commented section in
.github/workflows/macos-release.yaml for the required commands and secrets.
EOF

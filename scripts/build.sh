#!/usr/bin/env bash
# Build cubiomes-viewer out-of-source. Works on macOS and Linux.
#
# Usage:
#   ./scripts/build.sh           # release build into ./build
#   CONFIG=debug ./scripts/build.sh
#   JOBS=4 ./scripts/build.sh
#   BUILD_DIR=mybuild ./scripts/build.sh
#
# Requires Qt 6 (qmake6) on PATH. On macOS:  brew install qt
set -euo pipefail

cd "$(dirname "$0")/.."

CONFIG=${CONFIG:-release}
BUILD_DIR=${BUILD_DIR:-build}

if command -v qmake6 >/dev/null 2>&1; then
    QMAKE=qmake6
elif command -v qmake-qt6 >/dev/null 2>&1; then
    QMAKE=qmake-qt6
elif command -v qmake >/dev/null 2>&1; then
    QMAKE=qmake
else
    echo >&2 "ERROR: qmake6 not found on PATH."
    echo >&2 "       macOS: brew install qt"
    echo >&2 "       Linux: install qt6-base-dev (or distro equivalent)"
    exit 1
fi

if [ -n "${JOBS:-}" ]; then
    :
elif command -v getconf >/dev/null 2>&1 && JOBS=$(getconf _NPROCESSORS_ONLN 2>/dev/null) && [ -n "$JOBS" ]; then
    :
elif command -v nproc >/dev/null 2>&1; then
    JOBS=$(nproc)
elif [ "$(uname -s)" = Darwin ] && command -v sysctl >/dev/null 2>&1; then
    JOBS=$(sysctl -n hw.ncpu)
else
    JOBS=4
fi

if [ ! -e cubiomes/finders.c ]; then
    echo "==> cubiomes submodule missing; initializing"
    git submodule update --init --recursive
fi

echo "==> $QMAKE CONFIG+=$CONFIG  (build dir: $BUILD_DIR)"
mkdir -p "$BUILD_DIR"
(
    cd "$BUILD_DIR"
    "$QMAKE" CONFIG+="$CONFIG" ..
    echo "==> make -j$JOBS"
    make -j"$JOBS"
)

case "$(uname -s)" in
    Darwin)
        APP="$BUILD_DIR/cubiomes-viewer.app"
        if [ -d "$APP" ]; then
            echo
            echo "==> Built $APP"
            echo "    Launch: open $APP"
        fi
        ;;
    *)
        BIN="$BUILD_DIR/cubiomes-viewer"
        if [ -f "$BIN" ]; then
            echo
            echo "==> Built $BIN"
        fi
        ;;
esac

#!/usr/bin/env bash
# Remove all build artifacts: out-of-source build dirs, in-source qmake
# leftovers (in case the project root got polluted by a default `qmake .`
# run), the .app bundle, and any DMGs. Also cleans cubiomes/.
set -euo pipefail

cd "$(dirname "$0")/.."

echo "==> Removing build/"
rm -rf build

echo "==> Removing in-source qmake leftovers (project root)"
rm -f Makefile Makefile.* .qmake.stash
rm -f *.o moc_*.cpp moc_*.h qrc_*.cpp ui_*.h
rm -rf cubiomes-viewer.app
rm -f cubiomes-viewer.dmg

if [ -f cubiomes/makefile ]; then
    echo "==> make -C cubiomes clean"
    make -C cubiomes clean >/dev/null 2>&1 || true
fi

echo "==> Done"

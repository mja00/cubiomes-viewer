# Cubiomes Viewer

Cubiomes Viewer provides a graphical interface for the efficient and flexible
seed-finding utilities provided by [cubiomes](https://github.com/Cubitect/cubiomes)
and a map viewer for the Minecraft biomes and structure generation.

The tool is designed for high performance and supports Minecraft Java Edition
main releases up to **26.1.2** (the new year-based versioning scheme that
replaces 1.21.x).


## About this fork

This is a fork of [Cubitect/cubiomes-viewer](https://github.com/Cubitect/cubiomes-viewer)
maintained by [mja00](https://github.com/mja00) that extends version support
beyond upstream. Compared to upstream it adds:

- **Minecraft 1.21.4 through 26.1.2** as selectable versions (upstream
  currently stops at 1.21.3 + a `1.21 WD` placeholder).
- **An accurate 1.21.5 biome tree** (`btree21_5.h`) reflecting the pale_garden
  expansion into the dark_forest plateau cell, and the matching mansion
  biome rule update.
- **A pure-Python biome-tree generator** at
  [`cubiomes/docs/btreegen.py`](https://github.com/mja00/cubiomes/blob/master/docs/btreegen.py)
  that ports Mojang's `Climate.RTree.build()` and the relevant subset of
  `OverworldBiomeBuilder` to Python, enabling reproducible (bit-exact)
  regeneration of the binary biome trees without an IntelliJ debugger session.
- **Apple Silicon native build + macOS / Linux CI** producing `.dmg` and
  `.AppImage` artifacts.
- **`scripts/build.sh` / `scripts/dist-macos.sh` / `scripts/clean.sh`** for
  out-of-source builds without polluting the project root.

The cubiomes C library is also forked at
[mja00/cubiomes](https://github.com/mja00/cubiomes) to host the version
additions.


## Download

### Latest builds from `trunk` (no GitHub login required)

These links always resolve to the artifact from the most recent successful
CI run on `trunk`, proxied through [nightly.link](https://nightly.link/) so
you don't need to be signed into GitHub to download them.

| Platform | Artifact | Download |
|---|---|---|
| macOS (Apple Silicon, arm64) | `.dmg` | [cubiomes-viewer-macos-arm64.zip](https://nightly.link/mja00/cubiomes-viewer/workflows/macos-release.yaml/trunk/cubiomes-viewer-macos-arm64.zip) |
| Linux (x86_64) | `.AppImage` | [cubiomes-viewer-linux-x86_64.zip](https://nightly.link/mja00/cubiomes-viewer/workflows/linux-release.yaml/trunk/cubiomes-viewer-linux-x86_64.zip) |
| Windows | folder w/ `.exe` + Qt DLLs | [cubiomes-viewer-win.zip](https://nightly.link/mja00/cubiomes-viewer/workflows/windows-release.yaml/trunk/cubiomes-viewer-win.zip) |

Each download is a `.zip` containing the platform-native artifact (since
GitHub Actions wraps all artifacts in a zip).

### Tagged releases

Tagged releases live in the [releases section](https://github.com/mja00/cubiomes-viewer/releases)
of this fork; upstream
[Cubitect/cubiomes-viewer releases](https://github.com/Cubitect/cubiomes-viewer/releases)
hosts the older single-file statically-linked executables.

A Flatpak for the upstream tool is available on
[Flathub](https://flathub.org/apps/details/com.github.cubitect.cubiomes-viewer).

For Arch Linux users, the upstream tool may be found in the
[AUR](https://aur.archlinux.org/packages/cubiomes-viewer) thanks to
[JakobDev](https://github.com/JakobDev).


## Build from source

Detailed instructions are in [`buildguide.md`](buildguide.md). On macOS or
Linux, the quick path is:

```sh
brew install qt                       # macOS  (or apt install qt6-base-dev on Linux)
git clone --recursive https://github.com/mja00/cubiomes-viewer.git
cd cubiomes-viewer
./scripts/build.sh                    # release build into ./build
open build/cubiomes-viewer.app        # macOS;  on Linux: ./build/cubiomes-viewer
```

For a redistributable macOS DMG: `./scripts/dist-macos.sh`. To wipe artifacts:
`./scripts/clean.sh`.


## Basic feature overview

The tool features a map viewer that outlines the biomes of the Overworld,
Nether and End dimensions, with a wide zoom range and with toggles for each
supported structure type. The active game version and seed can be changed
on the fly while a matching seeds list stores a working buffer of seeds for
examination.

The integrated seed finder is highly customizable, utilizing a hierarchical
condition system that allows the user to look for features that are relative to
one another. Conditions can be based on a varity of criteria, including
structure placement, world spawn point and requirements for the biomes of an
area. The search supports Quad-Hut and Quad-Monument seed generators, which can
quickly look for seeds that include extremely rare structure constellations.
For more complex searches, the tool provides logic gates in the form of helper
conditions and can integrate Lua scripts to create custom filters that can be
edited right inside the tool.

It is also possible to find Locations in a fixed seed. In this mode, the
conditions are checked against a list of trial positions instead of the
world origin. Each location that passes the conditions is then collected
with additional information on where each individual condition was triggered.

An analysis of the biomes and structures can be performed in their respective
tabs. This provides information on the amount of biomes and structures that
are available in an area, as well as their size and positions.


## Screenshots

Screenshots were taken of Cubiomes Viewer v4.0.

![seeds](etc/screenshot_seeds-fs8.png
"Searching for a quad-hut near a stronghold with a good biome variety")

![locations](etc/screenshot_locations-fs8.png
"Locations in a given seed while viewing the world's height map")

![structures](etc/screenshot_structures-fs8.png
"Examining structures in the nether")


## Languages

The active language can be selected under `Edit preferences`, which currently includes translations for:

- English
- German
- Chinese

Chinese translations are provided by [SunnySlopes](https://github.com/SunnySlopes)
and are maintained at [his fork](https://github.com/SunnySlopes/cubiomes-viewer).


## Known issues

Desert Pyramids, Jungle Temples and, to a lesser extent, Woodland Mansions can
fail to generate in 1.18+ due to unsuitable terrain. Cubiomes will make an
attempt to estimate the terrain based on the biomes and climate noise. However,
expect some inaccurate results.

The World Spawn point for pre-1.18 versions can sometimes be off because it
depends on the presence of a grass block, that cubiomes cannot test for.


## Legal information

The main code is under the GPLv3, see [LICENSE](LICENSE), while other
components are released under their respective author licenses:

- Biome and structure generation from cubiomes, licensed under MIT.
- Cross platform [Qt](https://www.qt.io/licensing) GUI toolkit, available under (L)GPLv3.
- Dark Qt theme derived from [QDarkStyleSheet](https://github.com/ColinDuquesnoy/QDarkStyleSheet), licensed under MIT.
- Biome colors and icons are inspired by [Amidst](https://github.com/toolbox4minecraft/amidst), licensed under GPLv3.
- [Lua](https://www.lua.org/license.html) is distributed under the terms of the MIT license.

NOT AN OFFICIAL MINECRAFT PRODUCT.
NOT APPROVED BY OR ASSOCIATED WITH MOJANG OR MICROSOFT.



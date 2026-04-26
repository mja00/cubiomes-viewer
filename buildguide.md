# Cubiomes Viewer Build Instructions

Cubiomes Viewer is a **Qt 6** application and requires:
* Qt 6.x (the `qmake` from your Qt 6 install must report `QT_VERSION` ≥ 6.0; many Linux distros ship it as `qmake6`)
* A GNU C++17 toolchain (GCC or Clang).

The cubiomes library is included as a submodule to this repository.


## The Compiler

You should have either GCC or Clang installed.

Windows users can use MinGW, which can be installed together with Qt, using the Qt Installer.


## Get Qt 6

Depending on your operating system you may have several options for installing Qt 6,
but [Using the Qt Installer](buildguide.md#using-the-qt-installer) should be the most general method.
Many Linux distros already provide Qt in their repositories and you can also
[Get Qt With Your Package Manager](buildguide.md#get-qt-with-your-package-manager) instead if you wish.

For a static build you will have to [Compile Qt from Source](buildguide.md#compile-qt-from-source).


### Using the Qt Installer

You can use the [Qt Online Installer](https://www.qt.io/download-qt-installer) if you have a Qt account or don't mind creating one.
It is also possible to use the [Qt Offline Installer](https://www.qt.io/offline-installers) without an account,
but you have to disconnect from the internet when you launch the installer, otherwise it will require a Qt account again, which is a little irritating.

Choose an installation path without spaces.

The only required component is the Qt 6 **Qt Widgets** / **Qt Gui** / **Qt Core** stack for your compiler (qtbase).
(Make sure to select a compiler which supports GNU extensions, such as MinGW.)

I would also recommend installing QtCreator, as well as MinGW on Windows from the Developer Tools.


### Get Qt With Your Package Manager

##### Debian / Ubuntu
```
$ sudo apt install build-essential qt6-base-dev qt6-base-dev-tools qmake6
```
##### Fedora
```
$ sudo dnf install qt6-qtbase-devel qt6-linguist
```
##### Arch Linux
```
$ sudo pacman -S qt6-base
```
(`qmake6` is provided by the `qt6-base` package.)
##### macOS
```
$ xcode-select --install
$ brew install qt
```
This installs Qt 6 (the current Homebrew default; `qt@5` is no longer in
Homebrew core). The `qmake6` binary will be on `PATH` after `brew link qt`
runs automatically as part of the install.

#### Quick path: build scripts

The `scripts/` directory contains thin wrappers around `qmake6` + `make` +
`macdeployqt` so you don't have to remember the incantations. Builds are
out-of-source (in `./build/`), keeping the project root clean.
```
$ git clone --recursive https://github.com/Cubitect/cubiomes-viewer.git
$ cd cubiomes-viewer
$ ./scripts/build.sh                  # release build into ./build
$ open build/cubiomes-viewer.app
```
For a redistributable disk image (runs `macdeployqt` to bundle Qt frameworks
into the .app, then produces a `.dmg`):
```
$ ./scripts/dist-macos.sh
```
To wipe build artifacts:
```
$ ./scripts/clean.sh
```
The build script honors a few env vars: `CONFIG=debug`, `JOBS=N`, `BUILD_DIR=…`.

Unsigned builds may be blocked by Gatekeeper. To launch a local build
without code signing, strip the quarantine attribute:
```
$ xattr -dr com.apple.quarantine build/cubiomes-viewer.app
```

#### Manual path

If you'd rather invoke the tools directly:
```
$ qmake6 .
$ make -j$(sysctl -n hw.ncpu)
$ open cubiomes-viewer.app
$ $(brew --prefix qt)/bin/macdeployqt cubiomes-viewer.app -dmg
```
Note that `qmake6 .` builds in-source and pollutes the project root with
`.o` / `moc_*` / `qrc_*` files. The script-based path uses an out-of-source
`build/` directory instead.

### Compile Qt from Source

You can get the Qt sources from the [Qt download archive](https://download.qt.io/archive/qt).
For cubiomes-viewer it is sufficient to get the qtbase submodule.

Check the system requirements in the Qt documentation for building qtbase from source,
which will depend on the platform and Qt version.

A possible configuration for a static build may be (adjust version and archive URL):
```
$ mkdir qt6src; cd qt6src
$ wget https://download.qt.io/archive/qt/6.8/6.8.2/submodules/qtbase-everywhere-opensource-src-6.8.2.tar.xz
$ tar xf qtbase-everywhere-opensource-src-6.8.2.tar.xz
$ cmake -S qtbase-everywhere-src-6.8.2 -B build -G Ninja \
    -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_INSTALL_PREFIX="$PWD/prefix"
$ cmake --build build
$ cmake --install build
```
(Older tarballs used `configure`; Qt 6.5+ commonly uses CMake. Follow the README in the qtbase archive you download.)

## Get the Cubiomes Sources

The cubiomes-viewer repository includes the cubiomes library as a submodule and requires a recursive clone:
```
$ git clone --recursive https://github.com/Cubitect/cubiomes-viewer.git
```
If you have Qt Creator you can open the `cubiomes-viewer.pro` file and select a **Qt 6** kit.

Alternatively you can manually prepare a build directory:
```
$ cd cubiomes-viewer
$ mkdir build
$ cd build
```
and build cubiomes-viewer:
```
$ qmake6 ..
$ make
```

#### Notes:

With some Qt installs the binary is `qmake-qt6` instead of `qmake6`.
With MinGW the make command is something like `minwgw32-make` instead.
If the commands are not found, make sure that the Qt `bin` directory is in the `PATH` variable.
(The same applies to `C:/Qt/Qt15.12.12/Tools/mingw730_64/bin` or wherever your compiler is installed.)



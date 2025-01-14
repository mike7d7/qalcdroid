#!/bin/sh

if [ -d "/usr/share/" ]; then
  DIR="/usr/share/qalculate"
else
  # TODO: don't hard-link share path in nix
  DIR="/nix/store/bv2ayb7dp0am1j8j5iqljkxa9l39h1l5-libqalculate-5.5.0/share/qalculate"
fi
cp $DIR/functions.xml functions.xml
cp $DIR/units.xml units.xml
cp $DIR/variables.xml variables.xml
cp $DIR/currencies.xml currencies.xml
cp $DIR/eurofxref-daily.xml eurofxref-daily.xml

# Initialize godot-cpp submodule and build C++ bindings
cd godot-cpp/
git submodule update --init

# Binary is named 'godot4' in NixOS, in other distros is 'godot'
if command -v godot4 >/dev/null 2>&1; then
    GODOT_CMD="godot4"
elif command -v godot >/dev/null 2>&1; then
    GODOT_CMD="godot"
else
    echo "Godot executable not found"
    exit 1
fi
$GODOT_CMD --dump-extension-api
scons custom_api_file=extension_api.json
cd ..

# Build libraries for Android
cd libs-build/
./build-libs-android.sh
cd ..

# Build gdextension code
scons
scons platform=android

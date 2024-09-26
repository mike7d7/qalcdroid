#!/bin/sh

if [ -d "/usr/share/" ]; then
  DIR="/usr/share/qalculate"
else
  # TODO: don't hard-link share path in nix
  DIR="/nix/store/g95m2qgx2zy4pddjxv0q09z4p23wd2gr-libqalculate-5.2.0/share/qalculate"
fi
cp $DIR/functions.xml functions.xml
cp $DIR/units.xml units.xml
cp $DIR/variables.xml variables.xml

# Initialize godot-cpp submodule and build C++ bindings
cd godot-cpp/
git submodule update --init
godot --dump-extension-api
scons custom_api_file=extension_api.json

# Build gdextension code
cd ..
scons
scons platform=android

#!/bin/sh

if [ -d "/usr/share/" ]; then
  DIR="/usr/share/qalculate"
else
  # TODO: don't hard-link share path in nix
  DIR="/nix/store/f5pp1svgak2fq94zjsjap5crm73qd7v2-libqalculate-5.3.0/share/qalculate"
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

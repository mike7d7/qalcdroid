# Building

Currently only Android arm64 is supported. Support for armv7a is planned but not yet supported.

## Android Debug

1. Clone the repository, `cd` into it
2. Install dependencies manually or run `nix-shell` if you're in NixOS
3. Run `./prepare-build.sh`
4. Open the project in the Godot editor
5. Reload the project in the editor
6. Set up Java and Android SDK paths. [Godot's docs](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html)
7. Use [one-click deploy](https://docs.godotengine.org/en/stable/tutorials/export/one-click_deploy.html) or the export menu

## Android Release

1. Clone the repository, `cd` into it
2. Install dependencies manually or run `nix-shell` if you're in NixOS
3. Run `./prepare-build.sh`
4. Run `scons platform=android target=template_release arch=arm64 optimize=speed`
5. Open the project in the Godot editor
6. Reload the project in the editor
7. Set up Java and Android SDK paths. [Godot's docs](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html)
8. Use the export menu and **deselect** "Export with Debug"

let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-unstable";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

let
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    cmdLineToolsVersion = "latest";
    toolsVersion = "latest";
    platformToolsVersion = "34.0.0";
    buildToolsVersions = [ "34.0.0" ];
    includeEmulator = false;
    emulatorVersion = "30.3.4";
    platformVersions = [ "34" ];
    includeSources = false;
    includeSystemImages = false;
    systemImageTypes = [ "google_apis_playstore" ];
    abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
    cmakeVersions = [ "3.10.2.4988404" ];
    includeNDK = true;
    ndkVersions = ["23.2.85683131"];
    useGoogleAPIs = false;
    useGoogleTVAddOns = false;
  };
in

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    godot_4
    scons
    libqalculate
    jdk17
    pkg-config
  ];
  libPath = pkgs.lib.makeLibraryPath [
    pkgs.libqalculate
  ];
  shellHook = ''
    alias godot="godot4"
  '';
}



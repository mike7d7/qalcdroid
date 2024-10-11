let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-unstable";
  pkgs = import nixpkgs { 
    config = {
      android_sdk.accept_license = true;
      allowUnfree = true;
    };
    overlays = [];
  };
in

let
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    cmdLineToolsVersion = "13.0";
    toolsVersion = "26.1.1";
    platformToolsVersion = "34.0.4";
    buildToolsVersions = [ "34.0.0" ];
    includeEmulator = false;
    emulatorVersion = "30.3.4";
    platformVersions = [ "34" ];
    includeSources = false;
    includeSystemImages = false;
    systemImageTypes = [ "google_apis_playstore" ];
    abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
    cmakeVersions = [ "3.10.2" ];
    includeNDK = true;
    ndkVersions = ["23.2.8568313"];
    useGoogleAPIs = false;
    useGoogleTVAddOns = false;
  };

  ndkVersion = androidComposition.ndkVersions.head;
in

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    godot_4
    scons
    libqalculate
    jdk17
    pkg-config
    android-udev-rules
  ];
  libPath = pkgs.lib.makeLibraryPath [
    pkgs.libqalculate
  ];
  shellHook = ''
    alias godot="godot4"
    export ANDROID_HOME="${androidComposition.androidsdk}/libexec/android-sdk";
    export ANDROID_NDK_ROOT="$ANDROID_HOME/ndk/23.2.8568313";
    export ANDROID_SDK_ROOT="$ANDROID_HOME"
    export GRADLE_OPTS="-Dorg.gradle.project.android.aapt2FromMavenOverride=$ANDROID_HOME/build-tools/34.0.0/aapt2";
  '';
}



# Native Libraries

This project has a dependency on [libqalculate](https://github.com/Qalculate/libqalculate) which depends on
multiple other C or C++ libraries. All of this libraries are built using the [build-libs-android.sh](../libs-build/build-libs-android.sh)
bash script which surprisingly was the easiest way of getting a static binary (.a) for Android. The script sets
many environment variables to compile the native libraries with the Android NDK. If you used the `prepare-build.sh` script
you shouldn't have to manually run the [build-libs-android.sh](../libs-build/build-libs-android.sh) script, as it's
automatically called from the former.

The [build-libs-android.sh](../libs-build/build-libs-android.sh) statically compiles all dependencies for Android
and outputs the resulting binaries to `libs-build/outputs`, where the GDExtension expects them to be.

Currently the script only works for arm64 (armv8a), support for armv7a is planned.

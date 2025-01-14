#!/bin/sh
set -e

TARGET_ARCHS=("arm64")

CURL_VERSION="7.64.1"
OPENSSL_VERSION="3.4.0"
GMP_VERSION="6.3.0"
MPFR_VERSION="4.2.1"
XZ_VERSION="5.6.3"
ICONV_VERSION="1.17"
XML2_VERSION="2.13.5"
QALCULATE_VERSION="5.5.0"

ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
WORKER=$(getconf _NPROCESSORS_ONLN)
BUILD_DIR_CURL="$ROOT_DIR/build/android/curl"
BUILD_DIR_OPENSSL="$ROOT_DIR/build/android/openssl"
BUILD_DIR_GMP="$ROOT_DIR/build/android/gmp"
BUILD_DIR_MPFR="$ROOT_DIR/build/android/mpfr"
BUILD_DIR_XZ="$ROOT_DIR/build/android/xz"
BUILD_DIR_ICONV="$ROOT_DIR/build/android/iconv"
BUILD_DIR_XML2="$ROOT_DIR/build/android/xml2"
BUILD_DIR_QALCULATE="$ROOT_DIR/build/android/qalculate"
LOG_FILE="$BUILD_DIR_OPENSSL/build.log"

COLOR_GREEN="\033[38;5;48m"
COLOR_END="\033[0m"

export ANDROID_TOOLCHAIN="$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64"
export ANDROID_NDK_HOME=$ANDROID_NDK_ROOT
export PATH="$ANDROID_TOOLCHAIN/bin:$PATH"

if [[ -z "$ANDROID_NDK_ROOT" ]]; then
    echo "set NDK_ROOT env variable"
    exit 1
fi
error() {
    echo -e "$@" 1>&2
}

fail() {
    error "$@"
    exit 1
}
if [ -d "$ROOT_DIR/outputs" ]; then
    rm -rf "$ROOT_DIR/outputs"
fi
mkdir -p "$ROOT_DIR/outputs"
OUTPUT_DIR="$ROOT_DIR/outputs"

# gmp
cd "$ROOT_DIR" || exit 1

LOG_FILE="$BUILD_DIR_GMP/build.log"

if [ -d "$BUILD_DIR_GMP/tar" ]; then
  rm -rf "$BUILD_DIR_GMP/tar"
fi
if [ -d "$BUILD_DIR_GMP/src" ]; then
  rm -rf "$BUILD_DIR_GMP/src"
fi
if [ -d "$BUILD_DIR_GMP/install" ]; then
  rm -rf "$BUILD_DIR_GMP/install"
fi

if [ -f "$LOG_FILE" ]; then
    rm "$LOG_FILE"
    touch "$LOG_FILE"
fi

mkdir -p "$BUILD_DIR_GMP/tar"
mkdir -p "$BUILD_DIR_GMP/src"
mkdir -p "$BUILD_DIR_GMP/install"

cd "$ROOT_DIR"
echo "Downloading GMP..."
curl -Lo "$BUILD_DIR_GMP/tar/gmp-$GMP_VERSION.tar.gz" "https://gmplib.org/download/gmp/gmp-$GMP_VERSION.tar.gz" >> "$LOG_FILE" 2>&1 || fail "Error Downloading gmp"
echo "Uncompressing GMP..."
tar xzf "$BUILD_DIR_GMP/tar/gmp-$GMP_VERSION.tar.gz" -C "$BUILD_DIR_GMP/src" || fail "Error Uncompressing GMP"
cd "$BUILD_DIR_GMP/src/gmp-$GMP_VERSION"

for CURRENT_ARCH in "${TARGET_ARCHS[@]}"; do
    echo "Building GMP for $CURRENT_ARCH build..."

    make clean 1>& /dev/null || true

    echo "-> Configuring GMP for $CURRENT_ARCH build..."
    case $CURRENT_ARCH in
        armv7)
        fail "-> $CURRENT_ARCH is currently unsupported"
        ;;
        arm64)
            export HOST="aarch64-linux-android"

            export CC="aarch64-linux-android22-clang"
            export CXX="aarch64-linux-android22-clang++"
            export AR="llvm-ar"
            export AS="aarch64-linux-android-as"
            export LD="ld"
            export RANLIB="llvm-ranlib"
            export NM="llvm-nm"
            export STRIP="llvm-strip"

            export CFLAGS="--sysroot=$ANDROID_TOOLCHAIN/sysroot -fPIC -DANDROID -D__ANDROID_API__=22 -O3"
            export CPPFLAGS="$CFLAGS"
            export LDFLAGS="-static-libstdc++"

            ./configure --host=$HOST --enable-assembly=no --enable-static --enable-shared=no >> "$LOG_FILE" 2>&1 || fail "-> Error Configuring GMP for $CURRENT_ARCH"
        ;;
        x86)
        fail "-> $CURRENT_ARCH is currently unsupported"
        ;;
        x86_64)
        fail "-> $CURRENT_ARCH is currently unsupported"
        ;;
    esac

    # sed -i '' -e 's~#define HAVE_STRDUP~//#define HAVE_STRDUP~g' configure
    echo "-> Configured GMP for $CURRENT_ARCH"

    echo "-> Compiling GMP for $CURRENT_ARCH..."
    make -j "$WORKER" >> "$LOG_FILE" 2>&1 || fail "-> Error Compiling GMP for $CURRENT_ARCH"
    echo "-> Compiled GMP for $CURRENT_ARCH"

    echo "-> Installing GMP for $CURRENT_ARCH to $BUILD_DIR_GMP/install/gmp/$CURRENT_ARCH..."
    make install DESTDIR="$BUILD_DIR_GMP/install/gmp/$CURRENT_ARCH" >> "$LOG_FILE" 2>&1 || fail "-> Error Installing GMP for $CURRENT_ARCH"
    cp "$BUILD_DIR_GMP/install/gmp/$CURRENT_ARCH/usr/local/lib/libgmp.a" "$OUTPUT_DIR"
    echo "-> Installed GMP for $CURRENT_ARCH"

    echo "Successfully built GMP for $CURRENT_ARCH"
done

echo -e "${COLOR_GREEN}gmp built successfully for all ARCH targets.${COLOR_END}"

# mpfr
cd "$ROOT_DIR" || exit 1

LOG_FILE="$BUILD_DIR_MPFR/build.log"

if [ -d "$BUILD_DIR_MPFR/tar" ]; then
  rm -rf "$BUILD_DIR_MPFR/tar"
fi
if [ -d "$BUILD_DIR_MPFR/src" ]; then
  rm -rf "$BUILD_DIR_MPFR/src"
fi
if [ -d "$BUILD_DIR_MPFR/install" ]; then
  rm -rf "$BUILD_DIR_MPFR/install"
fi

if [ -f "$LOG_FILE" ]; then
    rm "$LOG_FILE"
    touch "$LOG_FILE"
fi

mkdir -p "$BUILD_DIR_MPFR/tar"
mkdir -p "$BUILD_DIR_MPFR/src"
mkdir -p "$BUILD_DIR_MPFR/install"

cd "$ROOT_DIR"
echo "Downloading MPFR..."
curl -Lo "$BUILD_DIR_MPFR/tar/mpfr-$MPFR_VERSION.tar.gz" "https://www.mpfr.org/mpfr-current/mpfr-$MPFR_VERSION.tar.gz" >> "$LOG_FILE" 2>&1 || fail "Error Downloading gmp"
echo "Uncompressing MPFR..."
tar xzf "$BUILD_DIR_MPFR/tar/mpfr-$MPFR_VERSION.tar.gz" -C "$BUILD_DIR_MPFR/src" || fail "Error Uncompressing MPFR"
cd "$BUILD_DIR_MPFR/src/mpfr-$MPFR_VERSION"

for CURRENT_ARCH in "${TARGET_ARCHS[@]}"; do
    echo "Building MPFR for $CURRENT_ARCH build..."

    make clean 1>& /dev/null || true

    echo "-> Configuring MPFR for $CURRENT_ARCH build..."
    case $CURRENT_ARCH in
        armv7)
        fail "-> $CURRENT_ARCH is currently unsupported"
        ;;
        arm64)
            export HOST="aarch64-linux-android"

            export CC="aarch64-linux-android22-clang"
            export CXX="aarch64-linux-android22-clang++"
            export AR="llvm-ar"
            export AS="aarch64-linux-android-as"
            export LD="ld"
            export RANLIB="llvm-ranlib"
            export NM="llvm-nm"
            export STRIP="llvm-strip"

            export CFLAGS="--sysroot=$ANDROID_TOOLCHAIN/sysroot -fPIC -DANDROID -D__ANDROID_API__=22 -O3"
            export CPPFLAGS="$CFLAGS"
            export LDFLAGS="-static"

            ./configure --host=$HOST --with-gmp="$BUILD_DIR_GMP/install/gmp/$CURRENT_ARCH/usr/local" >> "$LOG_FILE" 2>&1 || fail "-> Error Configuring GMP for $CURRENT_ARCH"
        ;;
        x86)
        fail "-> $CURRENT_ARCH is currently unsupported"
        ;;
        x86_64)
        fail "-> $CURRENT_ARCH is currently unsupported"
        ;;
    esac

    # sed -i '' -e 's~#define HAVE_STRDUP~//#define HAVE_STRDUP~g' configure
    echo "-> Configured MPFR for $CURRENT_ARCH"

    echo "-> Compiling MPFR for $CURRENT_ARCH..."
    make -j "$WORKER" >> "$LOG_FILE" 2>&1 || fail "-> Error Compiling MPFR for $CURRENT_ARCH"
    echo "-> Compiled MPFR for $CURRENT_ARCH"

    echo "-> Installing MPFR for $CURRENT_ARCH to $BUILD_DIR_MPFR/install/mpfr/$CURRENT_ARCH..."
    make install DESTDIR="$BUILD_DIR_MPFR/install/mpfr/$CURRENT_ARCH" >> "$LOG_FILE" 2>&1 || fail "-> Error Installing MPFR for $CURRENT_ARCH"
    rm $BUILD_DIR_MPFR/install/mpfr/$CURRENT_ARCH/usr/local/lib/libmpfr.la
    sed -i "s|write_custom_path_here|$BUILD_DIR_GMP/install/gmp/arm64/usr/local/lib|g" "$ROOT_DIR/libmpfr.la"
    cp $ROOT_DIR/libmpfr.la $BUILD_DIR_MPFR/install/mpfr/$CURRENT_ARCH/usr/local/lib/libmpfr.la
    cp "$BUILD_DIR_MPFR/install/mpfr/$CURRENT_ARCH/usr/local/lib/libmpfr.a" "$OUTPUT_DIR"
    sed -i "s|$BUILD_DIR_GMP/install/gmp/arm64/usr/local/lib|write_custom_path_here|g" "$ROOT_DIR/libmpfr.la"
    echo "-> Installed MPFR for $CURRENT_ARCH"

    echo "Successfully built MPFR for $CURRENT_ARCH"
done

echo -e "${COLOR_GREEN}MPFR built successfully for all ARCH targets.${COLOR_END}"

# xz
cd "$ROOT_DIR" || exit 1

LOG_FILE="$BUILD_DIR_XZ/build.log"

if [ -d "$BUILD_DIR_XZ/tar" ]; then
  rm -rf "$BUILD_DIR_XZ/tar"
fi
if [ -d "$BUILD_DIR_XZ/src" ]; then
  rm -rf "$BUILD_DIR_XZ/src"
fi
if [ -d "$BUILD_DIR_XZ/install" ]; then
  rm -rf "$BUILD_DIR_XZ/install"
fi

if [ -f "$LOG_FILE" ]; then
    rm "$LOG_FILE"
    touch "$LOG_FILE"
fi

mkdir -p "$BUILD_DIR_XZ/tar"
mkdir -p "$BUILD_DIR_XZ/src"
mkdir -p "$BUILD_DIR_XZ/install"

cd "$ROOT_DIR"
echo "Downloading XZ..."
curl -Lo "$BUILD_DIR_XZ/tar/xz-$XZ_VERSION.tar.gz" "https://github.com/tukaani-project/xz/releases/download/v5.6.3/xz-$XZ_VERSION.tar.gz" >> "$LOG_FILE" 2>&1 || fail "Error Downloading xz"
echo "Uncompressing XZ..."
tar xzf "$BUILD_DIR_XZ/tar/xz-$XZ_VERSION.tar.gz" -C "$BUILD_DIR_XZ/src" || fail "Error Uncompressing GMP"
cd "$BUILD_DIR_XZ/src/xz-$XZ_VERSION"

for CURRENT_ARCH in "${TARGET_ARCHS[@]}"; do
    echo "Building XZ for $CURRENT_ARCH build..."

    make clean 1>& /dev/null || true

    echo "-> Configuring XZ for $CURRENT_ARCH build..."
    case $CURRENT_ARCH in
        armv7)
        fail "-> $CURRENT_ARCH is currently unsupported"
        ;;
        arm64)
            export HOST="aarch64-linux-android"

            export CC="aarch64-linux-android22-clang"
            export CXX="aarch64-linux-android22-clang++"
            export AR="llvm-ar"
            export AS="aarch64-linux-android-as"
            export LD="ld"
            export RANLIB="llvm-ranlib"
            export NM="llvm-nm"
            export STRIP="llvm-strip"

            export CFLAGS="--sysroot=$ANDROID_TOOLCHAIN/sysroot -fPIC -DANDROID -D__ANDROID_API__=22 -O3"
            export CPPFLAGS="$CFLAGS"
            export LDFLAGS="-static"

            ./configure --host=$HOST >> "$LOG_FILE" 2>&1 || fail "-> Error Configuring XZ for $CURRENT_ARCH"
        ;;
        x86)
        fail "-> $CURRENT_ARCH is currently unsupported"
        ;;
        x86_64)
        fail "-> $CURRENT_ARCH is currently unsupported"
        ;;
    esac

    # sed -i '' -e 's~#define HAVE_STRDUP~//#define HAVE_STRDUP~g' configure
    echo "-> Configured XZ for $CURRENT_ARCH"

    echo "-> Compiling XZ for $CURRENT_ARCH..."
    make -j "$WORKER" >> "$LOG_FILE" 2>&1 || fail "-> Error Compiling XZ for $CURRENT_ARCH"
    echo "-> Compiled XZ for $CURRENT_ARCH"

    echo "-> Installing XZ for $CURRENT_ARCH to $BUILD_DIR_XZ/install/xz/$CURRENT_ARCH..."
    make install DESTDIR="$BUILD_DIR_XZ/install/xz/$CURRENT_ARCH" >> "$LOG_FILE" 2>&1 || fail "-> Error Installing XZ for $CURRENT_ARCH"
    cp "$BUILD_DIR_XZ/install/xz/$CURRENT_ARCH/usr/local/lib/liblzma.a" "$OUTPUT_DIR"
    echo "-> Installed XZ for $CURRENT_ARCH"

    echo "Successfully built XZ for $CURRENT_ARCH"
done

echo -e "${COLOR_GREEN}xz built successfully for all ARCH targets.${COLOR_END}"

# iconv
cd "$ROOT_DIR" || exit 1

LOG_FILE="$BUILD_DIR_ICONV/build.log"

if [ -d "$BUILD_DIR_ICONV/tar" ]; then
  rm -rf "$BUILD_DIR_ICONV/tar"
fi
if [ -d "$BUILD_DIR_ICONV/src" ]; then
  rm -rf "$BUILD_DIR_ICONV/src"
fi
if [ -d "$BUILD_DIR_ICONV/install" ]; then
  rm -rf "$BUILD_DIR_ICONV/install"
fi

if [ -f "$LOG_FILE" ]; then
    rm "$LOG_FILE"
    touch "$LOG_FILE"
fi

mkdir -p "$BUILD_DIR_ICONV/tar"
mkdir -p "$BUILD_DIR_ICONV/src"
mkdir -p "$BUILD_DIR_ICONV/install"

cd "$ROOT_DIR"
echo "Downloading ICONV..."
curl -Lo "$BUILD_DIR_ICONV/tar/iconv-$ICONV_VERSION.tar.gz" "https://ftp.gnu.org/pub/gnu/libiconv/libiconv-$ICONV_VERSION.tar.gz" >> "$LOG_FILE" 2>&1 || fail "Error Downloading iconv"
echo "Uncompressing ICONV..."
tar xzf "$BUILD_DIR_ICONV/tar/iconv-$ICONV_VERSION.tar.gz" -C "$BUILD_DIR_ICONV/src" || fail "Error Uncompressing ICONV"
cd "$BUILD_DIR_ICONV/src/libiconv-$ICONV_VERSION"

for CURRENT_ARCH in "${TARGET_ARCHS[@]}"; do
    echo "Building ICONV for $CURRENT_ARCH build..."

    make clean 1>& /dev/null || true

    echo "-> Configuring ICONV for $CURRENT_ARCH build..."
    case $CURRENT_ARCH in
        armv7)
        fail "-> $CURRENT_ARCH is currently unsupported"
        ;;
        arm64)
            export HOST="aarch64-linux-android"

            export CC="aarch64-linux-android22-clang"
            export CXX="aarch64-linux-android22-clang++"
            export AR="llvm-ar"
            export AS="aarch64-linux-android-as"
            export LD="ld"
            export RANLIB="llvm-ranlib"
            export NM="llvm-nm"
            export STRIP="llvm-strip"

            export CFLAGS="--sysroot=$ANDROID_TOOLCHAIN/sysroot -fPIC -DANDROID -D__ANDROID_API__=22 -O3"
            export CPPFLAGS="$CFLAGS"
            export LDFLAGS="-static-libstdc++"

            ./configure --host=$HOST --enable-static --enable-shared=no >> "$LOG_FILE" 2>&1 || fail "-> Error Configuring ICONV for $CURRENT_ARCH"
        ;;
        x86)
        fail "-> $CURRENT_ARCH is currently unsupported"
        ;;
        x86_64)
        fail "-> $CURRENT_ARCH is currently unsupported"
        ;;
    esac

    # sed -i '' -e 's~#define HAVE_STRDUP~//#define HAVE_STRDUP~g' configure
    echo "-> Configured ICONV for $CURRENT_ARCH"

    echo "-> Compiling ICONV for $CURRENT_ARCH..."
    make -j "$WORKER" >> "$LOG_FILE" 2>&1 || fail "-> Error Compiling ICONV for $CURRENT_ARCH"
    echo "-> Compiled ICONV for $CURRENT_ARCH"

    echo "-> Installing ICONV for $CURRENT_ARCH to $BUILD_DIR_ICONV/install/iconv/$CURRENT_ARCH..."
    make install DESTDIR="$BUILD_DIR_ICONV/install/iconv/$CURRENT_ARCH" >> "$LOG_FILE" 2>&1 || fail "-> Error Installing ICONV for $CURRENT_ARCH"
    cp "$BUILD_DIR_ICONV/install/iconv/$CURRENT_ARCH/usr/local/lib/libcharset.a" "$OUTPUT_DIR"
    cp "$BUILD_DIR_ICONV/install/iconv/$CURRENT_ARCH/usr/local/lib/libiconv.a" "$OUTPUT_DIR"
    echo "-> Installed ICONV for $CURRENT_ARCH"

    echo "Successfully built ICONV for $CURRENT_ARCH"
done

echo -e "${COLOR_GREEN}iconv built successfully for all ARCH targets.${COLOR_END}"

# xml2
cd "$ROOT_DIR" || exit 1

LOG_FILE="$BUILD_DIR_XML2/build.log"

if [ -d "$BUILD_DIR_XML2/tar" ]; then
  rm -rf "$BUILD_DIR_XML2/tar"
fi
if [ -d "$BUILD_DIR_XML2/src" ]; then
  rm -rf "$BUILD_DIR_XML2/src"
fi
if [ -d "$BUILD_DIR_XML2/install" ]; then
  rm -rf "$BUILD_DIR_XML2/install"
fi

if [ -f "$LOG_FILE" ]; then
    rm "$LOG_FILE"
    touch "$LOG_FILE"
fi

mkdir -p "$BUILD_DIR_XML2/tar"
mkdir -p "$BUILD_DIR_XML2/src"
mkdir -p "$BUILD_DIR_XML2/install"

cd "$ROOT_DIR"
echo "Downloading XML2..."
curl -Lo "$BUILD_DIR_XML2/tar/xml2-$XML2_VERSION.tar.xz" "https://download.gnome.org/sources/libxml2/2.13/libxml2-$XML2_VERSION.tar.xz" >> "$LOG_FILE" 2>&1 || fail "Error Downloading xml2"
echo "Uncompressing XML2..."
tar xf "$BUILD_DIR_XML2/tar/xml2-$XML2_VERSION.tar.xz" -C "$BUILD_DIR_XML2/src" || fail "Error Uncompressing XML2"
cd "$BUILD_DIR_XML2/src/libxml2-$XML2_VERSION"

for CURRENT_ARCH in "${TARGET_ARCHS[@]}"; do
    echo "Building XML2 for $CURRENT_ARCH build..."

    make clean 1>& /dev/null || true

    echo "-> Configuring XML2 for $CURRENT_ARCH build..."
    case $CURRENT_ARCH in
        armv7)
            fail "-> $CURRENT_ARCH is currently unsupported"
        ;;
        arm64)
            export HOST="aarch64-linux-android"

            export CC="aarch64-linux-android22-clang"
            export CXX="aarch64-linux-android22-clang++"
            export AR="llvm-ar"
            export AS="aarch64-linux-android-as"
            export LD="ld"
            export RANLIB="llvm-ranlib"
            export NM="llvm-nm"
            export STRIP="llvm-strip"

            export CFLAGS="--sysroot=$ANDROID_TOOLCHAIN/sysroot -fPIC -DANDROID -D__ANDROID_API__=22 -O3"
            export CPPFLAGS="-I$BUILD_DIR_ICONV/install/iconv/arm64/usr/local/include $CFLAGS"
            export LDFLAGS="-L$BUILD_DIR_XZ/install/xz/arm64/usr/local/lib/liblzma.a -static -L$BUILD_DIR_ICONV/install/iconv/arm64/usr/local/lib/libiconv.a -static"

            ./configure --host=$HOST --enable-static --disable-shared --without-python --with-iconv="$BUILD_DIR_ICONV/install/iconv/arm64/usr/local/lib/libiconv.a" --with-lzma="$BUILD_DIR_XZ/install/xz/$CURRENT_ARCH/usr/local/lib/liblzma.a" >> "$LOG_FILE" 2>&1 || fail "-> Error Configuring XML2 for $CURRENT_ARCH"
        ;;
        x86)
            fail "-> $CURRENT_ARCH is currently unsupported"
        ;;
        x86_64)
            fail "-> $CURRENT_ARCH is currently unsupported"
        ;;
    esac

    # sed -i '' -e 's~#define HAVE_STRDUP~//#define HAVE_STRDUP~g' configure
    echo "-> Configured XML2 for $CURRENT_ARCH"

    echo "-> Compiling XML2 for $CURRENT_ARCH..."
    make -j "$WORKER" >> "$LOG_FILE" 2>&1 || fail "-> Error Compiling XML2 for $CURRENT_ARCH"
    echo "-> Compiled XML2 for $CURRENT_ARCH"

    echo "-> Installing XML2 for $CURRENT_ARCH to $BUILD_DIR_XML2/install/xml2/$CURRENT_ARCH..."
    make install DESTDIR="$BUILD_DIR_XML2/install/xml2/$CURRENT_ARCH" >> "$LOG_FILE" 2>&1 || fail "-> Error Installing XML2 for $CURRENT_ARCH"
    cp "$BUILD_DIR_XML2/install/xml2/$CURRENT_ARCH/usr/local/lib/libxml2.a" "$OUTPUT_DIR"
    echo "-> Installed XML2 for $CURRENT_ARCH"

    echo "Successfully built XML2 for $CURRENT_ARCH"
done

echo -e "${COLOR_GREEN}xml2 built successfully for all ARCH targets.${COLOR_END}"

# qalculate
cd "$ROOT_DIR" || exit 1

LOG_FILE="$BUILD_DIR_QALCULATE/build.log"

if [ -d "$BUILD_DIR_QALCULATE/tar" ]; then
  rm -rf "$BUILD_DIR_QALCULATE/tar"
fi
if [ -d "$BUILD_DIR_QALCULATE/src" ]; then
  rm -rf "$BUILD_DIR_QALCULATE/src"
fi
if [ -d "$BUILD_DIR_QALCULATE/install" ]; then
  rm -rf "$BUILD_DIR_QALCULATE/install"
fi

if [ -f "$LOG_FILE" ]; then
    rm "$LOG_FILE"
    touch "$LOG_FILE"
fi

mkdir -p "$BUILD_DIR_QALCULATE/tar"
mkdir -p "$BUILD_DIR_QALCULATE/src"
mkdir -p "$BUILD_DIR_QALCULATE/install"

cd "$ROOT_DIR"
echo "Downloading QALCULATE..."
curl -Lo "$BUILD_DIR_QALCULATE/tar/qalculate-$QALCULATE_VERSION.tar.gz" "https://github.com/Qalculate/libqalculate/releases/download/v$QALCULATE_VERSION/libqalculate-$QALCULATE_VERSION.tar.gz" >> "$LOG_FILE" 2>&1 || fail "Error Downloading qalculate"
echo "Uncompressing QALCULATE..."
tar xzf "$BUILD_DIR_QALCULATE/tar/qalculate-$QALCULATE_VERSION.tar.gz" -C "$BUILD_DIR_QALCULATE/src" || fail "Error Uncompressing QALCULATE"
cd "$BUILD_DIR_QALCULATE/src/libqalculate-$QALCULATE_VERSION"

for CURRENT_ARCH in "${TARGET_ARCHS[@]}"; do
    echo "Building QALCULATE for $CURRENT_ARCH build..."

    make clean 1>& /dev/null || true

    echo "-> Configuring QALCULATE for $CURRENT_ARCH build..."
    patch -u $BUILD_DIR_QALCULATE/src/libqalculate-$QALCULATE_VERSION/libqalculate/util.cc -i $ROOT_DIR/pthread.patch >> "$LOG_FILE" 2>&1 || fail "-> Error Patching QALCULATE for $CURRENT_ARCH (pthread)"
    patch -u $BUILD_DIR_QALCULATE/src/libqalculate-$QALCULATE_VERSION/libqalculate/util.cc -i $ROOT_DIR/data-dir.patch >> "$LOG_FILE" 2>&1 || fail "-> Error Patching QALCULATE for $CURRENT_ARCH (data-dir)"
    patch -u $BUILD_DIR_QALCULATE/src/libqalculate-$QALCULATE_VERSION/libqalculate/Calculator-definitions.cc -i $ROOT_DIR/calc-def.patch >> "$LOG_FILE" 2>&1 || fail "-> Error Patching QALCULATE for $CURRENT_ARCH (calc-def)"
    case $CURRENT_ARCH in
        armv7)
            fail "-> $CURRENT_ARCH is currently unsupported"
        ;;
        arm64)
            export PKG_CONFIG_PATH="$BUILD_DIR_XML2/install/xml2/arm64/usr/local/lib/pkgconfig"
            export HOST="aarch64-linux-android"

            export CC="aarch64-linux-android22-clang"
            export CXX="aarch64-linux-android22-clang++"
            export AR="llvm-ar"
            export AS="aarch64-linux-android-as"
            export LD="ld"
            export RANLIB="llvm-ranlib"
            export NM="llvm-nm"
            export STRIP="llvm-strip"

            export CFLAGS="--sysroot=$ANDROID_TOOLCHAIN/sysroot -fPIC -DANDROID -D__ANDROID_API__=22 -O3"

            export CPPFLAGS="-I$BUILD_DIR_GMP/install/gmp/arm64/usr/local/include -I$BUILD_DIR_MPFR/install/mpfr/arm64/usr/local/include -I$BUILD_DIR_ICONV/install/iconv/arm64/usr/local/include -I$BUILD_DIR_XML2/install/xml2/arm64/usr/local/include/libxml2 $CFLAGS"
            export LDFLAGS="-static -L$BUILD_DIR_GMP/install/gmp/arm64/usr/local/lib -L$BUILD_DIR_MPFR/install/mpfr/arm64/usr/local/lib -L$BUILD_DIR_ICONV/install/iconv/arm64/usr/local/lib -L$BUILD_DIR_XML2/install/xml2/arm64/usr/local/lib -Wl,--allow-shlib-undefined"
            ./autogen.sh --host=$HOST --enable-static --disable-shared --without-icu --without-libcurl --without-libintl-prefix --enable-compiled-definitions >> "$LOG_FILE" 2>&1 || fail "-> Error Configuring QALCULATE for $CURRENT_ARCH"
        ;;
        x86)
            fail "-> $CURRENT_ARCH is currently unsupported"
        ;;
        x86_64)
            fail "-> $CURRENT_ARCH is currently unsupported"
        ;;
    esac

    # sed -i '' -e 's~#define HAVE_STRDUP~//#define HAVE_STRDUP~g' configure
    echo "-> Configured QALCULATE for $CURRENT_ARCH"

    echo "-> Compiling QALCULATE for $CURRENT_ARCH..."
    make -j "$WORKER" >> "$LOG_FILE" 2>&1 || fail "-> Error Compiling QALCULATE for $CURRENT_ARCH"
    echo "-> Compiled QALCULATE for $CURRENT_ARCH"

    echo "-> Installing QALCULATE for $CURRENT_ARCH to $BUILD_DIR_QALCULATE/install/qalculate/$CURRENT_ARCH..."
    make install DESTDIR="$BUILD_DIR_QALCULATE/install/qalculate/$CURRENT_ARCH" >> "$LOG_FILE" 2>&1 || fail "-> Error Installing QALCULATE for $CURRENT_ARCH"
    cp "$BUILD_DIR_QALCULATE/install/qalculate/$CURRENT_ARCH/usr/local/lib/libqalculate.a" "$OUTPUT_DIR"
    echo "-> Installed QALCULATE for $CURRENT_ARCH"

    echo "Successfully built QALCULATE for $CURRENT_ARCH"
done

echo -e "${COLOR_GREEN}qalculate built successfully for all ARCH targets.${COLOR_END}"
exit 0

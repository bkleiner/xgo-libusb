#! /bin/bash

PLATFORM="$1"

if [ "$PLATFORM" == "" ]; then
  echo "Missing platform"
  exit 1
fi
shift

case "$PLATFORM" in
    "linux")
        export CC=gcc CXX=g++
        ;;
    "windows")
        export CC=x86_64-w64-mingw32-gcc-posix CXX=x86_64-w64-mingw32-g++-posix PKG_CONFIG_PATH=/usr/x86_64-w64-mingw32/lib/pkgconfig
        ;;
    "darwin")
        # hack for libusb
        export CGO_LDFLAGS="-lobjc -Wl,-framework,IOKit -Wl,-framework,CoreFoundation"
        export CC=o64-clang CXX=o64-clang++ PKG_CONFIG_PATH=/usr/x86_64-apple-darwin/lib/pkgconfig
        ;;
esac

exec $@
#!/bin/bash

set -euo pipefail
trap 'echo "Error occurred. Exiting..." >&2; exit 1' ERR

echo "=== LGPIO Installation Script (Arch Linux) ==="

if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run as root (use sudo)"
  exit 1
fi

# Check if liblgpio.so.1 is already available
if ldconfig -p | grep -q 'liblgpio.so.1'; then
    echo "liblgpio.so.1 already found in ldconfig cache, skipping compilation."
    exit 0
fi

# Also check /usr/local/lib directly in case ldconfig cache is stale
if [ -f /usr/local/lib/liblgpio.so.1 ]; then
    echo "liblgpio.so.1 found in /usr/local/lib, updating ldconfig..."
    echo "/usr/local/lib" > /etc/ld.so.conf.d/lgpio.conf
    ldconfig
    echo "ldconfig updated."
    exit 0
fi

# Install build dependencies via pacman
echo "- Installing build dependencies..."
pacman -S --noconfirm --needed swig python python-setuptools unzip wget make gcc

# Download and extract source
echo "- Downloading LGPIO source..."
rm -rf lg lg.zip*
wget -q http://abyz.me.uk/lg/lg.zip
unzip -q lg.zip
cd lg

# Patch for modern GCC (GCC 14+)
echo "- Patching source for GNU89 compatibility..."
sed -i 's/typedef void (\*callbk_t) ();/typedef void (*callbk_t) (...);/' lgpio.h
sed -i 's/^gcc/gcc -std=gnu89 -fpermissive -Wno-everything/' Makefile
sed -i 's/CFLAGS +=/CFLAGS += -std=gnu89 -fpermissive -Wno-everything /' Makefile

# Compile and install C library
echo "- Compiling and installing C library..."
make clean || true
export CFLAGS="-std=gnu89 -fpermissive -Wno-everything"
make
make install

# Ensure /usr/local/lib is in ldconfig search path (Arch doesn't include it by default)
echo "- Registering /usr/local/lib in ldconfig..."
echo "/usr/local/lib" > /etc/ld.so.conf.d/lgpio.conf
ldconfig

# Verify the library is now found
if ! ldconfig -p | grep -q 'liblgpio.so.1'; then
    echo "Warning: liblgpio.so.1 still not found after ldconfig. Trying symlink fallback..."
    if [ -f /usr/local/lib/liblgpio.so ]; then
        ln -sf /usr/local/lib/liblgpio.so /usr/local/lib/liblgpio.so.1
        ldconfig
    fi
fi

# Install Python bindings
echo "- Installing Python bindings..."
if [ -d "PY_LGPIO" ]; then
    cd PY_LGPIO
    export CFLAGS="-std=gnu89 -fpermissive -Wno-everything"
    python3 setup.py install
    cd ..
fi

cd ..
rm -rf lg lg.zip

echo "=== LGPIO Installation Finished ==="
echo "Library registered at: $(ldconfig -p | grep liblgpio || echo 'not found - check /usr/local/lib')"

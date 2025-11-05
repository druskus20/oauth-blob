#!/bin/bash

# Binaryen installation script
# Downloads latest release and installs to ~/.local/

set -e

INSTALL_DIR="$HOME/.local"
TEMP_DIR="/tmp/binaryen_install"

# Create directories if they don't exist
mkdir -p "$INSTALL_DIR/bin"
mkdir -p "$INSTALL_DIR/lib"
mkdir -p "$INSTALL_DIR/include"

# Clean up temp directory
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"

echo "Fetching latest Binaryen release..."
LATEST_VERSION=$(gh api repos/WebAssembly/binaryen/releases/latest --jq '.tag_name')
DOWNLOAD_URL="https://github.com/WebAssembly/binaryen/releases/download/${LATEST_VERSION}/binaryen-${LATEST_VERSION}-x86_64-linux.tar.gz"

echo "Downloading Binaryen ${LATEST_VERSION}..."
curl -L "$DOWNLOAD_URL" -o "$TEMP_DIR/binaryen.tar.gz"

echo "Extracting..."
tar -xzf "$TEMP_DIR/binaryen.tar.gz" -C "$TEMP_DIR"

# Find the extracted directory
SOURCE_DIR=$(find "$TEMP_DIR" -name "binaryen-*" -type d | head -n 1)

# Copy binaries
echo "Installing binaries to $INSTALL_DIR/bin..."
cp "$SOURCE_DIR/bin/"* "$INSTALL_DIR/bin/"

# Copy library
echo "Installing library to $INSTALL_DIR/lib..."
cp "$SOURCE_DIR/lib/libbinaryen.a" "$INSTALL_DIR/lib/"

# Copy headers
echo "Installing headers to $INSTALL_DIR/include..."
cp "$SOURCE_DIR/include/"* "$INSTALL_DIR/include/"

# Clean up
rm -rf "$TEMP_DIR"

echo "Installation complete!"
echo "Make sure $INSTALL_DIR/bin is in your PATH"
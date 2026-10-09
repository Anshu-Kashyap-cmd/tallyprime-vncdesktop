#!/bin/bash
# Install Tally Prime inside the container
# Usage: docker exec tallyprime-vnc-desktop /opt/install-tally.sh

set -e

TALLY_URL="${TALLY_URL:-}"
TALLY_INSTALL_DIR="/opt/TallyPrime"

echo "=== Tally Prime Installer ==="

# Check if Tally is already installed
if [ -f "$TALLY_INSTALL_DIR/Tally.exe" ]; then
    echo "Tally Prime is already installed at $TALLY_INSTALL_DIR"
    exit 0
fi

# Create install directory
mkdir -p "$TALLY_INSTALL_DIR"

# Method 1: Download from URL if provided
if [ -n "$TALLY_URL" ]; then
    echo "Downloading Tally Prime from $TALLY_URL..."
    curl -L -o /tmp/tally.tar.gz "$TALLY_URL"
    tar -xzf /tmp/tally.tar.gz -C "$TALLY_INSTALL_DIR"
    rm /tmp/tally.tar.gz
fi

# Method 2: Check for mounted installer
if [ -f "/opt/tally-installer.tar.gz" ]; then
    echo "Using mounted installer..."
    tar -xzf /opt/tally-installer.tar.gz -C "$TALLY_INSTALL_DIR"
fi

# Method 3: Check for local installer
if [ -f "/opt/tally.exe" ]; then
    echo "Using local Tally.exe..."
    cp /opt/tally.exe "$TALLY_INSTALL_DIR/Tally.exe"
fi

# Verify installation
if [ -f "$TALLY_INSTALL_DIR/Tally.exe" ]; then
    echo "✓ Tally Prime installed successfully at $TALLY_INSTALL_DIR"
    echo "Run: wine $TALLY_INSTALL_DIR/Tally.exe"
else
    echo "⚠ Tally Prime not found. To install:"
    echo "  1. Mount installer: docker run -v /path/to/tally.tar.gz:/opt/tally-installer.tar.gz ..."
    echo "  2. Or set TALLY_URL env variable"
    echo "  3. Or copy files manually into $TALLY_INSTALL_DIR"
fi
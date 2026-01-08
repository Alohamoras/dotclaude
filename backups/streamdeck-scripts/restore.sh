#!/bin/bash
# Restore Stream Deck scripts
# Run this after a fresh OS install

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.local/bin/streamdeck"

echo "Restoring Stream Deck scripts..."

# Create target directory
mkdir -p "$TARGET_DIR"

# Copy scripts and icons
cp -r "$SCRIPT_DIR"/*.sh "$TARGET_DIR/"
cp -r "$SCRIPT_DIR/icons" "$TARGET_DIR/"

# Make scripts executable
chmod +x "$TARGET_DIR"/*.sh

echo "Scripts restored to $TARGET_DIR"
echo ""
echo "Don't forget to install dependencies:"
echo "  sudo apt install playerctl"
echo ""
echo "And set up udev rules for Stream Deck access."

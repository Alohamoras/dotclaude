#!/bin/bash
# Restore OpenDeck configuration
# Run this after installing OpenDeck on a fresh system

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENDECK_CONFIG="$HOME/.var/app/me.amankhanna.opendeck/config/opendeck"

echo "Restoring OpenDeck configuration..."

# Check if OpenDeck has been run at least once
if [ ! -d "$OPENDECK_CONFIG" ]; then
    echo "OpenDeck config directory doesn't exist."
    echo "Please install and run OpenDeck once first:"
    echo "  flatpak install flathub me.amankhanna.opendeck"
    echo "  flatpak run me.amankhanna.opendeck"
    echo "Then close it and run this script again."
    exit 1
fi

# Backup existing config (just in case)
if [ -d "$OPENDECK_CONFIG/profiles" ]; then
    echo "Backing up existing config to $OPENDECK_CONFIG.bak"
    cp -r "$OPENDECK_CONFIG" "$OPENDECK_CONFIG.bak"
fi

# Restore profiles, images, and settings
echo "Restoring profiles..."
cp -r "$SCRIPT_DIR/profiles/"* "$OPENDECK_CONFIG/profiles/"

echo "Restoring images..."
cp -r "$SCRIPT_DIR/images/"* "$OPENDECK_CONFIG/images/"

echo "Restoring settings..."
cp "$SCRIPT_DIR/settings.json" "$OPENDECK_CONFIG/settings.json"

echo ""
echo "Restore complete!"
echo "Note: If your Stream Deck has a different device ID, you may need to rename the profile folder."
echo "Current device ID in backup: sd-A00SA5292P1DTI"
echo ""
echo "Restart OpenDeck to apply changes."

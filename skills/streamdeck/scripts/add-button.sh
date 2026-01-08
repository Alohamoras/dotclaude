#!/bin/bash
# Stream Deck Button Helper Script
# Usage: add-button.sh <button_number> <script_name> <icon_path>

BUTTON_NUM="$1"
SCRIPT_NAME="$2"
ICON_PATH="$3"

SCRIPTS_DIR="/home/duane/.local/bin/streamdeck"
ICONS_DIR="/home/duane/.local/bin/streamdeck/icons"
IMAGES_DIR="/home/duane/.var/app/me.amankhanna.opendeck/config/opendeck/images/sd-A00SA5292P1DTI/Default"

if [ -z "$BUTTON_NUM" ] || [ -z "$SCRIPT_NAME" ]; then
    echo "Usage: $0 <button_number> <script_name> [icon_path]"
    echo "  button_number: 0-14"
    echo "  script_name: name of script (without .sh)"
    echo "  icon_path: optional path to icon file"
    exit 1
fi

# Validate button number
if [ "$BUTTON_NUM" -lt 0 ] || [ "$BUTTON_NUM" -gt 14 ]; then
    echo "Error: Button number must be 0-14"
    exit 1
fi

# Check if script exists
if [ ! -f "$SCRIPTS_DIR/${SCRIPT_NAME}.sh" ]; then
    echo "Error: Script not found: $SCRIPTS_DIR/${SCRIPT_NAME}.sh"
    exit 1
fi

# Create image directory
mkdir -p "$IMAGES_DIR/Keypad.${BUTTON_NUM}.0"

# Process icon if provided
if [ -n "$ICON_PATH" ] && [ -f "$ICON_PATH" ]; then
    EXT="${ICON_PATH##*.}"

    if [ "$EXT" = "svg" ]; then
        # Convert SVG to PNG
        rsvg-convert -w 288 -h 288 -b black "$ICON_PATH" -o "$IMAGES_DIR/Keypad.${BUTTON_NUM}.0/0.png"
        echo "Converted SVG icon to PNG"
    elif [ "$EXT" = "png" ]; then
        # Resize PNG using Python
        python3 << EOF
from PIL import Image
img = Image.open("$ICON_PATH")
bg = Image.new('RGBA', (288, 288), (0, 0, 0, 255))
img.thumbnail((250, 250), Image.LANCZOS)
if img.mode != 'RGBA':
    img = img.convert('RGBA')
x = (288 - img.width) // 2
y = (288 - img.height) // 2
bg.paste(img, (x, y), img)
bg.save("$IMAGES_DIR/Keypad.${BUTTON_NUM}.0/0.png")
EOF
        echo "Resized PNG icon"
    else
        echo "Warning: Unknown icon format, copying as-is"
        cp "$ICON_PATH" "$IMAGES_DIR/Keypad.${BUTTON_NUM}.0/0.png"
    fi
fi

echo "Button $BUTTON_NUM configured for script: ${SCRIPT_NAME}.sh"
echo ""
echo "NOTE: You need to update the profile JSON and restart OpenDeck"
echo "Profile: ~/.var/app/me.amankhanna.opendeck/config/opendeck/profiles/sd-A00SA5292P1DTI/Default.json"

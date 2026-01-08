#!/bin/bash
# Toggle microphone mute and update Stream Deck icon

ICONS_DIR="/home/duane/.local/bin/streamdeck/icons"
BUTTON_IMG="/home/duane/.var/app/me.amankhanna.opendeck/config/opendeck/images/sd-A00SA5292P1DTI/Default/Keypad.2.0/0.png"

# Toggle mute
pactl set-source-mute @DEFAULT_SOURCE@ toggle

# Check new state and update icon
if pactl get-source-mute @DEFAULT_SOURCE@ | grep -q "yes"; then
    # Muted - show red icon
    cp "$ICONS_DIR/mic-muted-288.png" "$BUTTON_IMG"
else
    # Unmuted - show green icon
    cp "$ICONS_DIR/mic-unmuted-288.png" "$BUTTON_IMG"
fi

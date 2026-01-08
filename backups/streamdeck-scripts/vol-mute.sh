#!/bin/bash
# Toggle volume mute and update Stream Deck icon

ICONS_DIR="/home/duane/.local/bin/streamdeck/icons"
BUTTON_IMG="/home/duane/.var/app/me.amankhanna.opendeck/config/opendeck/images/sd-A00SA5292P1DTI/Default/Keypad.9.0/0.png"

# Toggle mute
pactl set-sink-mute @DEFAULT_SINK@ toggle

# Check new state and update icon
if pactl get-sink-mute @DEFAULT_SINK@ | grep -q "yes"; then
    # Muted - show red icon
    cp "$ICONS_DIR/vol-muted-288.png" "$BUTTON_IMG"
else
    # Unmuted - show white icon
    cp "$ICONS_DIR/vol-unmuted-288.png" "$BUTTON_IMG"
fi

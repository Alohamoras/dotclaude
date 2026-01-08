#!/bin/bash
# Sync mute button icons with current system state
# Run this at startup or when icons get out of sync

ICONS_DIR="/home/duane/.local/bin/streamdeck/icons"
MIC_IMG="/home/duane/.var/app/me.amankhanna.opendeck/config/opendeck/images/sd-A00SA5292P1DTI/Default/Keypad.2.0/0.png"
VOL_IMG="/home/duane/.var/app/me.amankhanna.opendeck/config/opendeck/images/sd-A00SA5292P1DTI/Default/Keypad.4.0/0.png"

# Sync mic mute icon
if pactl get-source-mute @DEFAULT_SOURCE@ | grep -q "yes"; then
    cp "$ICONS_DIR/mic-muted-288.png" "$MIC_IMG"
else
    cp "$ICONS_DIR/mic-unmuted-288.png" "$MIC_IMG"
fi

# Sync vol mute icon
if pactl get-sink-mute @DEFAULT_SINK@ | grep -q "yes"; then
    cp "$ICONS_DIR/vol-muted-288.png" "$VOL_IMG"
else
    cp "$ICONS_DIR/vol-unmuted-288.png" "$VOL_IMG"
fi

echo "Mute icons synced with system state"

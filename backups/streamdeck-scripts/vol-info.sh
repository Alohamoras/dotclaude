#!/bin/bash
vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1)
notify-send -i audio-volume-high "Volume" "$vol"

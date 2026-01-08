#!/bin/bash
artist=$(playerctl -p spotify metadata artist 2>/dev/null)
title=$(playerctl -p spotify metadata title 2>/dev/null)
album=$(playerctl -p spotify metadata album 2>/dev/null)

if [ -n "$title" ]; then
    notify-send -i spotify "Now Playing" "$title\n$artist\n$album"
else
    notify-send -i spotify "Spotify" "Nothing playing"
fi

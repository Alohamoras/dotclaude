#!/bin/bash
# Uses gnome-screenshot for region selection, saves to Pictures
gnome-screenshot -a -f ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png

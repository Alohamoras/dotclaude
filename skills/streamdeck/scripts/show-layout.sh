#!/bin/bash
# Show current Stream Deck button layout

PROFILE="/home/duane/.var/app/me.amankhanna.opendeck/config/opendeck/profiles/sd-A00SA5292P1DTI/Default.json"
SCRIPTS_DIR="/home/duane/.local/bin/streamdeck"

echo "Stream Deck MK.2 Button Layout"
echo "=============================="
echo ""

# Parse the JSON and extract button info
python3 << 'EOF'
import json
import os

profile_path = os.path.expanduser("~/.var/app/me.amankhanna.opendeck/config/opendeck/profiles/sd-A00SA5292P1DTI/Default.json")

try:
    with open(profile_path) as f:
        data = json.load(f)
except FileNotFoundError:
    print("Profile not found!")
    exit(1)

buttons = []
for i, key in enumerate(data.get("keys", [])):
    if key is None:
        buttons.append(f"{i}: (empty)")
    else:
        cmd = key.get("settings", {}).get("down", "")
        if cmd:
            script = os.path.basename(cmd)
            buttons.append(f"{i}: {script}")
        else:
            buttons.append(f"{i}: (no command)")

# Print as grid
print("┌────────────────┬────────────────┬────────────────┬────────────────┬────────────────┐")
for row in range(3):
    cells = []
    for col in range(5):
        idx = row * 5 + col
        if idx < len(buttons):
            cell = buttons[idx][:14].center(14)
        else:
            cell = "".center(14)
        cells.append(cell)
    print(f"│{cells[0]}│{cells[1]}│{cells[2]}│{cells[3]}│{cells[4]}│")
    if row < 2:
        print("├────────────────┼────────────────┼────────────────┼────────────────┼────────────────┤")
print("└────────────────┴────────────────┴────────────────┴────────────────┴────────────────┘")

print("\nDetailed list:")
for b in buttons:
    print(f"  {b}")
EOF

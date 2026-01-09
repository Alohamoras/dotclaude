---
name: streamdeck
description: Manage Elgato Stream Deck buttons, scripts, and icons on Linux Mint with OpenDeck. Use for creating new buttons, editing button commands, changing icons, troubleshooting Stream Deck issues, adding scripts, or modifying the Stream Deck layout.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Stream Deck Management Skill

Manage the Elgato Stream Deck MK.2 (15 buttons) running OpenDeck on Linux Mint.

## System Configuration

### Paths
| Item | Path |
|------|------|
| Scripts | `/home/duane/.local/bin/streamdeck/` |
| Icons | `/home/duane/.local/bin/streamdeck/icons/` |
| OpenDeck Config | `~/.var/app/me.amankhanna.opendeck/config/opendeck/` |
| Profile JSON | `~/.var/app/me.amankhanna.opendeck/config/opendeck/profiles/sd-A00SA5292P1DTI/Default.json` |
| Button Images | `~/.var/app/me.amankhanna.opendeck/config/opendeck/images/sd-A00SA5292P1DTI/Default/` |
| Device ID | `sd-A00SA5292P1DTI` |

### Button Layout (3 rows x 5 columns)
```
┌─────────┬─────────┬─────────┬─────────┬─────────┐
│  0      │  1      │  2      │  3      │  4      │
├─────────┼─────────┼─────────┼─────────┼─────────┤
│  5      │  6      │  7      │  8      │  9      │
├─────────┼─────────┼─────────┼─────────┼─────────┤
│  10     │  11     │  12     │  13     │  14     │
└─────────┴─────────┴─────────┴─────────┴─────────┘
```

### Current Button Assignments
| Button | Script | Function |
|--------|--------|----------|
| 0 | vol-0.sh | Set volume to 0% |
| 1 | vol-100.sh | Set volume to 100% |
| 2 | vol-info.sh | Show current volume |
| 3 | screenshot.sh | Take screenshot |
| 4 | spotify-info.sh | Show Spotify track info |
| 5 | spotify-prev.sh | Spotify previous track |
| 6 | spotify-play.sh | Spotify play/pause |
| 7 | spotify-next.sh | Spotify next track |
| 8 | valheim.sh | Launch Valheim (BepInEx) |
| 9 | deeprock.sh | Launch Deep Rock Galactic |
| 10 | browser.sh | Open browser |
| 11 | terminal.sh | Open terminal |
| 12 | files.sh | Open file manager (Nemo) |
| 13 | lock.sh | Lock screen |
| 14 | sleep.sh | Suspend system |

## Instructions

### Creating a New Button Script

1. Create a shell script at `/home/duane/.local/bin/streamdeck/`:
```bash
#!/bin/bash
# Your command here
```

2. Make it executable:
```bash
chmod +x /home/duane/.local/bin/streamdeck/scriptname.sh
```

3. Test the script manually before adding to Stream Deck.

### Creating/Converting Icons

Icons must be **288x288 PNG** files with a black background for best visibility.

**For SVG icons:**
```bash
rsvg-convert -w 288 -h 288 -b black input.svg -o output.png
```

**For existing PNG icons (resize with black background):**
```python
from PIL import Image
img = Image.open("input.png")
bg = Image.new('RGBA', (288, 288), (0, 0, 0, 255))
img.thumbnail((250, 250), Image.LANCZOS)
if img.mode != 'RGBA':
    img = img.convert('RGBA')
x = (288 - img.width) // 2
y = (288 - img.height) // 2
bg.paste(img, (x, y), img)
bg.save("output.png")
```

**Icon sources:**
- Iconify API: `https://api.iconify.design/mdi/icon-name.svg?width=144&height=144&color=white`
- System icons: `/usr/share/icons/Mint-Y/apps/96@2x/`
- Places icons: `/usr/share/icons/Mint-Y/places/96@2x/`
- Action icons: `/usr/share/icons/Mint-Y/actions/96@2x/`

### Adding a Button to OpenDeck

1. **Close OpenDeck first** (configuration changes require restart):
```bash
pkill -f opendeck
```

2. **Create the image directory:**
```bash
mkdir -p ~/.var/app/me.amankhanna.opendeck/config/opendeck/images/sd-A00SA5292P1DTI/Default/Keypad.{BUTTON_NUMBER}.0
```

3. **Copy the icon:**
```bash
cp icon.png ~/.var/app/me.amankhanna.opendeck/config/opendeck/images/sd-A00SA5292P1DTI/Default/Keypad.{BUTTON_NUMBER}.0/0.png
```

4. **Edit the profile JSON** to add the button configuration (see JSON format below).

5. **Launch OpenDeck:**
```bash
flatpak run me.amankhanna.opendeck &
```

### Button JSON Format

Each button in the `keys` array uses this format:

```json
{
  "action": {
    "controllers": ["Keypad", "Encoder"],
    "disable_automatic_states": false,
    "icon": "plugins/com.amansprojects.starterpack.sdPlugin/icons/runCommand.png",
    "name": "Run Command",
    "plugin": "com.amansprojects.starterpack.sdPlugin",
    "property_inspector": "plugins/com.amansprojects.starterpack.sdPlugin/propertyInspector/runCommand.html",
    "states": [{"alignment": "middle", "colour": "#FFFFFF", "family": "Liberation Sans", "image": "plugins/com.amansprojects.starterpack.sdPlugin/icons/runCommand.png", "name": "", "show": true, "size": 16, "style": "Regular", "text": "", "underline": false}],
    "supported_in_multi_actions": true,
    "tooltip": "Run a command",
    "uuid": "com.amansprojects.starterpack.runcommand",
    "visible_in_action_list": true
  },
  "children": null,
  "context": "Keypad.{BUTTON_NUMBER}.0",
  "current_state": 0,
  "settings": {
    "down": "/home/duane/.local/bin/streamdeck/{SCRIPT_NAME}.sh",
    "up": "",
    "rotate": "",
    "file": "",
    "show": false
  },
  "states": [{"alignment": "middle", "colour": "#ffffff", "family": "Liberation Sans", "image": "0.png", "name": "", "show": true, "size": 16, "style": "Regular", "text": "", "underline": false}]
}
```

**Key settings:**
- `context`: Must be `"Keypad.{BUTTON_NUMBER}.0"` where BUTTON_NUMBER is 0-14
- `settings.down`: The command to run on button press (full path to script)
- `settings.show`: Set to `true` to show terminal output, `false` to hide
- `states[0].image`: Usually `"0.png"` (references the image in the button's directory)

Use `null` for empty buttons.

### Common Script Templates

**Launch application:**
```bash
#!/bin/bash
application-name
```

**Run Steam game:**
```bash
#!/bin/bash
steam steam://rungameid/GAME_ID
```

**Toggle with pactl:**
```bash
#!/bin/bash
pactl set-sink-mute @DEFAULT_SINK@ toggle
```

**Media control with playerctl:**
```bash
#!/bin/bash
playerctl -p spotify play-pause
```

**System command:**
```bash
#!/bin/bash
systemctl suspend
```

### Troubleshooting

**Stream Deck not detected:**
1. Check connection: `lsusb | grep Elgato`
2. Verify udev rules exist: `cat /etc/udev/rules.d/70-streamdeck.rules`
3. Reload rules: `sudo udevadm control --reload-rules && sudo udevadm trigger`
4. Unplug and replug device

**Button not working:**
1. Test script directly: `/home/duane/.local/bin/streamdeck/script.sh`
2. Check script is executable: `ls -la /home/duane/.local/bin/streamdeck/`
3. Check OpenDeck logs for errors

**Icons not showing:**
1. Verify icon is 288x288 PNG
2. Check icon is at correct path: `~/.var/app/me.amankhanna.opendeck/config/opendeck/images/sd-A00SA5292P1DTI/Default/Keypad.{N}.0/0.png`
3. Restart OpenDeck after adding icons

### Dependencies

Required packages:
- `playerctl` - For media player control (Spotify, etc.)
- `librsvg2-bin` - For SVG to PNG conversion (`rsvg-convert`)
- `python3-pil` - For image manipulation (usually pre-installed)

Install with:
```bash
sudo apt install playerctl librsvg2-bin
```

### Launching OpenDeck

```bash
flatpak run me.amankhanna.opendeck
```

OpenDeck is configured to autostart. Settings are at:
`~/.var/app/me.amankhanna.opendeck/config/opendeck/settings.json`

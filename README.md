# dotclaude

Personal Claude Code configuration, skills, and customizations.

## Structure

```
dotclaude/
├── skills/                    # Claude Code skills
│   └── streamdeck/            # Stream Deck management skill
├── backups/                   # Configuration backups
│   ├── opendeck/              # OpenDeck profiles & images
│   ├── streamdeck-scripts/    # Button scripts & icons
│   └── setup-streamdeck.sh    # udev rules setup
├── commands/                  # Slash commands (future)
└── hooks/                     # Custom hooks (future)
```

## Installation

Run the install script to symlink everything to `~/.claude/`:

```bash
./install.sh
```

Or manually symlink:

```bash
ln -sf ~/repos/dotclaude/skills/* ~/.claude/skills/
```

## Skills

### streamdeck

Manage Elgato Stream Deck buttons, scripts, and icons on Linux Mint with OpenDeck.

**Triggers:** Creating buttons, editing commands, changing icons, troubleshooting Stream Deck.

**Paths managed:**
- Scripts: `~/.local/bin/streamdeck/`
- Icons: `~/.local/bin/streamdeck/icons/`
- OpenDeck config: `~/.var/app/me.amankhanna.opendeck/config/opendeck/`

## Restoring Stream Deck (after OS reinstall)

1. Install OpenDeck:
   ```bash
   flatpak install flathub me.amankhanna.opendeck
   ```

2. Run OpenDeck once, then close it.

3. Set up udev rules:
   ```bash
   sudo ./backups/setup-streamdeck.sh
   ```

4. Restore scripts:
   ```bash
   ./backups/streamdeck-scripts/restore.sh
   ```

5. Restore OpenDeck config:
   ```bash
   ./backups/opendeck/restore.sh
   ```

6. Install dependencies:
   ```bash
   sudo apt install playerctl librsvg2-bin
   ```

7. Unplug/replug Stream Deck and launch OpenDeck.

## Requirements

- [Claude Code](https://claude.ai/code) CLI tool
- Linux Mint (skills are configured for this environment)

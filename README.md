# dotclaude

Personal Claude Code configuration, skills, and customizations.

## Structure

```
dotclaude/
├── skills/                    # Claude Code skills
│   ├── streamdeck/            # Stream Deck management skill
│   └── oxide-index/           # Oxide Computer GitHub org explorer
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

### oxide-index

Query the Oxide Computer GitHub org — find where things are implemented, how repos
relate, and browse open PRs/issues across all oxidecomputer repos.

**Triggers:** "Where is X implemented?", "How does propolis depend on crucible?",
"Show open PRs in omicron", `/oxide-index search 'partition table'`

**Requires:** A GitHub PAT with read-only org access stored at
`~/.config/oxide/gh-readonly-token`. Required permissions (fine-grained,
oxidecomputer org): Metadata:Read, Contents:Read, Pull requests:Read, Issues:Read.

**First-time setup:**
```bash
mkdir -p ~/.config/oxide
echo 'github_pat_YOUR_TOKEN_HERE' > ~/.config/oxide/gh-readonly-token
chmod 600 ~/.config/oxide/gh-readonly-token
bash ~/.claude/skills/oxide-index/scripts/refresh.sh
```

## Requirements

- [Claude Code](https://claude.ai/code) CLI tool
- Linux Mint (skills are configured for this environment)

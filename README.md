# dotclaude

Personal Claude Code configuration, skills, and customizations.

## Structure

```
dotclaude/
├── skills/           # Claude Code skills
│   └── streamdeck/   # Stream Deck management skill
├── commands/         # Slash commands (future)
└── hooks/            # Custom hooks (future)
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

## Requirements

- [Claude Code](https://claude.ai/code) CLI tool
- Linux Mint (skills are configured for this environment)

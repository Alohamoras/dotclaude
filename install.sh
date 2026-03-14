#!/bin/bash
# Install dotclaude configuration

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Installing dotclaude from $SCRIPT_DIR"

# Create .claude directories if they don't exist
mkdir -p "$CLAUDE_DIR/skills"
mkdir -p "$CLAUDE_DIR/commands"

# Symlink skills
for skill in "$SCRIPT_DIR/skills/"*/; do
    skill_name=$(basename "$skill")
    target="$CLAUDE_DIR/skills/$skill_name"

    if [ -L "$target" ]; then
        echo "Updating symlink: $skill_name"
        rm "$target"
    elif [ -d "$target" ]; then
        echo "Warning: $target exists and is not a symlink. Skipping."
        continue
    fi

    ln -sf "$skill" "$target"
    echo "Linked: $skill_name"
done

# Symlink commands (if any)
if [ -d "$SCRIPT_DIR/commands" ]; then
    for cmd in "$SCRIPT_DIR/commands/"*.md; do
        [ -f "$cmd" ] || continue
        cmd_name=$(basename "$cmd")
        target="$CLAUDE_DIR/commands/$cmd_name"

        if [ -L "$target" ]; then
            rm "$target"
        elif [ -f "$target" ]; then
            echo "Warning: $target exists and is not a symlink. Skipping."
            continue
        fi

        ln -sf "$cmd" "$target"
        echo "Linked command: $cmd_name"
    done
fi

# Install hooks into ~/.claude/settings.json
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

install_hook() {
    local hook_name="$1"
    local hook_path="$SCRIPT_DIR/hooks/$hook_name"
    local matcher="$2"

    if [ ! -f "$hook_path" ]; then
        echo "Warning: Hook not found: $hook_path"
        return
    fi

    # Create settings.json if it doesn't exist
    if [ ! -f "$SETTINGS_FILE" ]; then
        echo '{}' > "$SETTINGS_FILE"
    fi

    # Check if the hook command is already registered
    if jq -e --arg cmd "$hook_path" \
        '.hooks.PreToolUse[]?.hooks[]? | select(.command == $cmd)' \
        "$SETTINGS_FILE" > /dev/null 2>&1; then
        echo "Hook already installed: $hook_name"
        return
    fi

    # Add the hook entry
    jq --arg cmd "$hook_path" --arg matcher "$matcher" \
        '.hooks.PreToolUse = (.hooks.PreToolUse // []) + [{
            "matcher": $matcher,
            "hooks": [{"type": "command", "command": $cmd}]
        }]' "$SETTINGS_FILE" > "${SETTINGS_FILE}.tmp" \
        && mv "${SETTINGS_FILE}.tmp" "$SETTINGS_FILE"

    echo "Installed hook: $hook_name (matcher: $matcher)"
}

install_hook "oxide-readonly-guard.sh" "Bash"

echo ""
echo "Installation complete!"
echo "Skills and hooks are now available in Claude Code."

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

echo ""
echo "Installation complete!"
echo "Skills are now available in Claude Code."

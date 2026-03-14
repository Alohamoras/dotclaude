#!/usr/bin/env bash
# PreToolUse hook: blocks write operations against oxidecomputer repos.
# Prevents accidental PR creation, issue mutation, pushes, etc.
# Used with the oxide-index skill to enforce read-only access.

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Only inspect Bash commands
[[ -z "$COMMAND" ]] && exit 0

# Strip quoted strings so we only match actual commands, not string literals
# inside commit messages, echo statements, etc.
STRIPPED=$(echo "$COMMAND" | sed -E "s/'[^']*'//g; s/\"[^\"]*\"//g")

# Patterns that constitute write operations via gh CLI
BLOCKED_GH_PATTERNS=(
  'gh pr create'
  'gh pr merge'
  'gh pr close'
  'gh pr edit'
  'gh pr review'
  'gh pr comment'
  'gh pr ready'
  'gh issue create'
  'gh issue edit'
  'gh issue close'
  'gh issue delete'
  'gh issue comment'
  'gh issue reopen'
  'gh repo create'
  'gh repo delete'
  'gh repo edit'
  'gh repo fork'
  'gh release create'
  'gh release delete'
  'gh release edit'
  'gh release upload'
  'gh secret set'
  'gh secret delete'
  'gh variable set'
  'gh variable delete'
  'gh api -X PUT'
  'gh api -X POST'
  'gh api -X PATCH'
  'gh api -X DELETE'
  'gh api --method PUT'
  'gh api --method POST'
  'gh api --method PATCH'
  'gh api --method DELETE'
)

# Patterns that constitute write operations via git
BLOCKED_GIT_PATTERNS=(
  'git push'
  'git force-push'
)

# Check if the command (not quoted args) uses the oxide token
uses_oxide_token=false
if echo "$STRIPPED" | grep -q 'oxide/gh-readonly-token\|GH_TOKEN.*oxide'; then
  uses_oxide_token=true
fi

# Check if command (not quoted args) targets oxidecomputer
targets_oxide=false
if echo "$STRIPPED" | grep -qi 'oxidecomputer'; then
  targets_oxide=true
fi

# Only enforce when the command involves oxide credentials or targets oxidecomputer
if [[ "$uses_oxide_token" == "true" ]] || [[ "$targets_oxide" == "true" ]]; then
  for pattern in "${BLOCKED_GH_PATTERNS[@]}" "${BLOCKED_GIT_PATTERNS[@]}"; do
    if echo "$STRIPPED" | grep -qi "$pattern"; then
      jq -n \
        --arg reason "Blocked: '$pattern' is a write operation. The oxide-index skill is read-only. Never create, modify, or delete resources in the oxidecomputer org." \
        '{
          hookSpecificOutput: {
            hookEventName: "PreToolUse",
            permissionDecision: "deny",
            permissionDecisionReason: $reason
          }
        }'
      exit 0
    fi
  done
fi

# Allow everything else
exit 0

---
name: oxide-index
description: Load the Oxide Computer GitHub org repo index and answer questions about
  where things are implemented across oxidecomputer repos. Trigger when user asks
  where something is implemented, which repo owns a feature, how repos relate/depend
  on each other, or wants PR/issue history for Oxide repos.
argument-hint: "[refresh|search <query>|show <repo>]"
user-invocable: true
tools: Bash, Read, Write
---

# Oxide GitHub Org Index Skill

## Auth — Always do this first

Before running ANY `gh` command, set the token:

```bash
export GH_TOKEN="$(cat ~/.config/oxide/gh-readonly-token)"
```

## On Invocation

1. Read the index file:
   `~/.claude/skills/oxide-index/oxide-repos.md`

2. Check the `Generated:` timestamp at the top. If it is more than 7 days old (today
   is available via the `date` command), offer to refresh:
   > "The index is X days old. Run `/oxide-index refresh` to update it."

3. Proceed to answer the user's question using the index and the operations below.

## Arguments

### `refresh`
Regenerate the index from the GitHub API:
```bash
export GH_TOKEN="$(cat ~/.config/oxide/gh-readonly-token)"
bash ~/.claude/skills/oxide-index/scripts/refresh.sh
```
Then re-read the updated file and confirm row count.

### `search <query>`
Search for code across the org:
```bash
export GH_TOKEN="$(cat ~/.config/oxide/gh-readonly-token)"
gh search code "<query>" --owner=oxidecomputer --limit 20 \
  --json repository,path,url \
  --jq '.[] | "\(.repository.name)  \(.path)  \(.url)"'
```

### `show <repo>`
Show detailed info for a single repo:
```bash
export GH_TOKEN="$(cat ~/.config/oxide/gh-readonly-token)"
gh repo view oxidecomputer/<repo> \
  --json name,description,primaryLanguage,updatedAt,isPrivate,isArchived,url,diskUsage
```

## Query Playbook

### "Where is X implemented?"
1. Scan the index descriptions for obvious matches.
2. If unclear, run a `gh search code` query (see above).
3. For deeper dependency checks, fetch `Cargo.toml`:
   ```bash
   export GH_TOKEN="$(cat ~/.config/oxide/gh-readonly-token)"
   gh api repos/oxidecomputer/<repo>/contents/Cargo.toml \
     --jq '.content' | base64 -d
   ```

### "How do repos relate / depend on each other?"
Use the **Key Architecture Relationships** section at the top of `oxide-repos.md`.
For precise inter-repo dependencies, fetch `Cargo.toml` or `package.json` as above.

### "What's open in this repo?" / PR or issue history
```bash
export GH_TOKEN="$(cat ~/.config/oxide/gh-readonly-token)"

# Open PRs
gh pr list --repo oxidecomputer/<repo> --limit 20 \
  --json number,title,author,createdAt,url

# Open issues
gh issue list --repo oxidecomputer/<repo> --limit 20 \
  --json number,title,author,createdAt,state
```

## Read-Only Policy

This workspace is **read-only**. Never run:
- `gh pr create/merge/close/edit/review/comment`
- `gh issue create/edit/close/delete/comment`
- `gh repo create/delete/edit/fork`
- `gh release create/delete/edit/upload`
- `gh secret/variable set/delete`
- `git push` or `git force-push`

A PreToolUse hook will block these automatically, but do not attempt them.

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

claude-kit is a configuration toolkit that extends Claude Code CLI with custom commands, security hooks, and shell aliases. It uses non-destructive installation to preserve existing user configurations.

## Commands

```bash
# Install
./install.sh
# or
make install

# Uninstall
./uninstall.sh

# Update (git pull + reinstall)
./update.sh

# Run syntax checks on all shell scripts
make test

# Remove backup files
make clean
```

## Architecture

**Installation flow**: `install.sh` creates symlinks from `~/.claude/commands/` to `commands/*.md`, symlinks `config/CLAUDE.md` to `~/.claude/CLAUDE.md`, and deep-merges `config/settings.template.json` into `~/.claude/settings.json` using jq.

**Hook chain**: When Claude executes a Bash command, `hooks/pre-tool-use.sh` runs `hooks/global/security-check.sh` to block dangerous patterns (destructive deletions, force push, remote script execution, etc.).

**Key directories**:
- `commands/` - Markdown files defining slash commands (`/handoff`, `/ho`, `/context`, `/worktree`, `/audit`)
- `hooks/` - Shell scripts for pre/post tool-use hooks
- `config/` - Global CLAUDE.md and settings template with `$INSTALL_DIR` placeholder
- `shell/` - Shell aliases sourced from rc file
- `statusline/` - Custom status line script that displays model, context %, tokens, cost, git branch, session name

## Dependencies

- `git`, `jq` (for settings merge), `claude` CLI

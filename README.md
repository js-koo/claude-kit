# build-my-claude

Custom configuration and commands for Claude Code CLI.

## Features

- **Custom Commands**: `/handoff`, `/ho`, `/context`, `/worktree`, `/audit`
- **Security Hooks**: Block dangerous bash commands automatically
- **Shell Aliases**: Quick shortcuts for common Claude operations
- **Settings Merge**: Non-destructive installation preserves existing settings

## Installation

```bash
git clone https://github.com/js-koo/build-my-claude.git ~/work/build-my-claude && ~/work/build-my-claude/install.sh && source ~/.zshrc
```

Or step by step:

```bash
git clone https://github.com/js-koo/build-my-claude.git ~/work/build-my-claude
cd ~/work/build-my-claude
./install.sh
source ~/.zshrc
```

Or using make:

```bash
make install
```

## Requirements

- `git`
- `jq`
- `claude` (Claude Code CLI)

## Commands

| Command | Description |
|---------|-------------|
| `/handoff write` | Create session handoff document for continuity |
| `/handoff read` | Read handoff and continue work |
| `/ho w` | Short alias for `/handoff write` |
| `/ho r` | Short alias for `/handoff read` |
| `/context` | Show current project context and status |
| `/worktree` | Manage git worktrees for parallel development |
| `/audit` | Security and best practices audit |

### /handoff Workflow

1. End of session: Run `/handoff write` (or `/ho w`)
2. New session: Run `/handoff read` (or `/ho r`)

## Shell Aliases

| Alias | Description |
|-------|-------------|
| `cc` | Start Claude |
| `ccr` | Resume last Claude session |
| `ccw <branch>` | Start Claude in a worktree |
| `ccl` | List Claude sessions |
| `ccs` | Open Claude settings |
| `cch` | Quick handoff |

## Security Hooks

The security hook blocks dangerous commands including:

- Destructive deletions (`rm -rf /`, etc.)
- Dangerous permissions (`chmod 777`)
- Force push to remote (`git push --force`)
- Remote script execution (`curl | bash`)
- Fork bombs
- And more...

## Project Structure

```
build-my-claude/
├── install.sh              # Installation script
├── uninstall.sh            # Removal script
├── update.sh               # Update script
├── Makefile
├── config/
│   ├── CLAUDE.md           # Global system prompt
│   └── settings.template.json
├── commands/
│   ├── handoff.md
│   ├── ho.md
│   ├── context.md
│   ├── worktree.md
│   └── audit.md
├── hooks/
│   ├── pre-tool-use.sh
│   ├── post-tool-use.sh
│   └── global/
│       └── security-check.sh
└── shell/
    └── aliases.sh
```

## Uninstallation

```bash
./uninstall.sh
source ~/.zshrc
```

Or:

```bash
make uninstall
```

Note: Existing files (like `~/.claude/commands/notifier.md`) are preserved.

## Update

```bash
./update.sh
```

Or:

```bash
make update
```

## License

MIT

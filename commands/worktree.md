---
description: Manage git worktrees for parallel development
---

# /worktree - Git Worktree Management

Manage git worktrees for working on multiple branches simultaneously.

## Usage

- `/worktree list` - List all worktrees
- `/worktree add <branch> [path]` - Create a new worktree
- `/worktree remove <path>` - Remove a worktree

## Commands

### /worktree list

Show all existing worktrees:
```bash
git worktree list
```

Display in a readable format:
```
Worktrees:
  main     /path/to/project           (main branch)
  feature  /path/to/project-feature   (feature/xyz)
```

### /worktree add <branch> [path]

Create a new worktree for parallel development.

If path is not specified, use `../{repo-name}-{branch}`.

```bash
# Example: /worktree add feature/login
git worktree add ../myproject-feature-login feature/login
```

After creation, display:
```
Created worktree:
  Branch: feature/login
  Path: /path/to/myproject-feature-login

To switch, run:
  cd /path/to/myproject-feature-login
```

### /worktree remove <path>

Remove a worktree (ensure changes are committed first):
```bash
git worktree remove <path>
```

## Notes

- Worktrees share the same .git repository
- Each worktree can have a different branch checked out
- Perfect for code reviews, hotfixes, or parallel feature development
- Always commit or stash changes before removing a worktree

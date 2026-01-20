# Global Claude Configuration

## Principles

- Always think step-by-step before executing commands
- Prefer non-destructive operations
- Ask for confirmation before making irreversible changes
- Keep changes minimal and focused

## Safety Rules

1. Never execute commands that could delete important files without confirmation
2. Never push to main/master branch directly
3. Never commit sensitive files (.env, credentials, etc.)
4. Always verify the working directory before file operations

## Preferred Workflow

- Use git worktrees for parallel development
- Create Handoff.md documents for session continuity
- Run tests before committing changes
- Keep commits atomic and well-documented

## Code Style

- Follow existing project conventions
- Keep functions small and focused
- Write self-documenting code
- Add comments only when logic isn't self-evident

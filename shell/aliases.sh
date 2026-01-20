#!/bin/bash
# aliases.sh - Shell aliases for Claude Code workflow

# Quick start Claude in current directory
alias cc='claude'

# Start Claude with resume (continue last session)
alias ccr='claude --resume'

# Start Claude in a new worktree
ccw() {
    local branch="${1:-$(git branch --show-current)}"
    local repo_name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
    local worktree_path="../${repo_name}-${branch//\//-}"

    if [ ! -d "$worktree_path" ]; then
        echo "Creating worktree for $branch..."
        git worktree add "$worktree_path" "$branch" 2>/dev/null || \
        git worktree add -b "$branch" "$worktree_path"
    fi

    cd "$worktree_path" && claude
}

# List Claude sessions
alias ccl='claude sessions list'

# Open Claude settings
alias ccs='${EDITOR:-vim} ~/.claude/settings.json'

# Quick handoff - create handoff doc and exit
alias cch='claude -p "/handoff"'

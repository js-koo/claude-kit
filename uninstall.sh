#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }

# 1. Remove command symlinks (only our files, preserve others like notifier.md)
remove_command_links() {
    for cmd in handoff context worktree audit; do
        local link="$CLAUDE_DIR/commands/${cmd}.md"
        if [ -L "$link" ]; then
            rm -f "$link"
        fi
    done
    log_success "Removed command symlinks"
}

# 2. Remove CLAUDE.md symlink
remove_claude_md_link() {
    if [ -L "$CLAUDE_DIR/CLAUDE.md" ]; then
        rm -f "$CLAUDE_DIR/CLAUDE.md"
        log_success "Removed CLAUDE.md symlink"
    fi
}

# 3. Remove hooks from settings.json
remove_hooks_from_settings() {
    local settings="$CLAUDE_DIR/settings.json"

    if [ -f "$settings" ]; then
        # Remove PreToolUse and PostToolUse hooks that point to our scripts
        local updated=$(jq --arg dir "$SCRIPT_DIR" '
            if .hooks then
                .hooks |= (
                    if .PreToolUse then
                        .PreToolUse |= map(select(.hooks | all(.command | contains($dir) | not)))
                        | if .PreToolUse == [] then del(.PreToolUse) else . end
                    else . end
                    |
                    if .PostToolUse then
                        .PostToolUse |= map(select(.hooks | all(.command | contains($dir) | not)))
                        | if .PostToolUse == [] then del(.PostToolUse) else . end
                    else . end
                )
            else . end
        ' "$settings")
        echo "$updated" > "$settings"
        log_success "Removed hooks from settings.json"
    fi
}

# 4. Remove shell rc entry
remove_shell_rc_entry() {
    local rc_file="$HOME/.zshrc"
    if [ -f "$HOME/.bashrc" ] && [ ! -f "$HOME/.zshrc" ]; then
        rc_file="$HOME/.bashrc"
    fi

    if [ -f "$rc_file" ]; then
        # Remove build-my-claude lines
        local temp_file=$(mktemp)
        grep -v "build-my-claude" "$rc_file" > "$temp_file" || true
        mv "$temp_file" "$rc_file"
        log_success "Removed entry from $rc_file"
    fi
}

# Main uninstallation
main() {
    echo "Uninstalling build-my-claude..."
    echo ""

    remove_command_links
    remove_claude_md_link
    remove_hooks_from_settings
    remove_shell_rc_entry

    echo ""
    echo -e "${GREEN}Uninstallation complete!${NC}"
    echo ""
    echo "Note: Your existing ~/.claude/commands/ files (like notifier.md) are preserved."
    echo "Backup files in ~/.claude.backup.* are also preserved."
    echo ""
    echo "Run: source ~/.zshrc (or ~/.bashrc) to apply changes"
}

main "$@"

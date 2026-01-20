#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$HOME/.claude.backup.$(date +%Y%m%d_%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }

# 1. Check dependencies
check_dependencies() {
    local missing=()
    command -v git >/dev/null 2>&1 || missing+=("git")
    command -v jq >/dev/null 2>&1 || missing+=("jq")
    command -v claude >/dev/null 2>&1 || missing+=("claude")

    if [ ${#missing[@]} -ne 0 ]; then
        log_error "Missing dependencies: ${missing[*]}"
        echo "Install with: brew install git jq && npm install -g @anthropic-ai/claude-code"
        exit 1
    fi
    log_success "All dependencies found"
}

# 2. Ensure directories exist
ensure_directories() {
    mkdir -p "$CLAUDE_DIR/commands"
    mkdir -p "$BACKUP_DIR"
    log_success "Directories created"
}

# 3. Backup settings.json if it exists
backup_settings() {
    if [ -f "$CLAUDE_DIR/settings.json" ]; then
        cp "$CLAUDE_DIR/settings.json" "$BACKUP_DIR/settings.json"
        log_success "Backed up settings.json to $BACKUP_DIR"
    fi
}

# 4. Create individual command symlinks (preserves existing files like notifier.md)
create_command_links() {
    for cmd in handoff context worktree audit ho; do
        local target="$SCRIPT_DIR/commands/${cmd}.md"
        local link="$CLAUDE_DIR/commands/${cmd}.md"

        # Remove existing link/file and create new symlink
        rm -f "$link"
        ln -s "$target" "$link"
    done
    log_success "Command files linked"
}

# 5. Create CLAUDE.md symlink
create_claude_md_link() {
    rm -f "$CLAUDE_DIR/CLAUDE.md"
    ln -s "$SCRIPT_DIR/config/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
    log_success "CLAUDE.md linked"
}

# 6. Merge settings.json
merge_settings() {
    local existing="$CLAUDE_DIR/settings.json"
    local template="$SCRIPT_DIR/config/settings.template.json"

    # Replace $INSTALL_DIR with actual path
    local new_settings=$(sed "s|\$INSTALL_DIR|$SCRIPT_DIR|g" "$template")

    if [ -f "$existing" ]; then
        # Deep merge using jq - hooks are merged, other fields preserved
        local merged=$(echo "$new_settings" | jq -s '
            .[0] as $existing |
            .[1] as $new |
            $existing * {
                hooks: (
                    ($existing.hooks // {}) as $eh |
                    ($new.hooks // {}) as $nh |
                    $eh * $nh
                )
            }
        ' "$existing" -)
        echo "$merged" > "$existing"
        log_success "Merged settings.json (existing settings preserved)"
    else
        echo "$new_settings" > "$existing"
        log_success "Created settings.json"
    fi
}

# 7. Update shell rc file
update_shell_rc() {
    local source_line="source \"$SCRIPT_DIR/shell/aliases.sh\""
    local rc_file="$HOME/.zshrc"

    # Support bash users
    if [ -f "$HOME/.bashrc" ] && [ ! -f "$HOME/.zshrc" ]; then
        rc_file="$HOME/.bashrc"
    fi

    if ! grep -qF "build-my-claude" "$rc_file" 2>/dev/null; then
        echo "" >> "$rc_file"
        echo "# build-my-claude" >> "$rc_file"
        echo "$source_line" >> "$rc_file"
        log_success "Updated $rc_file"
    else
        log_warning "Already configured in $rc_file"
    fi
}

# 8. Set executable permissions
set_permissions() {
    chmod +x "$SCRIPT_DIR"/hooks/*.sh
    chmod +x "$SCRIPT_DIR"/hooks/global/*.sh
    chmod +x "$SCRIPT_DIR"/shell/*.sh
    log_success "Set executable permissions"
}

# Main installation
main() {
    echo "Installing build-my-claude..."
    echo ""

    check_dependencies
    ensure_directories
    backup_settings
    create_command_links
    create_claude_md_link
    merge_settings
    update_shell_rc
    set_permissions

    echo ""
    echo -e "${GREEN}Installation complete!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Run: source ~/.zshrc (or ~/.bashrc)"
    echo "  2. Start Claude: claude"
    echo ""
    echo "Available commands:"
    echo "  /handoff write  - Create session handoff document"
    echo "  /handoff read   - Read handoff and continue"
    echo "  /ho w, /ho r    - Short aliases for handoff"
    echo "  /context        - Show project context"
    echo "  /worktree       - Manage git worktrees"
    echo "  /audit          - Security audit"
}

main "$@"

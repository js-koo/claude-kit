#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }

# Main update
main() {
    echo "Updating build-my-claude..."
    echo ""

    # Pull latest changes if in a git repo
    if [ -d "$SCRIPT_DIR/.git" ]; then
        echo "Pulling latest changes..."
        cd "$SCRIPT_DIR"
        git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || log_warning "Could not pull updates"
        log_success "Repository updated"
    else
        log_warning "Not a git repository, skipping pull"
    fi

    # Re-run install to update symlinks and settings
    echo ""
    echo "Re-running installation..."
    "$SCRIPT_DIR/install.sh"
}

main "$@"

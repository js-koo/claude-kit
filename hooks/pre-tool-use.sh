#!/bin/bash
# pre-tool-use.sh - Wrapper for security checks and project hooks

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Run global security check
"$SCRIPT_DIR/global/security-check.sh"
SECURITY_RESULT=$?

if [ $SECURITY_RESULT -eq 2 ]; then
    # Security check blocked the command
    exit 2
fi

# Check for project-specific pre-tool-use hook
if [ -f ".claude/hooks/pre-tool-use.sh" ]; then
    bash ".claude/hooks/pre-tool-use.sh"
    PROJECT_RESULT=$?
    if [ $PROJECT_RESULT -ne 0 ]; then
        exit $PROJECT_RESULT
    fi
fi

exit 0

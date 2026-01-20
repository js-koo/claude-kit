#!/bin/bash
# post-tool-use.sh - Post-execution hook for logging and project hooks

# Check for project-specific post-tool-use hook
if [ -f ".claude/hooks/post-tool-use.sh" ]; then
    bash ".claude/hooks/post-tool-use.sh"
fi

exit 0

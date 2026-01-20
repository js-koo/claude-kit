#!/bin/bash
# security-check.sh - Block dangerous commands

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Exit if no command
if [ -z "$COMMAND" ]; then
    exit 0
fi

# Dangerous patterns (extended)
DANGEROUS_PATTERNS=(
    # Destructive deletions
    'rm\s+(-[rRf]+\s+)*(/|~|\$HOME|/home|/var|/etc|/usr)'
    '\brm\b.*--no-preserve-root'
    'rm\s+-rf\s+\*'

    # Dangerous permissions
    'chmod\s+(-R\s+)?777'
    'chmod\s+(-R\s+)?[0-7]*777'

    # Git dangerous operations
    'git\s+push\s+.*(-f|--force)'
    'git\s+push\s+.*--force-with-lease.*origin\s+(main|master)'
    'git\s+reset\s+--hard'
    'git\s+clean\s+-fd'

    # Remote script execution
    'curl.*\|\s*(ba)?sh'
    'wget.*\|\s*(ba)?sh'
    'curl.*\|\s*python'
    'wget.*\|\s*python'

    # Fork bomb
    ':\(\)\s*\{\s*:\|:&'

    # Sudo dangerous commands
    'sudo\s+rm\s+-rf'
    'sudo\s+chmod\s+777'

    # Disk direct access
    'dd\s+if=.*/dev/'
    '>\s*/dev/sd[a-z]'
    'mkfs\.'

    # Environment destruction
    'export\s+PATH\s*=\s*$'
    'unset\s+PATH'
    'unset\s+HOME'

    # History manipulation
    'history\s+-c'
    'rm.*\.bash_history'
    'rm.*\.zsh_history'
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
    if echo "$COMMAND" | grep -qE "$pattern"; then
        echo "BLOCKED: Dangerous pattern detected - $pattern" >&2
        exit 2  # exit 2 = block command
    fi
done

exit 0  # exit 0 = allow command

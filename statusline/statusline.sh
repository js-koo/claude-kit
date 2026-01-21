#!/bin/bash
# Custom status line for Claude Code CLI
# Reads JSON from stdin and outputs formatted status line

set -euo pipefail

# ANSI color codes
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
RESET='\033[0m'

# Read JSON from stdin
json=$(cat)

# Parse JSON fields using jq (official API field names)
model=$(echo "$json" | jq -r '.model.display_name // .model // "unknown"')
context_used=$(echo "$json" | jq -r '.context_window.total_input_tokens // .contextTokens // 0')
context_max=$(echo "$json" | jq -r '.context_window.context_window_size // .contextMaxTokens // 200000')
input_tokens=$(echo "$json" | jq -r '.context_window.current_usage.input_tokens // .inputTokens // 0')
output_tokens=$(echo "$json" | jq -r '.context_window.current_usage.output_tokens // .outputTokens // 0')
cost_usd=$(echo "$json" | jq -r '.cost.total_cost_usd // .costUSD // 0')
session_id=$(echo "$json" | jq -r '.session_id // .sessionID // ""')
transcript_path=$(echo "$json" | jq -r '.transcript_path // ""')
mcp_servers=$(echo "$json" | jq -r '.mcpServers | length // 0')
remaining_pct=$(echo "$json" | jq -r '.context_window.remaining_percentage // 100')

# Format model name (extract short name)
format_model() {
    case "$1" in
        *opus*|*Opus*) echo "Opus" ;;
        *sonnet*|*Sonnet*) echo "Sonnet" ;;
        *haiku*|*Haiku*) echo "Haiku" ;;
        *) echo "${1:0:10}" ;;
    esac
}

# Format token count (K suffix for thousands)
format_tokens() {
    local tokens=$1
    if [ "$tokens" -ge 1000 ]; then
        echo "$((tokens / 1000))K"
    else
        echo "$tokens"
    fi
}

# Calculate context percentage
calc_context_percent() {
    if [ "$context_max" -gt 0 ]; then
        echo "$((context_used * 100 / context_max))"
    else
        echo "0"
    fi
}

# Get session name from transcript file or fallback to session_id
get_session_name() {
    local transcript="$1"
    local session_id="$2"

    if [ -n "$transcript" ] && [ -f "$transcript" ]; then
        local slug
        slug=$(grep -m1 '"slug"' "$transcript" 2>/dev/null | jq -r '.slug // empty' 2>/dev/null || echo "")
        if [ -n "$slug" ]; then
            echo "$slug"
            return
        fi
    fi

    # fallback: session_id first 8 chars
    echo "${session_id:0:8}"
}

# Get git branch
get_git_branch() {
    git branch --show-current 2>/dev/null || echo ""
}

# Get directory path (top 3 levels)
get_dir_path() {
    local path=$(pwd)
    local result=""
    local count=0

    while [ "$path" != "/" ] && [ $count -lt 3 ]; do
        local name=$(basename "$path")
        if [ -z "$result" ]; then
            result="$name"
        else
            result="$name/$result"
        fi
        path=$(dirname "$path")
        ((count++))
    done

    printf '%s' "$result"
}


# Build status line components
model_str=$(format_model "$model")
context_pct=$(calc_context_percent)
input_str=$(format_tokens "$input_tokens")
output_str=$(format_tokens "$output_tokens")
cost_str=$(printf "%.2f" "$cost_usd")
branch=$(get_git_branch)
dir_path=$(get_dir_path)
session_display=$(get_session_name "$transcript_path" "$session_id")

# Get color for context usage (higher = worse)
get_ctx_color() {
    local pct=$1
    if [ "$pct" -ge 90 ]; then
        echo "$RED"
    elif [ "$pct" -ge 70 ]; then
        echo "$YELLOW"
    else
        echo "$RESET"
    fi
}

# Get color for remaining percentage (lower = worse)
get_compact_color() {
    local pct=$1
    if [ "$pct" -le 10 ]; then
        echo "$RED"
    elif [ "$pct" -le 30 ]; then
        echo "$YELLOW"
    else
        echo "$RESET"
    fi
}

# Get diff stats with colors
get_colored_diff() {
    local stats
    stats=$(git diff --stat 2>/dev/null | tail -1 | grep -oE '[0-9]+ insertion|[0-9]+ deletion' || echo "")
    local added=0
    local removed=0

    if [ -n "$stats" ]; then
        added=$(echo "$stats" | grep -oE '[0-9]+ insertion' | grep -oE '[0-9]+' || echo "0")
        removed=$(echo "$stats" | grep -oE '[0-9]+ deletion' | grep -oE '[0-9]+' || echo "0")
    fi

    [ -z "$added" ] && added=0
    [ -z "$removed" ] && removed=0

    if [ "$added" -gt 0 ] || [ "$removed" -gt 0 ]; then
        printf '%b+%s%b/%b-%s%b' "$GREEN" "$added" "$RESET" "$RED" "$removed" "$RESET"
    fi
}

# Build output with colors
output=""

# Model (Cyan)
output+="${CYAN}${model_str}${RESET}"

# Context usage (Yellow >70%, Red >90%)
ctx_color=$(get_ctx_color "$context_pct")
output+=" | ${ctx_color}ctx:${context_pct}%${RESET}"

# Tokens (input/output)
output+=" | ${input_str}/${output_str}"

# Cost (Green)
output+=" | ${GREEN}\$${cost_str}${RESET}"

# Auto-compact remaining percentage (Yellow <30%, Red <10%)
compact_color=$(get_compact_color "$remaining_pct")
output+=" | ${compact_color}compact:${remaining_pct}%${RESET}"

# Git branch (Blue, if available)
if [ -n "$branch" ]; then
    output+=" | ${BLUE}${branch}${RESET}"
fi

# Directory path (top 3 levels)
output+=" | ${dir_path}"

# Session name (Magenta)
if [ -n "$session_display" ]; then
    output+=" | ${MAGENTA}${session_display}${RESET}"
fi

# MCP servers count (if any)
if [ "$mcp_servers" -gt 0 ]; then
    output+=" | mcp:${mcp_servers}"
fi

# Diff stats with colors (if any changes)
colored_diff=$(get_colored_diff)
if [ -n "$colored_diff" ]; then
    output+=" | ${colored_diff}"
fi

printf '%b\n' "$output"

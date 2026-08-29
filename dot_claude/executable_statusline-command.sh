#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | xargs printf '%.0f')

# OS icon (macOS)
os_icon=""

# Get shortened directory path (replace HOME with ~)
dir_path="${cwd/#$HOME/~}"

# Get git branch and status if in a git repo
git_info=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)

    if [ -n "$(git -C "$cwd" -c core.fileMode=false status --porcelain 2>/dev/null)" ]; then
        git_info=$(printf "\033[33m  $branch\033[0m")
    else
        git_info=$(printf "\033[32m  $branch\033[0m")
    fi
fi

# Build the status line
printf "\033[2m$os_icon  \033[36m$dir_path\033[0m"

if [ -n "$git_info" ]; then
    printf " $git_info"
fi

# Color context usage: green <50%, yellow 50-80%, red >80%
if [ "$used_pct" -ge 80 ]; then
    pct_color="\033[31m"
elif [ "$used_pct" -ge 50 ]; then
    pct_color="\033[33m"
else
    pct_color="\033[32m"
fi

printf " \033[2m│ $model │ ${pct_color}${used_pct}%%\033[0m"

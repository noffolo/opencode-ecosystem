#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: Missing filename argument."
    echo "Usage: $0 <filename>"
    exit 1
fi

TARGET_FILE="$1"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: Not a git repository. Please run this script inside a git repository."
    exit 1
fi

COMMITS=$(git log --format="%H" -- "$TARGET_FILE")

if [ -z "$COMMITS" ]; then
    echo "Error: No git history found for '$TARGET_FILE'."
    exit 1
fi

TOTAL_COMMITS=$(echo "$COMMITS" | wc -l | awk '{print $1}')

echo "Analyzing $TOTAL_COMMITS commits for '$TARGET_FILE'..."
echo "Top co-changed files:"

echo "$COMMITS" | while read -r commit; do
    git show --name-only --format="" "$commit"
done | \
    grep -v '^$' | \
    grep -Fxv "$TARGET_FILE" | \
    sort | uniq -c | sort -nr | head -n 5 | \
    awk -v total="$TOTAL_COMMITS" '{
        count = $1;
        sub(/^[ \t]+[0-9]+[ \t]+/, "");
        file = $0;
        percent = (count / total) * 100;
        printf "%5.1f%% (%d/%d) - %s\n", percent, count, total, file;
    }'

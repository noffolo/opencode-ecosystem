#!/bin/bash

# gate-check.sh - Anti-Slop barrier for OpenCode
# Checks staged or unstaged changes for TODO/FIXME and empty catch blocks.

# Check if we are in a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo -e "\033[31mError: Not in a git repository.\033[0m"
    exit 1
fi

# Determine diff arguments
if [ $# -gt 0 ]; then
    DIFF_ARGS=("$@")
else
    # Default to checking all uncommitted changes (staged + unstaged)
    if git rev-parse --verify HEAD >/dev/null 2>&1; then
        DIFF_ARGS=("HEAD")
    else
        # Initial commit, check against empty tree
        DIFF_ARGS=("4b825dc642cb6eb9a060e54bf8d69288fbee4904")
    fi
fi

echo "Scanning for slop (TODO/FIXME, empty catch blocks)..."

# Run git diff and pipe to awk for portable, regex-based analysis
git --no-pager diff "${DIFF_ARGS[@]}" | awk '
BEGIN {
    slop_found = 0
    file = ""
    line = 0
    in_catch = 0
    catch_line = 0
}
/^+++ b\// {
    file = substr($0, 7)
    next
}
/^+++ \/dev\/null/ {
    file = "/dev/null"
    next
}
/^@@ / {
    plus_part = $3
    sub(/^\+/, "", plus_part)
    split(plus_part, a, ",")
    line = a[1] - 1
    in_catch = 0
    next
}
/^\+/ {
    line++
    content = substr($0, 2)

    # Check for unresolved TODO or FIXME
    if (content ~ /(^|[^a-zA-Z0-9_])(TODO|FIXME)([^a-zA-Z0-9_]|$)/) {
        print "\033[31m[SLOP]\033[0m " file ":" line " - Unresolved TODO/FIXME found."
        print "       " content
        slop_found = 1
    }

    # Check for single-line empty catch block
    if (content ~ /catch[[:space:]]*(\([^)]*\))?[[:space:]]*\{[[:space:]]*\}/) {
        print "\033[31m[SLOP]\033[0m " file ":" line " - Empty catch block found."
        print "       " content
        slop_found = 1
    }

    # Check for multi-line empty catch block completion
    if (in_catch) {
        if (content ~ /^[[:space:]]*\}[[:space:]]*$/) {
            print "\033[31m[SLOP]\033[0m " file ":" catch_line " - Multi-line empty catch block found."
            slop_found = 1
        }
        in_catch = 0
    }

    # Track start of potential multi-line empty catch block
    if (content ~ /catch[[:space:]]*(\([^)]*\))?[[:space:]]*\{[[:space:]]*$/) {
        in_catch = 1
        catch_line = line
    }
}
/^ / {
    line++
    content = substr($0, 2)
    
    # Check for multi-line empty catch block completion on context lines
    if (in_catch) {
        if (content ~ /^[[:space:]]*\}[[:space:]]*$/) {
            print "\033[31m[SLOP]\033[0m " file ":" catch_line " - Multi-line empty catch block found."
            slop_found = 1
        }
        in_catch = 0
    }
    
    # Track start of potential multi-line empty catch block on context lines
    if (content ~ /catch[[:space:]]*(\([^)]*\))?[[:space:]]*\{[[:space:]]*$/) {
        in_catch = 1
        catch_line = line
    }
}
/^-/ {
    # Reset catch tracking if a line is removed (catch block is modified, not empty)
    in_catch = 0
}
/^\\/ {
    # Ignore "\ No newline at end of file"
    next
}
END {
    if (slop_found) {
        print "\033[31mGate check failed: Slop detected in changes.\033[0m"
        exit 1
    } else {
        print "\033[32mGate check passed: No slop detected.\033[0m"
        exit 0
    }
}
'

# Exit with the status code of the awk command
exit ${PIPESTATUS[1]}

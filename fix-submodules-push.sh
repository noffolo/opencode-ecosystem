#!/bin/bash
set -e

# Some pushes failed because the forks were created with the upstream's latest state,
# but we have local commits we need to push. We should force push our local state to OUR new forks.
# It is safe because these are our own freshly created forks.

force_push_submodule() {
    local dir=$1
    echo "Force pushing $dir to our fork..."
    local branch=$(git -C "$dir" branch --show-current)
    if [ -z "$branch" ]; then
        git -C "$dir" checkout -b main || git -C "$dir" checkout -b master
        branch=$(git -C "$dir" branch --show-current)
    fi
    git -C "$dir" push -u origin "$branch" --force || echo "  Failed to force push $dir"
}

force_push_submodule "codemem"
force_push_submodule "oh-my-openagent"
force_push_submodule "skills-staging/antigravity-awesome"
force_push_submodule "skills-staging/openclaw-skills"

echo "Done force pushing!"

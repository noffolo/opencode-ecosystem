#!/bin/bash
set -e

touch .gitmodules

process_submodule() {
    local dir=$1
    echo "Processing $dir..."
    
    # Get original remote URL
    local original_url=$(git -C "$dir" remote get-url origin)
    echo "  Original URL: $original_url"
    
    # Extract repo owner/name (e.g. kunickiaj/codemem from https://github.com/kunickiaj/codemem.git)
    local repo_path=$(echo "$original_url" | sed -E 's/.*github\.com[\/:]//' | sed 's/\.git$//')
    local repo_name=$(basename "$repo_path")
    
    echo "  Forking $repo_path..."
    # Fork the repo
    if gh repo view "noffolo/$repo_name" &>/dev/null; then
        echo "  Fork noffolo/$repo_name already exists."
    else
        gh repo fork "$repo_path" --clone=false --org="noffolo" || echo "  Fork command failed or already exists"
    fi
    
    # Give GitHub a moment to create the fork
    sleep 2
    
    local new_url="https://github.com/noffolo/$repo_name.git"
    echo "  Updating remote to $new_url"
    git -C "$dir" remote set-url origin "$new_url"
    
    echo "  Pushing to new fork..."
    # We use the current branch of the submodule
    local branch=$(git -C "$dir" branch --show-current)
    if [ -z "$branch" ]; then
        # Detached head, let's create a branch
        git -C "$dir" checkout -b main || git -C "$dir" checkout -b master
        branch=$(git -C "$dir" branch --show-current)
    fi
    git -C "$dir" push -u origin "$branch" || echo "  Failed to push $dir"
    
    # Add to .gitmodules using git config
    git config -f .gitmodules submodule."$dir".path "$dir"
    git config -f .gitmodules submodule."$dir".url "$new_url"
    
    # Stage the submodule explicitly
    git add "$dir"
}

# Process top-level submodules
for dir in OpenAgentsControl codemem oh-my-openagent opencode-skills opencode-workaholic; do
    if [ -d "$dir/.git" ]; then
        process_submodule "$dir"
    fi
done

# Process nested submodules
for dir in skills-staging/*; do
    if [ -d "$dir/.git" ]; then
        process_submodule "$dir"
    fi
done

echo "Done processing submodules."

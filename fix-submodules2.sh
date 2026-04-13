#!/bin/bash
set -e

# Clear existing .gitmodules to start fresh
> .gitmodules

process_submodule() {
    local dir=$1
    local original_url=$2
    
    echo "Processing $dir..."
    
    # Extract repo owner/name (e.g. kunickiaj/codemem from https://github.com/kunickiaj/codemem.git)
    local repo_path=$(echo "$original_url" | sed -E 's/.*github\.com[\/:]//' | sed 's/\.git$//')
    local repo_name=$(basename "$repo_path")
    
    echo "  Forking $repo_path to personal account..."
    # Fork without --org to create it in the personal account
    # Also add the upstream remote for fetching updates later
    if gh repo view "noffolo/$repo_name" &>/dev/null; then
        echo "  Fork noffolo/$repo_name already exists."
    else
        gh repo fork "$repo_path" --clone=false || echo "  Fork command failed, maybe it exists."
    fi
    
    # Give GitHub a moment to create the fork
    sleep 3
    
    local new_url="https://github.com/noffolo/$repo_name.git"
    echo "  Updating remote origin to $new_url"
    git -C "$dir" remote set-url origin "$new_url"
    
    # Make sure we keep the original as upstream so we can pull updates
    git -C "$dir" remote remove upstream 2>/dev/null || true
    git -C "$dir" remote add upstream "$original_url"
    
    echo "  Pushing to new fork..."
    local branch=$(git -C "$dir" branch --show-current)
    if [ -z "$branch" ]; then
        git -C "$dir" checkout -b main || git -C "$dir" checkout -b master
        branch=$(git -C "$dir" branch --show-current)
    fi
    git -C "$dir" push -u origin "$branch" || echo "  Failed to push $dir (maybe empty or already up to date)"
    
    # Add to .gitmodules using git config
    git config -f .gitmodules submodule."$dir".path "$dir"
    git config -f .gitmodules submodule."$dir".url "$new_url"
    
    # Stage the submodule explicitly
    git add "$dir"
}

process_submodule "OpenAgentsControl" "https://github.com/darrenhinde/OpenAgentsControl"
process_submodule "codemem" "https://github.com/kunickiaj/codemem.git"
process_submodule "oh-my-openagent" "https://github.com/code-yeongyu/oh-my-openagent.git"
process_submodule "opencode-skills" "https://github.com/malhashemi/opencode-skills.git"
process_submodule "opencode-workaholic" "https://github.com/RoderickQiu/opencode-workaholic.git"
process_submodule "skills-staging/antigravity-awesome" "https://github.com/sickn33/antigravity-awesome-skills.git"
process_submodule "skills-staging/awesome-opencode" "https://github.com/awesome-opencode/awesome-opencode.git"
process_submodule "skills-staging/openclaw-skills" "https://github.com/openclaw/skills.git"
process_submodule "skills-staging/volt-openclaw-skills" "https://github.com/VoltAgent/awesome-openclaw-skills.git"

git add .gitmodules
git commit -m "chore: fork submodules to noffolo to fix push permissions while tracking upstream"
git push origin main

echo "Done!"

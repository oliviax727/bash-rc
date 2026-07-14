# shellcheck shell=bash

# ===== CUSTOM COMMANDS - GIT HELPER COMMANDS AND AUTOMATION ===== #

# Propagate a single commit throughout all of the branches
function git-propagate() {

    git stash

    local -a branches
    mapfile -t branches < <(git branch -r | cut -c 10- | grep -v HEAD)
    local commit
    commit=$(git rev-parse HEAD)
    local current
    current=$(git rev-parse --abbrev-ref HEAD)

    for branch in "${branches[@]}"; do
        if [ ! "$branch" == "$current" ]; then
            git checkout "$branch"
            git cherry-pick "$commit"
            git push
        fi
    done

    git checkout "$current"
    git stash apply
}

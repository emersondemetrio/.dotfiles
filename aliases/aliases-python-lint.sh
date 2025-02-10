ruff_diff() {

    local changed_files=$(git diff --name-only)

    if [[ -z "$changed_files" ]]; then
        echo "No changed files found."
        return 0
    fi

    while IFS= read -r file; do
        if [[ -f $file ]]; then
            ruff format "$file"
        else
            echo "File $file not found, skipping..."
        fi
    done <<<"$changed_files"
}

alias ruff-diff='ruff_diff'

ruff_diff_master() {
    local changed_files=$(git diff origin/master --name-only)
    echo "Changed files in this branch: (compared to origin/master)"
    echo $changed_files
    echo

    if [[ -z "$changed_files" ]]; then
        echo "No changed files found."
        return 0
    fi

    while IFS= read -r file; do
        if [[ -f $file ]]; then
            echo "Formatting: $file"
            ruff format "$file"
            echo
        else
            echo "File $file not found, skipping..."
        fi
    done <<<"$changed_files"
}

alias master-ruff-diff='ruff_diff_master'

ruff_list() {
    if [[ ! -f $1 ]]; then
        echo "File $1 not found!"
        exit 1
    fi

    while IFS= read -r file; do
        if [[ -f $file ]]; then
            ruff format "$file"
        else
            echo "File $file not found, skipping..."
        fi
    done <$1
}

alias ruff-list='ruff_list'

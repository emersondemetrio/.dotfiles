alias typecheck="yarn type:check"
alias type-check="typecheck"

# Format diff ts/tsx files

_deno_format_diff() {
    local current_dir=$(pwd)
    local changed_files=$(git diff --name-only --diff-filter=d | grep -E '\.(ts|js|tsx|jsx)$')

    if [[ -z "$changed_files" ]]; then
        echo "No files to format"
        return 0
    fi

    while IFS= read -r file; do
        if [[ "$file" = /* ]]; then
            local full_path="$file"
        else
            local full_path="$current_dir/$file"
        fi

        if [[ -f "$full_path" ]]; then
            echo "Formatting: $full_path"
            deno fmt "$full_path"
        else
            echo "File $full_path not found, skipping..."
        fi
    done <<<"$changed_files"
}

alias deno-format-diff="_deno_format_diff"

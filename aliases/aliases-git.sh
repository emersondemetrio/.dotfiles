alias add_all="~/scripts/src/sh/add-all-and-commit.sh"
alias add-all="add_all"
alias addall="add_all"
alias diff-name-only="git diff $1 --name-only"

alias gst='clear; echo ''; git status;'
alias gsd='gst;'
alias gs='gst;'
alias gcb='git checkout -b'
alias go-master='~/scripts/src/sh/git-go-master.sh'
alias gomaster='go-master'
alias gomas='go-master'
alias ogmas='go-master'

alias gomain="clear; git checkout main; git pull; git status;"
alias go-main="gomain"
alias go_main="gomain"

alias stashgomas="clear; git stash; git checkout master; git pull; git status; yarn;"
alias stash-gomas="stashgomas"
alias sgomas="stashgomas"

alias godev="gobranch development"
alias fgodev="clear; echo ''; godev; resetorigin"
alias fgobranch="clear; echo ''; gobranch $1; resetorigin"

alias rebase_master='~/scripts/src/sh/git-rebase-master.sh'
alias rebase-master='rebase_master'
alias rebasemaster='rebase_master'

alias reset_origin='~/scripts/src/sh/reset-origin.sh'
alias reset-origin='reset_origin'
alias resetorigin='reset_origin'

alias reset-main="~/scripts/src/sh/reset-master.sh"
alias reset-master="reset-main"
alias resetmain="reset-main"
alias resetmaster="reset-main"

alias force_reset_origin="~/scripts/src/sh/force-reset-origin.sh"
alias force-reset-origin="force_reset_origin"

alias gck="~/scripts/src/sh/gck.sh"
alias new_branch="gck"
alias new-branch="gck"
alias newbranch="gck"
alias nb="gck"

alias gclone="git clone $1"
alias delete-branchs="~/scripts/src/sh/delete-branchs.sh"

alias git-show-untracked="git clean -n -d"
alias git-remove-untracked="git clean -f"

alias push_origin="~/scripts/src/sh/push-origin.sh"
alias push-origin="push_origin"
alias pushorigin="push-origin"
alias pusho="push-origin"

alias fpushorigin="~/scripts/src/sh/git-push-force.sh"
alias faddallandpush="~/scripts/src/sh/git-add-all-force.sh"

# Search branch
alias sbranch="~/scripts/src/sh/search-branch.sh"
alias sb="sbranch"

# Search and delete branch
alias sdbranch="~/scripts/src/sh/search-delete-branches.sh"

## Remove branch
alias rmb="~/scripts/src/sh/remove-branch.sh"
alias remove-branch="rmb"

## Checkout branch (without create)
alias ck="~/scripts/src/sh/ck.sh"
alias gobranch="git checkout $1"
# end git

## Copy diff to clipboard

alias copy-diff="~/scripts/src/sh/copy-diff.sh"
alias copydiff="copy-diff"

alias copy-diff-dev="git diff origin/development | pbcopy"
alias dev-copy-diff="copy-diff-dev"
alias devcopydiff="copy-diff-dev"

## end Copy diff to clipboard

alias rebase="git rebase -i $1"

alias ftomaster="git checkout origin/main -- "

copy_branch_name() {
    CURRENT_BRANCH_NAME=$(git branch --show-current)
    echo $CURRENT_BRANCH_NAME | pbcopy
    echo "$CURRENT_BRANCH_NAME copied to clipboard"
}

alias copy-branch-name="copy_branch_name"
alias copybranchname="copy-branch-name"
alias copybn="copy-branch-name"

alias gcnv="git add .; git commit --no-verify"

url_from_branch() {
    # works with github only.
    # Get the remote origin URL
    local url=$(git config --get remote.origin.url)

    # exit if there's no git folder
    if [ ! -d .git ]; then
        echo "https://github.com/orgs/agencyenterprise/repositories"
    fi

    # Remove any extra forward slashes and colons from the URL
    url=$(echo "$url" | sed -E 's#^(https?:/?/?)/#https://#')

    # Check if the URL is in SSH format
    if [[ $url == git@* ]]; then
        # Convert SSH format to HTTPS format
        url=$(echo "$url" | sed -E 's#^git@([^:]+):#https://\1/#')
    fi

    # Remove the .git suffix if present
    url=${url%.git}

    # Clean up any remaining double slashes (except after https:)
    url=$(echo "$url" | sed -E 's#([^:])//+#\1/#g')

    # If the URL is already in HTTPS format, ensure it's correctly formatted
    if [[ $url == https://* ]]; then
        echo "$url"
    else
        # Prefix with https:// if not already present
        echo "https://$url"
    fi
}

# Alias to open the remote repository in Google Chrome
alias open-remote='open -a "Google Chrome" "$(url_from_branch)"'
alias open-issues='open -a "Google Chrome" "$(url_from_branch)/issues"'
alias open-mrs='open -a "Google Chrome" "$(url_from_branch)/pulls"'
alias merges='open -a "Google Chrome" "$(url_from_branch)/pulls/$USER"'

alias no_edit_amend_and_push="echo 'Assuming you have added files already.'; git commit --amend --no-edit --no-verify; git push -f"
# folders
alias cdp='cd ${HOME}/projects; clas;'
alias cpd='cdp'
alias cdd='cd ${HOME}/Downloads; clas;'
alias cds='cd ${HOME}/Desktop/'
alias cdss='cd ${HOME}/scripts/; clas'
alias cdds='cdss'
alias cdu='cd $HOME}; clas;'
alias las='ls -las'
alias lasc='clear; ls -las'
alias clas='clear; printf "\nContents of: `pwd`\n\n"; ls -las'
alias pwdgst="echo; pwd; git status;"
alias cbd='cdb'
alias cd..='cd ..'
alias cdscr='cd ~/scripts; pwd; code .'
# end folders

remove_files_on_clipboard() {
    FILES_TO_REMOVE=$(pbpaste)
    while IFS= read -r FILE; do
        if [ -n "$FILE" ]; then
            # Trim leading space that's causing the issue
            FILE=$(echo "$FILE" | sed 's/^[[:space:]]*//')
            echo "Removing file: $(pwd)/$FILE"
            rm -rf "$(pwd)/$FILE"
        fi
    done <<< "$FILES_TO_REMOVE"
}

alias rmfc='remove_files_on_clipboard'

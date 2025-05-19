#!/bin/zsh

# If search term is provided, filter aliases
if [ -n "$1" ]; then
    alias | grep -i "$1" | awk -F"=" '{printf "\033[33m%-20s\033[0m → %s\n", substr($1,7), $2}' | sort
else
    alias | awk -F"=" '{printf "\033[33m%-20s\033[0m → %s\n", substr($1,7), $2}' | sort
fi

# Print total count
echo "\nTotal aliases: $(alias | grep -c "${1:-.}")"

# Chrome shortcuts
create_chrome_shortcuts() {
  local shortcuts_file="$HOME/scripts/aliases/chrome.json"

  if [ -f "$shortcuts_file" ]; then
    while IFS= read -r shortcut; do
      # Get the URL and aliases
      local url=$(echo "$shortcut" | jq -r '.url')
      local aliases=$(echo "$shortcut" | jq -r '.alias[]')
      local name=$(echo "$shortcut" | jq -r '.name')

      # Create aliases for each alias in the array
      echo "$aliases" | while read -r alias_name; do
        # Skip empty lines
        [ -z "$alias_name" ] && continue

        # Create the alias
        alias "$alias_name"="chrome '$url'"

        # Debug output if needed
        # echo "Created alias: $alias_name -> $name ($url)"
      done
    done < <(jq -c '.[]' "$shortcuts_file")
  else
    echo "Chrome shortcuts file not found: $shortcuts_file"
    printf "Example file: \n [
      {
        "url": "https://www.google.com",
        "alias": ["g", "google"],
        "name": "Google"
      }
    ]\n"
  fi
}

# Create the chrome shortcuts
create_chrome_shortcuts

youtubes() {
    # https://www.youtube.com/results?search_query=sinkin+summer
    open -a "Google Chrome" "https://www.youtube.com/results?search_query=$*"
}

ayoutubes() {
    # does the same as youtubes but opens in a incognito window
    open -na "Google Chrome" --args --incognito "https://www.youtube.com/results?search_query=$*"
}

alias youtube="chrome 'https://www.youtube.com/'"
# alias youtubes="youtubes"
alias iyoutubes="ayoutubes"

alias shoe="youtubes shoegaze playlist"



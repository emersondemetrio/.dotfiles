### Syncing Aliases
echo
echo "Syncing aliases..."

cp -R ~/scripts/aliases/ aliases

rm aliases/aliases-ae.sh

ls -l aliases

### Syncing src
echo
echo "Syncing src..."

cp -R ~/scripts/src .

rm -rf src/sh/verify-user.sh
rm -rf src/python/new-react-component
rm src/js/open-fleet*
rm src/sh/open-fleet*
rm src/python/random-pass.py
rm src/sh/start-all.sh
rm src/sh/open-issue.sh
rm src/python/get-merge-request.py

ls -l src

### Syncing vscode settings
echo
echo "Syncing vscode settings..."

VS_SETTINGS_DIR=./vs-settings

cp ~/Library/Application\ Support/Code/User/settings.json $VS_SETTINGS_DIR
cp ~/Library/Application\ Support/Code/User/keybindings.json $VS_SETTINGS_DIR
code --list-extensions >$VS_SETTINGS_DIR/extensions.txt
cp -r ~/Library/Application\ Support/Code/User/snippets/ $VS_SETTINGS_DIR

### Clean up
search_string="$USER"
replace_string="<your-path>"

# Export LC_ALL to avoid illegal byte sequence errors
export LC_ALL=C

# Use find to locate all files and sed to perform the replacement
find src -type f -exec sed -i '' "s/${search_string}/${replace_string}/g" {} +
find aliases -type f -exec sed -i '' "s/${search_string}/${replace_string}/g" {} +

echo "Sync complete."

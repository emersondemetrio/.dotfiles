alias chrome='open -a "Google Chrome"'
alias cat_scripts='cat package.json | jq ".scripts"'
alias cat-scripts="cat_scripts"
alias random-pass='~/scripts/src/random-pass.py'
alias genpass='random-pass'
alias realpath='~/scripts/src/realpath.sh'
alias nrc='~/scripts/src/new-react-component/nrc.py'
alias tz='chrome "http://localhost:3666"'
alias dashcase='~/scripts/src/dash-case.js'
alias cased=dashcase
alias casedash=dashcase

alias reset_modules='~/scripts/src/reset-modules.sh'
alias reset-modules='reset_modules'
alias resetmodules='reset_modules'
alias reset_packages='reset_modules'
alias reset-packages='reset_modules'
alias resetpackages='reset_modules'

alias test_diff='clear; ./node_modules/.bin/jest -- $(git diff --name-only -- "*.test.tsx" "*.test.config.tsx")'
alias test-diff='test_diff'

alias test_only='clear; ./node_modules/.bin/jest -- $1'
alias test-only='test_only'
alias testonly='test_only'

alias update_source='source ~/.zshrc'
alias update_src="update_source"
alias update-src="update_source"
alias updatesrc='update_source'
alias update_s='update_source'

alias video-to-gif='~/scripts/src/video-to-gif.sh'
alias to-gif="video-to-gif"
alias togif="video-to-gif"
alias vs='code .'
alias c.='code .'
alias code.="code ."

alias editscripts='code ~/scripts/'
alias edit-scripts='editscripts'
alias scripts-edit='editscripts'
alias scriptsedit='editscripts'

alias interval="node ~/scripts/src/interval.js"

alias brazil="node ~/scripts/src/time.js"
alias brasil="brazil"

google_search() {
    echo "Google search: $1"
    chrome "https://www.google.com/search?q=$1"
}

alias google="google_search"

decode_base64() {
    echo $1 | base64 --decode
}

encode_base64() {
    if test -f $1; then
        base64 $1
    else
        echo $1 | base64
    fi
}

alias encode-base64="encode_base64"
alias decode-base64="decode_base64"

alias percent='node ~/scripts/src/percents.js'
alias topercent='percent'
alias to-percent='percent'

alias create-html-file="~/scripts/src/create-html-file.js"
alias html-file="create-html-file"

alias to-mp4="ffmpeg -i $1 -codec copy $2"

alias to-mp3="ffmpeg -i $1 -vn -acodec libmp3lame -q:a 4 $2"
alias tomp3="to-mp3"

alias conceitual="cd /Users/<your-path>/projects/conceitual; clas"

alias yanr="yarn"

alias github="chrome https://github.com/<your-path>"

alias emerson="cd ~/projects/personal/<your-path>.github.io"
alias emers="emerson"
alias emer="emerson"

alias calendar="chrome https://calendar.google.com/calendar/u/1/r"
alias cale="calendar"
alias cald="calendar"

alias sizeof="~/scripts/src/file.sh"
alias new="~/scripts/new-terminal.sh"

alias in_minutes="node ~/scripts/src/time-conversion.js"
alias inminutes="node ~/scripts/src/time-conversion.js"

alias time-conversion="node ~/scripts/src/time-conversion.js"
alias timeconversion="node ~/scripts/src/time-conversion.js"

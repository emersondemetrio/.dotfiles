alias trello="chrome https://trello.com/b/tSBjLOPk/day-to-day"
alias flights="chrome 'https://www.google.com/travel/flights?hl=en&gl=us&authuser=0'"
alias cl="chrome 'https://calendar.google.com/calendar?authUser=emer.demetrio@gmail.com'"

youtubes() {
    # https://www.youtube.com/results?search_query=sinkin+summer
    open -a "Google Chrome" "https://www.youtube.com/results?search_query=$*"
}

ayoutubes() {
    # does the same as youtubes but opens in a incognito window
    open -na "Google Chrome" --args --incognito "https://www.youtube.com/results?search_query=$*"
}

alias youtube="chrome 'https://www.youtube.com/'"
alias youtubes="youtubes"
alias layoutubes="ayoutubes"

alias pl="chrome https://open.spotify.com/collection/tracks"
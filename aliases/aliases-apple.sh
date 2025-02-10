alias apple-certificates="chrome https://developer.apple.com/account/resources/certificates/list"
alias apple-store-connect="chrome https://appstoreconnect.apple.com/"


_find_xcode_project() {
    find . -name "*.xcodeproj"
}

alias xcode='open -a Xcode "$(_find_xcode_project)"'
alias xc="xcode"
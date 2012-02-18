
[[ "$OS" = "Darwin" ]] && {

    alias ldd="otool -L"
    alias telnet="/usr/bin/telnet -K"

    # Formats a man page as PDF, then supplies to Preview.app on stdin.
    pman() {
        man -t "$@" | open -f -a Preview
    }
}


#
# Sets Oh My Zsh options.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Set the key mapping style to 'emacs' or 'vi'.
zstyle ':omz:module:editor' keymap 'emacs'

# Auto convert .... to ../..
zstyle ':omz:module:editor' dot-expansion 'yes'

# Set case-sensitivity for completion, history lookup, etc.
zstyle ':omz:*:*' case-sensitive 'no'

# Color output (auto set to 'no' on dumb terminals).
zstyle ':omz:*:*' color 'yes'

# Auto set the tab and window titles.
zstyle ':omz:module:terminal' auto-title 'no'

# Set the Zsh modules to load (man zshmodules).
# zstyle ':omz:load' zmodule 'attr' 'stat'

# Set the Zsh functions to load (man zshcontrib).
zstyle ':omz:load' zfunction 'zargs' 'zmv'

# freaking svn repo version conflicts...
if [[ -x /opt/gums/bin/svn ]]; then
    zstyle ':vcs_info:svn:*:-all-' command /usr/bin/svn
    alias svn='/usr/bin/svn'
fi

# Set the Oh My Zsh modules to load (browse modules).
# The order matters.
#   * 'environment' should be first.
#   * 'completion' must be after 'utility'.
#   * 'syntax-highlighting' should be next to last, but, it must be
#      before 'history-substring-search'.
#   * 'prompt' should be last
zstyle ':omz:load' omodule \
    'environment' \
    'terminal' \
    'editor' \
    'history' \
    'directory' \
    'spectrum' \
    'utility' \
    'completion' \
    'git' \
    'osx' \
    'syntax-highlighting' \
    'history-substring-search' \
    'prompt'

# Set the prompt theme to load.
# Setting it to 'random' loads a random theme.
# Auto set to 'off' on dumb terminals.
zstyle ':omz:module:prompt' theme 'steeef'

# This will make you shout: OH MY ZSHELL!
source "$OMZ/init.zsh"

# Customize to your needs...

umask 022

# no shared history, keep history per session
setopt no_share_history

# after ssh, set the title back to local host's name
ssh() {
    if [[ -x /usr/local/bin/ssh ]]; then
        /usr/local/bin/ssh $@
    else
        /usr/bin/ssh $@
    fi
    set-tab-title $(uname -n)
}

alias vi='vim'
alias view='vim -R'
alias vimdiff='vimdiff -O'

alias c='clear'

# print the directory structure from the current directory in tree format
alias dirf="find . -type d|sed -e 's/[^-][^\/]*\//  |/g' -e 's/|\([^ ]\)/|-\1/'"

# Show me time in GMT / UTC
alias utc='TZ=UTC date'
alias gmt='TZ=GMT date'

# Time in different places
alias jpdate='TZ=Asia/Tokyo date'
alias nldate='TZ=Europe/Amsterdam date'
alias fidate='TZ=Europe/Finland date'

# show me platform info
alias os='uname -srm'

# translate AS/RR numbers
astr() { echo "$1" | tr '[A-J0-9]' '[0-9A-J]' }

# show me installed version of a perl module
alias pmver="perl -le '\$m = shift; eval qq(require \$m) \
    or die qq(module \"\$m\" is not installed\\n); \
    print \$m->VERSION'"

# tell me if a perl module has a method
pmhas() {
    local __module="$1"
    local __method="$2"
    [[ -n "__method" ]] || { echo 'Usage: pmhas <module> <method>'; return; }
    local __result=$(perl -M$__module -e "print ${__module}->can('$__method');")
    [[ $__result =~ 'CODE' ]] && echo "$__module has $__method"
}

# sleep this long, then beep
beep() {
    local __timer=0
    [[ -n "$1" ]] && __timer=$1
    until [[ $__timer = 0 ]]; do
        printf "  T minus $__timer     \r"
        __timer=$((__timer - 1))
        sleep 1
    done
    echo '- BEEP! -    \a\r'
}

# make a project directory
mkproj() {
    local _usage='Usage: mkproj <desc> [<ticket>]'
    [[ -z "$1" || "$1" =~ '^(-h|--help)' ]] && { echo $_usage; return }
    local _dir
    local _date=$(date +'%Y%m%d')
    local _name="$1"
    local _suffix
    [[ -n "$2" ]] && _suffix="-${2}"
    _dir="${_date}-${_name}${_suffix}"
    [[ -d ~/$_dir ]] && { echo 'already exists!'; return }
    mkdir ~/$_dir && cd ~/$_dir
}

# find a project directory
proj() {
    local _usage='Usage: proj [<pattern>]'
    [[ "$1" =~ '^(-h|--help)' ]] && { echo $_usage; return }
    # If there's no pattern, go to the most recent project.
    [[ -z "$1" ]] && { cd ~/(19|20)[0-9][0-9][01][0-9][0-3][0-9]-*(/om[1]); return }
    local _this
    local _choice=0
    local _index=1
    local _projects
    typeset -a _projects
    _projects=()
    for _this in ~/(19|20)[0-9][0-9][01][0-9][0-3][0-9]-*$1*; do
        [[ -d $_this ]] && _projects+=$_this
    done 2>/dev/null
    [[ $#_projects -eq 0 ]] && { echo 'No match.'; return }
    [[ $#_projects -eq 1 ]] && { cd $_projects[1]; return }
    for _this in $_projects[1,-2]; do
        echo "  [$_index] $(basename $_this)"
        _index=$(( $_index + 1 ))
    done
    echo "* [$_index] \e[0;31;47m$(basename $_projects[-1])\e[0m"
    echo
    until [[ $_choice -ge 1 && $_choice -le $#_projects ]]; do
        printf 'select> '
        read _choice
        [[ -z "$_choice" ]] && { cd $_projects[-1]; return }
    done
    cd $_projects[$_choice]
}

# count something fed in on stdin
alias count='sort | uniq -c | sort -n'

# Strip comment / blank lines from an output
alias stripcomments="egrep -v '^([\ \t]*#|$)'"

alias ack='ack --smart-case'

# Give me a list of the RPM package groups
alias rpmgroups='cat /usr/share/doc/rpm-*/GROUPS'

# Get my current public IP
alias get-ip='curl --silent http://icanhazip.com'

# less with no-wrap (oh-my-zsh default, could be useful sometimes)
alias less-nowrap='less -S'

# set tab titles
alias tt='set-tab-title'

# magic mv
# mmv *.c.orig orig/*.c
alias mmv='noglob zmv -W'

# globbing cheat sheet
globcheat() {

    echo
    echo '**/ recurse   ***/ follow symlinks   class: [...]   neg: [^...] or [!...]'
    echo
    echo '/ dir  . file  * exec  @ symlink  = socket  p pipe  % device %b block %c char'
    echo
    echo 'r u:read   w u:write   x u:exec   U owner-is-my-uid   u123 owner is uid 123'
    echo 'A g:read   I g:write   E g:exec   G group-is-my-gid   u:dan: owner is dan'
    echo 'R o:read   W o:write   X o:exec                       or g123, g:dan:'
    echo
    echo 'm mtime   default period is days    + or - a value      mw-1 in past week'
    echo 'a atime   M month  w week  h hour  m minute  s second   aM-1 in past month'
    echo
    echo 'L file size (bytes)   k kbytes  m mbytes  p blocks   Lm+1 = larger than 1mb'
    echo
    echo '*(u0WLk+10m0) owner root, world write, > 10KB, mtime in past hour'

}

alias cless='colordiff | less'

# 6core.net pasteboard
6p() {
    curl -k -F "content=<${1--}" -F ttl=604800 -w "%{redirect_url}\n" \
        -o /dev/null https://p.6core.net/
}

# fix ssh setup in a reattached tmux environment
fixssh() {
    for key in SSH_AUTH_SOCK SSH_CONNECTION SSH_CLIENT; do
        if (tmux show-environment | grep "^${key}" > /dev/null); then
            value=`tmux show-environment | grep "^${key}" | sed -e "s/^[A-Z_]*=//"`
            export ${key}="${value}"
        fi
    done
}

if [[ $UID -eq 0 ]]; then

    ### Things to do only if I am root

    # Messes with rdist and probably other stuff
    unset SSH_AUTH_SOCK

else

    ### Things to do only if I am not root

    set-tab-title $(uname -n)

    [[ -f ~/.rbenv/bin/rbenv ]] && eval "$(rbenv init -)"

    mkdir -p ~/.vim/tmp/{backup,swap,undo}

    if [[ -n "$(command -v tmux)" ]]; then

        alias tmux='tmux -u'

        tmux_ls() {
            echo "\n-- tmux sessions --\n$(tmux ls 2>/dev/null)"
        }

        # List tmux sessions
        if [[ -z "$TMUX" && -n "$(tmux ls 2>/dev/null)" ]]; then
            tmux_ls
        fi

        # tmux magic alias to list, show, or attach
        t() {
            [[ -z "$1" ]] && { tmux_ls; return }
            local _detach_flag
            if [[ "$1" = "-d" ]]; then
                _detach_flag="-d"
                shift
            fi
            export STY="[$1] $(uname -n)"
            set-tab-title $STY
            tmux -u new -s "$1" || tmux -u att $_detach_flag -t "$1"
            set-tab-title $(uname -n)
        }

    fi

fi

# Mac-specific things
if [[ "$(uname -s)" = "Darwin" ]]; then

    #battery_charge_meter() { $HOME/.scripts/laptop_battery_charge }
    #export RPROMPT='$(battery_charge_meter)'

    alias ql='qlmanage -p "$@" >& /dev/null'
    alias telnet='/usr/bin/telnet -K'
    alias ldd='otool -L'

    # This shows which processes are using the network right now.
    alias netusers='lsof -P -i -n | cut -f 1 -d " " | uniq'

fi

# local settings override global ones
[[ -s $HOME/.zshrc.local ]] && source $HOME/.zshrc.local

# Make the prompt happy so I don't have $? true on every load
__zsh_load_complete=1


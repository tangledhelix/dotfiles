# Path to your oh-my-zsh installation.
export ZSH=$HOME/.dotfiles/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="steeef"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git virtualenv history-substring-search)
# colored-man
# common-aliases (this includes rm -i ...)
# dircycle
# git-extras
# history (alias 'h' etc)
# jsontools
# ssh-agent
# sublime
# tmux
# virtualenvwrapper

# User configuration

# export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

# Set the list of directories that man searches for manuals.
manpath=(
    /opt/gums/man
    /usr/local/man
    /usr/man
    /usr/local/share/man
    /usr/share/man
    /usr/local/pkg/perl/man
    /usr/dt/man
    /usr/openwin/man
    /usr/sfw/man
    ~/local/man
    ~/local/share/man
    ~/.cabal/share/man
    $manpath
)

for path_file in /etc/manpaths.d/*(.N); do
    manpath+=($(<$path_file))
done
unset path_file

# Set the list of directories that Zsh searches for programs.
path=()

path_candidates=(
    /opt/gums/bin
    /home/eng/config/tools/bin
    /home/eng/bin
    ~/config/tools/mpls
    ~/config/tools/scripts
    /opt/gums/sbin
    ~/local/bin
    ~/bin
    ~/.scripts
    ~/.rbenv/bin
    ~/.gems/bin
    /admin/bin
    /usr/local/share/npm/bin
    /usr/local/{bin,sbin}
    /usr/{bin,sbin}
    /{bin,sbin}
    /usr/ccs/bin
    /usr/proc/bin
    /usr/{openwin,dt}/bin
    /admin/tools/system/
    /admin/tools/mail/{bin,sbin}
    /admin/config/auth/bin
    /usr/local/pkg/perl/bin
    /usr/local/pkg/ruby/bin
    /usr/local/pkg/mailman/bin
    /usr/lib/mailman/bin
    /usr/local/pkg/mysql/bin
    /usr/local/pkg/pgsql/bin
    /usr/local/pkg/openldap/{bin,sbin}
    /opt/openldap/{bin,sbin}
    /usr/sfw/bin
    /opt/X11/bin
    /usr/X11R6/bin
    ~/tools
    ~/.cabal/bin
)

for path_candidate in $path_candidates; do
    [[ -d $path_candidate ]] && path+=$path_candidate
done

for path_file in /etc/paths.d/*(.N); do
    path+=($(<$path_file))
done
unset path_file

umask 022

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# fix terminal foo on Solaris
[[ $(uname -s) = "SunOS" ]] && export TERMINFO="$HOME/.terminfo"

if [[ -x /usr/local/bin/npm && -d /usr/local/lib/node_modules ]]; then
    export NODE_PATH='/usr/local/lib/node_modules'
fi

export PAGER='less'
export LESS='-g -i -M -r -w -X -x 4 -z-4'
export ACK_PAGER='less'

export CVS_RSH='ssh'

[[ -d /home/eng/.CVS ]] && export CVSROOT="/home/eng/.CVS"

# Avoid an RCS checkin log headache
[[ -n "$SUDO_USER" ]] && export LOGNAME="$SUDO_USER"

# freaking svn repo version conflicts...
if [[ -x /opt/gums/bin/svn ]]; then
    zstyle ':vcs_info:svn:*:-all-' command /usr/bin/svn
    alias svn='/usr/bin/svn'
fi

# no shared history, keep history per session
setopt no_share_history

# Show me time in GMT / UTC
alias utc='TZ=UTC date'
alias gmt='TZ=GMT date'

# Time in different places
alias jpdate='TZ=Asia/Tokyo date'
alias nldate='TZ=Europe/Amsterdam date'
alias fidate='TZ=Europe/Finland date'

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

alias pywebserver='python -m SimpleHTTPServer'

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

if [[ $UID -ne 0 ]]; then

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

# Execute code that does not affect the current session in the background.
{
    # Compile the completion dump to increase startup speed.
    dump_file="$HOME/.zcompdump"
    if [[ "$dump_file" -nt "${dump_file}.zwc" || ! -s "${dump_file}.zwc" ]]; then
        zcompile "$dump_file"
    fi

    # Set environment variables for launchd processes.
    if [[ "$OSTYPE" == darwin* ]]; then
        for env_var in PATH MANPATH; do
            if [ -x /usr/local/bin/reattach-to-user-namespace ]; then
                /usr/local/bin/reattach-to-user-namespace launchctl setenv "$env_var" "${(P)env_var}"
            else
                launchctl setenv "$env_var" "${(P)env_var}"
            fi
        done
    fi
} &!

# Make the prompt happy so I don't have $? true on every load
#__zsh_load_complete=1

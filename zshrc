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
    /usr/local/share/npm/bin
    /usr/local/{bin,sbin}
    /usr/{bin,sbin}
    /{bin,sbin}
    /usr/proc/bin
    /usr/lib/mailman/bin
    /opt/openldap/{bin,sbin}
    /usr/sfw/bin
    /opt/X11/bin
    /usr/X11R6/bin
    /opt/puppetlabs/bin
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

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# Good multiline git prompt
ZSH_THEME="kphoen"

# This theme has a multiline prompt and git integration
# ZSH_THEME="avit"

# This one feels homey, I'm used to it, but the colors aren't
# all great on a light background
# ZSH_THEME="steeef"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git common-aliases colored-man-pages vscode docker docker-compose)
# Possible ones to enable later:
# ssh-agent
# gpg-agent
# keychain

source $ZSH/oh-my-zsh.sh

# User configuration

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

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code -n -w'
fi

export VISUAL="$EDITOR"
export PAGER="less"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Turn off the completion security check. This thing complains about
# group/other-writable directories, but they're really symlinks that
# point to non-problematic directories (stuff in homebrew).
ZSH_DISABLE_COMPFIX="true"

if [[ -x /usr/local/bin/npm && -d /usr/local/lib/node_modules ]]; then
    export NODE_PATH='/usr/local/lib/node_modules'
fi

# Set the default Less options.
#
# For now just turn this off. It screws up git log. That annoys the heck
# out of me. Can add options back as needed, but any time adding one,
# need to check that it does not screw up git log. Symptom: in a git log
# where the first page has a line longer than the terminal width, the line
# will wrap, but that causes the first line to go off the top of the screen.
# It works fine if $LESS is not defined at all.
#
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
#
# Removed -S, don't want no-wrap by default (use less-nowrap for that)
# Added -x 4, to get 4-position as tab stop
# Removed -F, it doesn't play well in a loop where you less, then vim...
# Changed -R to -r because european accented letters were coming in as bracketed
#
#export LESS='-g -i -M -r -w -X -x 4 -z-4'
#export LESS="-R -i"
export LESS="-RiFX"

export ACK_PAGER="less"

export CVS_RSH="ssh"
[[ -d /home/eng/.CVS ]] && export CVSROOT="/home/eng/.CVS"

# Avoid an RCS checkin log headache
[[ -n "$SUDO_USER" ]] && export LOGNAME="$SUDO_USER"

export VIRTUAL_ENV_DISABLE_PROMPT=1
# Auto-activate virtualenv when entering directory
#_virtualenv_auto_activate() {
#    if [ -d "venv" ]; then
#        # Check to see if already activated to avoid redundant activating
#        if [ "$VIRTUAL_ENV" != "$(pwd -P)/venv" ]; then
#            export _VENV_NAME=${$(pwd):t}
#            echo Activating virtualenv \"$_VENV_NAME\"...
#            export VIRTUAL_ENV_DISABLE_PROMPT=1
#            source venv/bin/activate
#        fi
#    fi
#}

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias vi='vim'
alias view='vim -R'

# Show me time in GMT / UTC
alias utc='TZ=UTC date'
alias gmt='TZ=GMT date'

# Time in different places
alias jpdate='TZ=Asia/Tokyo date'
alias nldate='TZ=Europe/Amsterdam date'
alias fidate='TZ=Europe/Finland date'

# translate AS/RR numbers
astr() { echo "$1" | tr '[A-J0-9]' '[0-9A-J]' }

alias ack='ack --smart-case'

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

# fix ssh setup in a reattached tmux environment
fixssh() {
    for key in SSH_AUTH_SOCK SSH_CONNECTION SSH_CLIENT; do
        if (tmux show-environment | grep "^${key}" > /dev/null); then
            value=`tmux show-environment | grep "^${key}" | sed -e "s/^[A-Z_]*=//"`
            export ${key}="${value}"
        fi
    done
}

# http://perlbrew.pl
if [ -f ~/perl5/perlbrew/etc/bashrc ]; then
    source ~/perl5/perlbrew/etc/bashrc
fi

if [[ $UID -eq 0 ]]; then

    ### Things to do only if I am root

    # Messes with rdist and probably other stuff
    unset SSH_AUTH_SOCK

else

    ### Things to do only if I am not root

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
        tm() {
            [[ -z "$1" ]] && { tmux_ls; return }
            local _detach_flag
            if [[ "$1" = "-d" ]]; then
                _detach_flag="-d"
                shift
            fi
            export STY="[$1] $(uname -n)"
            tmux -u new -s "$1" || tmux -u att $_detach_flag -t "$1"
        }

    fi

fi

# Mac-specific things
if [[ "$(uname -s)" = "Darwin" ]]; then

    alias ldd='otool -L'

    # This shows which processes are using the network right now.
    alias netusers='lsof -P -i -n | cut -f 1 -d " " | uniq'

    # This lets you use the keychain for https urls in Git
    alias gitkeychain='git config credential.helper osxkeychain'

fi

# local settings override global ones
[[ -s $HOME/.zshrc.local ]] && source $HOME/.zshrc.local

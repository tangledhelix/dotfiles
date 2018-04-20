
# fix terminal foo on Solaris
[[ $(uname -s) = "SunOS" ]] && export TERMINFO="$HOME/.terminfo"

# Set the path to Oh My Zsh.
export OMZ="$HOME/.oh-my-zsh"

# Paths
typeset -gU cdpath fpath mailpath manpath path
typeset -gUT INFOPATH infopath

# Set the the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that info searches for manuals.
infopath=(
    /usr/local/share/info
    /usr/share/info
    $infopath
)

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

# Language
if [[ -z "$LANG" ]]; then
    eval "$(locale)"
fi

# Editors
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

# Browser (Default)
if [[ "$OSTYPE" == darwin* ]]; then
    export BROWSER='open'
elif [[ -n "$(command -v links)" ]]; then
    export BROWSER='links'
fi

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
export LESS="-R -i"

# Set the Less input preprocessor.
if (( $+commands[lesspipe.sh] )); then
    export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi

export ACK_PAGER='less'

export CVS_RSH='ssh'

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

prompt_steeef_precmd_plus_venv() {
    prompt_steeef_precmd
    #_virtualenv_auto_activate
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd prompt_steeef_precmd_plus_venv

# local settings override global ones
[[ -s $HOME/.zshenv.local ]] && source $HOME/.zshenv.local

__zshenv_load_complete=1


# Make sure bash can find .inputrc
test -n "$INPUTRC" || export INPUTRC="~/.inputrc"

# Collect some info about the local system
export HOST="$($uname -n)"
export OS="$($uname -s)"
test -n "$UNAME" || export UNAME="$($uname)"

# Tunnel CVS via SSH
export CVS_RSH="ssh"

export IRCNAME="dan"

# Erase duplicate entries from history
export HISTCONTROL="erasedups"

# Increase history size
export HISTSIZE="10000"

# For Python Pygments on Dreamhost
test -d "$HOME/local/pygments-install" && \
    export PYTHONPATH="$HOME/local/pygments-install"

#######################################################################
# Command search path

_rsort() {
    local _sort="/bin/sort"
    [[ -x /usr/bin/sort ]] && _sort="/usr/bin/sort"
    /bin/ls -d $1 2>/dev/null | $_sort -r
}

unset PATH

for _this in \
    ~/local/bin \
    ~/bin \
    ~/.rbenv/bin \
    $(_rsort "/usr/local/Cellar/ruby/*/bin") \
    ~/.gems/bin \
    $(_rsort "$HOME/.gem/ruby/*/bin") \
    /admin/bin \
    /usr/local/bin \
    /bin \
    /usr/bin \
    /usr/ccs/bin \
    /sbin \
    /usr/sbin \
    /usr/local/sbin \
    /usr/proc/bin \
    /usr/openwin/bin \
    /usr/dt/bin \
    /admin/tools/system \
    /admin/tools/mail/{bin,sbin} \
    /admin/config/auth/bin \
    /usr/local/pkg/perl/bin \
    /usr/local/pkg/ruby/bin \
    /usr/local/pkg/mailman/bin \
    /usr/lib/mailman/bin \
    /usr/local/pkg/mysql/bin \
    /usr/local/pkg/pgsql/bin \
    /usr/local/pkg/openldap/{bin,sbin} \
    /opt/openldap/{bin,sbin} \
    /usr/sfw/bin \
    /usr/X11R6/bin \
    $(_rsort "/usr/local/Cellar/python3/*/bin") \
    $(_rsort "/usr/local/Cellar/python/*/bin") \
    ~/tools
do
    test -d $_this && {
        test -n "$PATH" && PATH="$PATH:$_this" || PATH="$_this"
    }
done

export PATH

#######################################################################
# Now that PATH is set, detect the presence of various tools

HAVE_ACK=$(command -v ack 2>/dev/null)
HAVE_LESS=$(command -v less 2>/dev/null)
HAVE_MVIM=$(command -v mvim 2>/dev/null)
HAVE_SCREEN=$(command -v screen 2>/dev/null)
HAVE_TMUX=$(command -v tmux 2>/dev/null)
HAVE_VIM=$(command -v vim 2>/dev/null)
HAVE_VIMDIFF=$(command -v vimdiff 2>/dev/null)

#######################################################################
# Man page search path

unset MANPATH

for _this in \
    /usr/man \
    /usr/share/man \
    /usr/local/man \
    /usr/local/share/man \
    /usr/local/pkg/perl/man \
    /usr/dt/man \
    /usr/openwin/man \
    /usr/sfw/man \
    ~/local/man \
    ~/local/share/man
do
    test -d $_this && {
        test -n "$MANPATH" && MANPATH="$MANPATH:$_this" || MANPATH="$_this"
    }
done

export MANPATH

#######################################################################
# Editor

test -n "$HAVE_VIM" && EDITOR="$HAVE_VIM" || EDITOR="vi"
VISUAL="$EDITOR"
export EDITOR VISUAL

# Set vim paths
test -n "$HAVE_VIM" &&  {
    alias vi="$HAVE_VIM"
    alias vim="$HAVE_VIM"
    alias view="$HAVE_VIM -R"
}

# Set vim paths for diff mode
test -n "$HAVE_VIMDIFF" && {
    alias vimdiff="$HAVE_VIMDIFF -O"
    alias vdiff="$HAVE_VIMDIFF -O"
}

#######################################################################
# Pagers

# Options for less:
#   -F  Exit automatically if entire file fits on one screen
#   -i  Ignore case in searches (capitals are honored)
#   -r  Show raw control characters, instead of e.g. ^X
#   -R  Let ANSI color codes come through raw, others use ^X
#   -s  Squeeze consecutive blank lines into one line
#   -w  Hilight first new line on a new screenful
#
# NOTE: -F seems to break things on some systems I use; avoiding it.

if test -n "$HAVE_LESS" ; then
    PAGER="less -iRw"
    MANPAGER="less -iRsw"
    alias more="less"
    test -n "$HAVE_ACK" && {
        export ACK_PAGER="less -R"
        export ACK_PAGER_COLOR="less -R"
    }
else
    PAGER=more
    MANPAGER="$PAGER"
fi

LESS="-iRw"

export PAGER MANPAGER LESS

## Oracle

test -d /apps/oracle/product/9.2.0 &&
    export ORACLE_HOME="/apps/oracle/product/9.2.0"

test -d /apps/oracle/product/10.2.0 &&
    export ORACLE_HOME="/apps/oracle/product/10.2.0"

test -f ~/.rbenv/bin/rbenv && eval "$(rbenv init -)"


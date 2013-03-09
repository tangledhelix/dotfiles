
# "h" shows a tailed history
# "h <pattern>" shows all history entries matching the string
h() {
    test -n "$1" && { history | grep -i "$1"; } || { history | tail -15; }
}

# Make a directory, then go there
md() {
    test -n "$1" || return
    mkdir -p "$1" && cd "$1"
}

# "path" shows current path, one element per line.
# If an argument is supplied, grep for it.
path() {
    test -n "$1" && {
        echo $PATH | perl -p -e "s/:/\n/g;" | grep -i "$1"
    } || {
        echo $PATH | perl -p -e "s/:/\n/g;"
    }
}

# Run ssh and reset titlebar when it exits (so I don't have to
# close a window to get rid of 'puck', 'hagstrom' in the title bar).
ssh() {
    local _ssh="/usr/bin/ssh"
    test -x /usr/local/bin/ssh && _ssh="/usr/local/bin/ssh"
    $_ssh $@
    echo -ne "\x1b]2;$HOST\x07\x1b]1;$HOST\x07"
}

# Look up error codes
errno() {
    perl -e "\$! = $1; print \"\$! \\n\";"
}

# Machine type, on Solaris systems
hw() {
    [[ "$OS" != "SunOS" ]] && {
        echo "'hw' is only available in SunOS."
        return
    }
    /usr/platform/`/usr/bin/uname -m`/sbin/prtdiag | head -1 | \
        sed "s/^System Configuration: *Sun Microsystems *//" | \
        sed "s/^`/usr/bin/uname -m` *//"
}

# Translate AS numbers / RR communities
astr() {
    echo "$1" | tr "[A-J0-9]" "[0-9A-J]"
}

# Check if we're in a CVS repository
is_cvs_repository() {
    test -f ./CVS/Root > /dev/null 2>&1
}

# Check if we're in a Subversion repository
is_svn_repository() {
    test -d ./.svn > /dev/null 2>&1
}

# Check if we're in a Mercurial repository
is_hg_repository() {
    test -d ./.hg > /dev/null 2>&1
}

# Check if we're in a git repository
is_git_repository() {
    git branch > /dev/null 2>&1
}

# Figure out our SCM coloring.
_scm_color() {
    local _retval=$?
    local _git_status

    # Non-Git repos get colored all the same
    is_cvs_repository && { _xc 36; return $_retval; }
    is_svn_repository && { _xc 36; return $_retval; }
    is_hg_repository  && { _xc 36; return $_retval; }

    # If we got here and it's not a Git repo either, just bail
    is_git_repository || return $_retval

    # If we're still here, figure out the color we want to use
    _git_status="$(git status 2>/dev/null)"

    if [[ $_git_status =~ "working directory clean" ]]; then
        _xc 36
    elif [[ $_git_status =~ "Changes to be committed" ]]; then
        _xc 33
    else
        # something weird? go with red
        _xc 31
    fi

    return $_retval
}

# Look for code repositories. If git, show me the branch name. If CVS or
# Subversion, just show me the repo type (they don't have good branch info).
# Preserve the value of $? by returning it as we received it.
_scm_info() {
    local _retval=$?
    local _branch
    local _git_status
    local _pattern
    local _remote

    # If it's not Git, I don't bother with branches... just tell me type
    is_cvs_repository && { echo -n " (CVS)";        return $_retval; }
    is_svn_repository && { echo -n " (Subversion)"; return $_retval; }
    is_hg_repository  && { echo -n " (Mercurial)";  return $_retval; }

    # If we're still here, see if it's Git; if not, just bail
    is_git_repository || return $_retval

    _git_status="$(git status 2>/dev/null)"

    # Set arrow icon based on status against remote.
    _pattern="# Your branch is (.*) of"
    if [[ $_git_status =~ $_pattern ]]; then
        if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
            _remote="↑"
        else
            _remote="↓"
        fi
    fi
    _pattern="# Your branch and (.*) have diverged"
    if [[ $_git_status =~ $_pattern ]]; then
        remote="↕"
    fi

    # Get the name of the branch.
    _pattern="^# On branch ([^${IFS}]*)"
    if [[ $_git_status =~ $_pattern ]]; then
        _branch=${BASH_REMATCH[1]}
    fi

    # Output the prompt.
    echo -n " ($_branch)${_remote}"

    return $_retval
}

# Create a new git repo in cwd
gitinit() {
    git init
    printf ".DS_Store\n.*.swp\n*~\n" > .gitignore
    git add .gitignore
    git ci -m "initializing repo" .gitignore
}

# Give me a shortened version of the local hostname.
# If it's 1-3 atoms, give me only the first.
# If it's more than that, give me the first two.
# Preserve the value of $? by returning it as we received it.
_short_hname() {
    local _retval=$?

    echo $HOST | perl -p -e "
        if (scalar(split(/\./)) > 3) {
        s/^([^.]+\.[^.]+).*$/\$1/;
        } else {
        s/^([^.]+).*$/\$1/;
        }
    "

    # Alternate version from Ravi Pina. Much shorter, but it gives
    # you three atoms on long names, not two, and on a single
    # atom it doesn't return anything at all.
    #perl -le '$ENV{HOST}=~/^((?:[^.]+\.){2}[^.]+|[^.]+)\./;print$1'

    return $_retval
}

# Check to see if I have local mail on this system. If mail is waiting,
# output a few chars that are supposed to resemble an envelope.
_check_for_mail() {
    local _retval=$?
    local _mail_cmd

    _mail_cmd=$(command -v mail 2>/dev/null)

    test -n "$_mail_cmd" && {
        $_mail_cmd -e >/dev/null 2>&1
        [[ $? -eq 0 ]] && echo -n "|><| "
    }

    return $_retval
}

# Output a color.
# Preserve the value of $? by returning it as we received it.
_xc() {
    local _retval=$?
    echo -ne "\033[$1m"
    return $_retval
}

# Make the colored text underscored
_xcu() {
    local _retval=$?
    echo -ne "\033[$1;4m"
    return $_retval
}

# Make the foreground color bold (bright) instead of normal.
# Preserve the value of $? by returning it as we received it.
_xcb() {
    local _retval=$?
    echo -ne "\033[1;$1m"
    return $_retval
}

# Set back to normal colors (reset).
# Preserve the value of $? by returning it as we received it.
_xcr() {
    local _retval=$?
    echo -ne "\033[0m"
    return $_retval
}

# Evaluate $? and return an attention-grabbing color if non-zero.
# Preserve the original value of $? by returning it as we received it.
# 31 = red
# 7 = reverse
_xc_retval() {
    local _retval=$?
    [[ $_retval != 0 ]] && echo -ne "\033[31;7m"
    return $_retval
}

# Get job count, return an attention grabbing color if there are > 0.
# Preserve the original value of $? by returning it as we received it.
# 31 = red
_xc_jobs() {
    local _retval=$?
    local _jobcount=`jobs | wc -l`
    [[ $_jobcount -gt 0 ]] && _xc 31
    return $_retval
}

# Used by ff(), fd()... execute a find command, possible filtering results
_finder() {
    local _type="$1"
    local _include="$2"
    local _exclude="$3"

    test -n "$_type" || return

    if [[ -n "$_exclude" ]]; then
        find . -type $_type -print | grep -i "$_include" | grep -vi "$_exclude"
    elif [[ -n "$_include" ]]; then
        find . -type $_type -print | grep -i "$_include"
    else
        find . -type $_type -print
    fi
}

# Show file tree, optionally filtering results
ff() {
    if [[ "$1" =~ ^\(-h\|--help\) ]]; then
        echo "Usage: ff [<include-pattern>] [<exclude-pattern>]"
        return
    fi

    _finder f "$1" "$2"
}

# Show directory tree, optionally filtering results
fd() {
    if [[ "$1" =~ ^\(-h\|--help\) ]]; then
        echo "Usage: fd [<include-pattern>] [<exclude-pattern>]"
        return
    fi

    _finder d "$1" "$2"
}

# Set a window title
set_window_title() {
    echo -ne "\033]2;$1\a"
}

# alias for set_window_title
title() {
    set_window_title "$1"
}

# Set an iTerm2 *tab* title independent of window title
set_tab_title() {
    echo -ne "\033]1;$1\a"
}

# Set both window and tab titles
set_titles() {
    set_window_title "$1"
    set_tab_title "$1"
}

# Steal focus
steal_focus() {
    echo -ne "\033]50;StealFocus\a"
}

# Tell me the installed version of a Perl module.
perlmodver() {
    local _module="$1"

    test -n "$_module" || { echo "missing argument"; return; }
    perl -M$_module -e "print \$$_module::VERSION,\"\\n\";"
}

# Move backward through the directory tree easily. When called without
# an argument, goes back one level ('cd ..'). When called with a numeric
# argument, goes back that many levels.
#       '_cdback 2' == 'cd ../..'
#       '_cdback 3' == 'cd ../../..'
#       '_cdback 4' == 'cd ../../../..'
# When called with an optional second argument, cd's to that directory
# after having backed out $1 levels
_cdback() {
    local _count
    test -n "$1" && _count="$1" || _count="1"
    while [[ "$_count" > 0 ]]; do
        cd ..
        _count=$((_count - 1))
    done
    test -n "$2" && cd "$2"
}

# Test for a perl module and print its version if any.
pmver() {
    local _module="$1"

    if [[ -z "$_module" ]]; then
        echo "Missing argument (module name)"
        return
    fi

    perl -M$_module -e "print \"\$${_module}::VERSION\n\";"
}

# Beep the terminal. If a time is specified, wait that number
# of seconds, then beep.
beep() {
    test -n "$1" && sleep $1
    echo -ne "\a"
}

# Make a new puppet module
mkpuppetmodule() {
    [[ -d $1 ]] && { echo "directory '$1' already exists"; return; }
    mkdir -p $1/{files,templates,manifests}
    cd $1/manifests
    [[ -f init.pp ]] && { echo "init.pp exists, not creating it."; return; }
    printf "\nclass $1 {\n\n}\n\n" > init.pp
    $EDITOR +3 init.pp
}

# Get a short URL for GitHub
gitshorturl() {
    test -z "$1" && { echo "Usage: gitshorturl <url> [<code>]"; return; }
    test -n "$2" && {
        curl -i http://git.io -F "url=$1" -F "code=$2"
    } || {
        curl -i http://git.io -F "url=$1"
    }
}

# Fix ssh variables inside tmux sessions
function fixssh() {

    if [[ -n "$TMUX" ]]; then

        NEW_SSH_CLIENT="`tmux showenv|grep ^SSH_CLIENT|cut -d = -f 2`"
        if [[ -n "$NEW_SSH_CLIENT" ]]; then
            export SSH_CLIENT="$NEW_SSH_CLIENT"
        fi

        NEW_SSH_TTY="`tmux showenv|grep ^SSH_TTY|cut -d = -f 2`"
        if [[ -n "$NEW_SSH_TTY" ]]; then
            export SSH_TTY="$NEW_SSH_TTY"
        fi

        NEW_SSH_AUTH_SOCK="`tmux showenv|grep ^SSH_AUTH_SOCK|cut -d = -f 2`"
        if [[ -n "$NEW_SSH_AUTH_SOCK" ]] && [[ -S "$NEW_SSH_AUTH_SOCK" ]]; then
            export SSH_AUTH_SOCK="$NEW_SSH_AUTH_SOCK"
        fi

        NEW_SSH_CONNECTION="`tmux showenv|grep ^SSH_CONNECTION|cut -d = -f 2`"
        if [[ -n "$NEW_SSH_CONNECTION" ]]; then
            export SSH_CONNECTION="$NEW_SSH_CONNECTION"
        fi

        unset NEW_SSH_CLIENT NEW_SSH_TTY NEW_SSH_CONNECTION NEW_SSH_AUTH_SOCK

    fi

}


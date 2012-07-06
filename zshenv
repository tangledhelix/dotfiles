#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# fix terminal foo on Solaris
export TERMINFO="$HOME/.terminfo"

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
  $manpath
)

for path_file in /etc/manpaths.d/*(.N); do
  manpath+=($(<$path_file))
done
unset path_file

# Set the list of directories that Zsh searches for programs.
path=()

path_candidates=(
  ~/local/bin
  ~/bin
  ~/.rbenv/bin
  ~/.gems/bin
  /admin/bin
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
  /usr/X11R6/bin
  ~/tools
)

for path_candidate in $path_candidates; do
  [[ -d $path_candidate ]] && path+=$path_candidate
done

# homebrew
if [[ -d /usr/local/Cellar ]]; then
  path+=$(echo /usr/local/Cellar/ruby/*/bin)
  path+=$(echo /usr/local/Cellar/python3/*/bin)
  path+=$(echo /usr/local/Cellar/python/*/bin)
fi

for path_file in /etc/paths.d/*(.N); do
  path+=($(<$path_file))
done
unset path_file

# Language
if [[ -z "$LANG" ]]; then
  eval "$(locale)"
fi

# Editors
export EDITOR="vim"
export VISUAL="vim"
export PAGER="less"

# Browser (Default)
if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
elif [[ -n "$(command -v links)" ]]; then
  export BROWSER='links'
fi

if [[ -x /usr/local/bin/npm && -d /usr/local/lib/node_modules ]]; then
  export NODE_PATH="/usr/local/lib/node_modules"
fi

test -d /apps/oracle/product/9.2.0 &&
    export ORACLE_HOME="/apps/oracle/product/9.2.0"

test -d /apps/oracle/product/10.2.0 &&
    export ORACLE_HOME="/apps/oracle/product/10.2.0"

# Less

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
#
# Removed -S, don't want no-wrap by default (use less-nowrap for that)
export LESS="-F -g -i -M -R -w -X -z-4"

# Set the Less input preprocessor.
if (( $+commands[lesspipe.sh] )); then
  export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi

export ACK_PAGER="less"

export CVS_RSH="ssh"


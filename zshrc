#
# Sets Oh My Zsh options.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Set the key mapping style to 'emacs' or 'vi'.
zstyle ':omz:module:editor' keymap 'vi'

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
# zstyle ':omz:load' zfunction 'zargs' 'zmv'

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
  'syntax-highlighting' \
  'history-substring-search' \
  'prompt'

# Set the prompt theme to load.
# Setting it to 'random' loads a random theme.
# Auto set to 'off' on dumb terminals.
zstyle ':omz:module:prompt' theme 'tangledhelix'

# This will make you shout: OH MY ZSHELL!
source "$OMZ/init.zsh"

# Customize to your needs...

# after ssh, set the title back to local host's name
ssh() {
  if [[ -x /usr/local/bin/ssh ]]; then
    /usr/local/bin/ssh $@
  else
    /usr/bin/ssh $@
  fi
  set-tab-title $(uname -n)
}

if [[ -n "$(command -v tmux)" ]]; then
  alias tmux='tmux -u'
  alias tls='tmux ls'

  tnew() {
    [[ -z "$1" ]] && { echo 'missing session name'; return }
    set-tab-title "tmux:$1"
    tmux -u new -s $1
    set-tab-title $(uname -n)
  }

  tatt() {
    [[ -z "$1" ]] && { echo 'missing session name'; return }
    set-tab-title "tmux:$1"
    tmux -u attach -t $1
    set-tab-title $(uname -n)
  }

fi

alias vi='vim'
alias view='vim -R'
alias vimdiff='vimdiff -O'

alias c='clear'
alias ppv='puppet parser validate'

# print the directory structure from the current directory in tree format
alias dirf="find . -type d|sed -e 's/[^-][^\/]*\//  |/g' -e 's/|\([^ ]\)/|-\1/'"

# Show me time in GMT / UTC
alias utc='TZ=UTC date'
alias gmt='TZ=GMT date'
# Time in Tokyo
alias jst='TZ=Asia/Tokyo date'

# show me platform info
alias os='uname -srm'

hw() {
  [[ "$(uname -s)" != 'SunOS' ]] && { echo 'This is not Solaris...'; return }
  /usr/platform/$(uname -m)/sbin/prtdiag | /usr/bin/head -1 | \
    sed 's/^System Configuration: *Sun Microsystems *//' | \
    sed 's/^$(uname -m) *//'
}

# translate AS/RR numbers
astr() {
  echo "$1" | tr '[A-J0-9]' '[0-9A-J]'
}

# show me installed version of a perl module
perlmodver() {
  local __module="$1"
  [[ -n "$__module" ]] || { echo 'missing argument'; return; }
  perl -M$__module -e "print \$$__module::VERSION,\"\\n\";"
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

# fabricate a puppet module directory set
mkpuppetmodule() {
  [[ -d "$1" ]] && { echo "'$1' already exists"; return }
  mkdir -p $1/{files,templates,manifests}
  cd $1/manifests
  printf "\nclass $1 {\n\n}\n\n" > init.pp
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

# fix ssh variables inside tmux
fixssh() {
  local _new
  if [[ -n "$TMUX" ]]; then
    _new=$(tmux showenv | grep '^SSH_CLIENT' | cut -d = -f 2)
    [[ -n "$_new" ]] && export SSH_CLIENT="$_new"
    _new=$(tmux showenv | grep '^SSH_TTY' | cut -d = -f 2)
    [[ -n "$_new" ]] && export SSH_TTY="$_new"
    _new=$(tmux showenv | grep '^SSH_CONNECTION' | cut -d = -f 2)
    [[ -n "$_new" ]] && export SSH_CONNECTION="$_new"
    _new=$(tmux showenv | grep '^SSH_AUTH_SOCK' | cut -d = -f 2)
    [[ -n "$_new" && -S "$_new" ]] && export SSH_AUTH_SOCK="$_new"
  fi
}

# count something fed in on stdin
alias count='sort | uniq -c | sort -n'

# Strip comment / blank lines from an output
alias stripcomments="egrep -v '^([\ \t]*#|$)'"

alias ack='ack --smart-case'

# Give me a list of the RPM package groups
alias rpmgroups='cat /usr/share/doc/rpm-*/GROUPS'

# Watch Puppet logs
alias tailpa='tail -F /var/log/daemon/debug | grep puppet-agent'
alias tailpm='tail -F /var/log/daemon/debug | grep puppet-master'

# Get my current public IP
alias get-ip='curl --silent http://icanhazip.com'

# less with no-wrap (oh-my-zsh default, could be useful sometimes)
alias less-nowrap='less -S'

if [[ $UID -eq 0 ]]; then

  ### Things to do only if I am root

  # Messes with rdist
  unset SSH_AUTH_SOCK

else

  ### Things to do only if I am not root

  set-tab-title $(uname -n)

  [[ -f ~/.rbenv/bin/rbenv ]] && eval "$(rbenv init -)"

  # Check for broken services on SMF-based systems
  [[ -x /bin/svcs ]] && svcs -xv

  # Create some Vim cache directories if they don't exist.
  mkdir -p ~/.vim/tmp/{undo,backup,swap}

  # fix yankring permissions
  __yankring="$HOME/.vim/yankring_history_v2.txt"
  if [[ -f $__yankring ]]; then
    if [[ ! -O $__yankring ]]; then
      echo 'WARNING: yankring history file is not writeable'
    else
      chmod 0600 $__yankring
    fi
  else
    touch $__yankring
    chmod 0600 $__yankring
  fi

  # List tmux sessions
  if [[ -n "$(command -v tmux)" && -z "$TMUX" ]]; then
    if [[ -n "$(tmux ls 2>/dev/null)" ]]; then
      echo "\n\x1b[1;37m-- tmux sessions --\n$(tmux ls 2>/dev/null)\x1b[0m"
    fi
  fi

fi

# local settings override global ones
[[ -s $HOME/.zshrc.local ]] && source $HOME/.zshrc.local

# Make the prompt happy so I don't have $? true on every load
__zsh_load_complete=1


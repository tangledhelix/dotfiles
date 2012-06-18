#
# Sets Oh My Zsh options.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Set the key mapping style to 'emacs' or 'vi'.
zstyle ':omz:module:editor' keymap 'vi'

# Auto convert .... to ../..
zstyle ':omz:module:editor' dot-expansion 'no'

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
zstyle ':omz:load' omodule \
  'environment' \
  'terminal' \
  'editor' \
  'history' \
  'directory' \
  'spectrum' \
  'utility' \
  'completion' \
  'prompt' \
  'git' \
  'history-substring-search'

# Set the prompt theme to load.
# Setting it to 'random' loads a random theme.
# Auto set to 'off' on dumb terminals.
# zstyle ':omz:module:prompt' theme 'sorin'
# zstyle ':omz:module:prompt' theme 'nicoulaj'
# zstyle ':omz:module:prompt' theme 'steeef'
zstyle ':omz:module:prompt' theme 'tangledhelix'

# This will make you shout: OH MY ZSHELL!
source "$OMZ/init.zsh"

# Customize to your needs...

HAVE_TMUX=$(command -v tmux)
test -n "$HAVE_TMUX" && alias tmux="$HAVE_TMUX -u"

ssh() {
  if [[ -x /usr/local/bin/ssh ]]; then
    /usr/local/bin/ssh $@
  else
    /usr/bin/ssh $@
  fi
  printf "\x1b]2;$(uname -n)\x07\x1b]1;$(uname -n)\x07"
}

# set title
printf "\x1b]2;$(uname -n)\x07\x1b]1;$(uname -n)\x07"

alias c='clear'
alias ppv='puppet parser validate'

# print the directory structure from the current directory in tree format
alias dirf="find . -type d|sed -e 's/[^-][^\/]*\//  |/g' -e 's/|\([^ ]\)/|-\1/'"

# Show me time in GMT / UTC
alias utc="TZ=UTC date"
alias gmt="TZ=GMT date"
# Time in Tokyo
alias jst="TZ=Asia/Tokyo date"

alias os="uname -srm"

test -s $HOME/.zshrc.local && source $HOME/.zshrc.local


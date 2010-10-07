
# detect interactive shells
case "$-" in
    *i*) INTERACTIVE=yes ;;
    *)   unset INTERACTIVE ;;
esac

source ~/.bash/environment
source ~/.bash/colordefs
source ~/.bash/config
source ~/.bash/aliases
source ~/.bash/functions
source ~/.bash/mac
source ~/.bash/ntt
source ~/.bash/hostname-completion
source ~/.bash/project-mgmt
source ~/.bash/non-root

test -f ~/.bashrc.local && source ~/.bashrc.local

test -f ~/.bash_profile.local && echo "   === .bash_profile.local exists ==="

# Make $? happy so new shells don't always start with {1} in the prompt.
test "true"


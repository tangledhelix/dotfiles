
# detect interactive shells
case "$-" in
	*i*) INTERACTIVE=yes ;;
	*) unset INTERACTIVE ;;
esac

source ~/.bash/environment
source ~/.bash/functions
source ~/.bash/config
source ~/.bash/aliases
source ~/.bash/mac
source ~/.bash/completion
source ~/.bash/project-mgmt
source ~/.bash/non-root

test -f ~/.bashrc.local && source ~/.bashrc.local

# Look for older .bash_profile.local files, warn me if one exists
test -f ~/.bash_profile.local && echo "   === .bash_profile.local exists ==="

# Make $? happy so new shells don't always start with {1} in the prompt
test "true"

#test -f ~/.bashrc.local && source ~/.bashrc.local

## Look for older .bash_profile.local files, warn me if one exists
#test -f ~/.bash_profile.local && echo "   === .bash_profile.local exists ==="

## Make $? happy so new shells don't always start with {1} in the prompt
#test "true"


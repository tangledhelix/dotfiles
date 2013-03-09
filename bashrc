
# detect interactive shells
case "$-" in
    *i*) INTERACTIVE='yes' ;;
    *) unset INTERACTIVE ;;
esac

source ~/.bash/environment.sh
source ~/.bash/function.sh
source ~/.bash/config.sh
source ~/.bash/alias.sh
source ~/.bash/mac.sh
source ~/.bash/completion.sh
source ~/.bash/project-mgmt.sh
source ~/.bash/non-root.sh

test -f ~/.bashrc.local && source ~/.bashrc.local

# Look for older .bash_profile.local files, warn me if one exists
test -f ~/.bash_profile.local && echo '   === .bash_profile.local exists ==='

# Make $? happy so new shells don't always start with {1} in the prompt
test 'true'


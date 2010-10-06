
# detect interactive shells
case "$-" in
    *i*) INTERACTIVE=yes ;;
    *)   unset INTERACTIVE ;;
esac

source ~/.bash/environment
source ~/.bash/general
source ~/.bash/aliases
source ~/.bash/functions
source ~/.bash/mac
source ~/.bash/ntt
source ~/.bash/hostname-completion
source ~/.bash/project-mgmt
source ~/.bash/non-root

test -f ~/.bashrc.local && source ~/.bashrc.local

test -f ~/.bash_profile.local && echo "   === .bash_profile.local exists ==="

# to look into:

# put the current git branch in your prompt
#parse_git_branch() {
#    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
#}

#export PS1="\[\033[00m\]\u@\h\[\033[01;34m\] \W \[\033[31m\]\$(parse_git_branch) \[\033[00m\]$\[\033[00m\] "
# 

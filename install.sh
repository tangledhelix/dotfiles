#!/bin/sh
#
# For unenlightened systems where ruby and rake are not available.

for item in bash bash_profile bashrc cvsrc emacs gitignore inputrc \
	ircrc screenrc tcshrc terminfo vim vimrc
do
	if [ -r $HOME/.$item ]; then
		echo "*** WARNING: $HOME/.$item already exists"
	else
		echo "* .$item => .dotfiles/$item"
		ln -s $HOME/.dotfiles/$item $HOME/.$item
	fi
done

if [ -r $HOME/.gitconfig ]; then
	echo "*** WARNING: $HOME/.gitconfig already exists"
else
	echo
	echo "*** NOTE: set up $HOME/.gitconfig"
	echo
	cp $HOME/.dotfiles/gitconfig.erb $HOME/.gitconfig
	chmod 0600 $HOME/.gitconfig
fi


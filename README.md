
About
-----

This repository contains my personal dotfiles, which I use on unix systems of
varying flavors. They are published here because I occasionally want to share
them or use them as examples, and this is an easy way to do so. Feel free to
use anything you find here.

Compatibility
-------------

I am a bash user; much of the shell environment may well work in other advanced
Bourne derivatives such as zsh, but some of it will break.

I regularly use this setup with Mac OS X, Solaris, Linux and FreeBSD systems.

Some parts of the Bash and Vim configs assume you have 256 color support in
your terminal. If you are using Apple Terminal, you may not. Try iTerm2 instead.

<http://sites.google.com/site/iterm2home/>

Installation
------------

	git clone https://github.com/tangledhelix/dotfiles ~/.dotfiles
	cd ~/.dotfiles
	rake install
	git submodule init
	git submodule update

Rake will ask you before overwriting any files that already exist.

Submodules
----------

Because there are submodules, and some will end up generating vim docs "tags"
files, you may end up seeing stuff like this, which gets annoying:

	dan@mercury{0}[0]$ git status
	# On branch master
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#   (commit or discard the untracked or modified content in submodules)
	#
	#       modified:   vim/bundle/L9 (untracked content)
	#       modified:   vim/bundle/fuzzyfinder (untracked content)
	#       modified:   vim/bundle/nerd_commenter (untracked content)
	#       modified:   vim/bundle/snipmate (untracked content)
	#       modified:   vim/bundle/surround (untracked content)
	#       modified:   vim/bundle/unimpaired (untracked content)
	#       modified:   vim/bundle/yankring (untracked content)
	#
	no changes added to commit (use "git add" and/or "git commit -a")

I have an alias that knows how to ignore submodules. This will not work in older
versions of git. It works with the version I use (1.7.3.1).

	alias gs='git status --ignore-submodule'


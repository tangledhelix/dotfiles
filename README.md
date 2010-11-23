
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
your terminal. If you are using Apple Terminal, you may not. Try iTerm instead.

<http://iterm.sourceforge.net/>

Installation
------------

	git clone https://github.com/tangledhelix/dotfiles ~/.dotfiles
	cd .dotfiles
	git submodule init
	git submodule update
	rake install

Rake will ask you before overwriting any files that already exist.


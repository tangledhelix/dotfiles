
About
-----

This repo contains my personal dotfiles, which I use on unix and unix-like
systems of varying flavors. They are published here because occasionally
I want to share some or all of them, or use them as an example, and this
is an easy way to do so.

Bash-related files
------------------

* bash_profile
* bashrc
* bash/*
* inputrc (readline)

Vim-related files
-----------------

* vimrc
* gvimrc
* vim/*

The makelinks script
--------------------

I use the 'makelinks' script to symlink many of these files back into $HOME.
It's a primitive script and perhaps destructive. It works for my purposes,
but please know what you are doing before you attempt to use it. I will not
take any responsibility for what happens if you run it without reading it
first.

I don't use the more commonly used 'rake install' becasue many systems I
use routinely do not have Ruby installed. Yeah, yeah, I know.


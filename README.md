
About
-----

This repository contains my personal dotfiles, which I use on unix systems of varying flavors. They are published here because I occasionally want to share them or use them as examples, and this is an easy way to do so. Feel free to use anything you find here.

Note however, that I do not make any particular effort to make this easy for others to use. I randomly move things around, add and remove Vim bundles, according to my needs. If you want to use these dotfiles, I would definitely suggest forking them to your own repo so you can selectively merge changes as you see fit. YMMV.

Compatibility
-------------

I am a Zsh user. This repo goes in conjunction with my [fork of oh-my-zsh][zfork]. If you want to use zsh, I suggest cloning that repo into `~/.oh-my-zsh` and installing the `.z*` files from this repo.

[zfork]: https://github.com/tangledhelix/oh-my-zsh

You can use `rake install:zsh` to install my Zsh setup.

Using Bash does not need any external repos. Use `rake install:bash` to install my Bash setup. I used Bash for many years, and those files are fairly mature, but I am no longer paying a lot of attention to them.

I regularly use this setup with Mac OS X, Solaris, Linux and FreeBSD systems.

Some parts of the Bash, Zsh, and Vim configs may assume you have 256 color support in your terminal. If you are using Apple Terminal before OS X Lion, you don't. Try iTerm2 instead.

http://sites.google.com/site/iterm2home/

I have written two blog posts on the subject of iTerm and iTerm2. Give them a read; color support is only one of several good reasons to switch.

http://tangledhelix.com/blog/2010/11/20/iterm-terminal/

http://tangledhelix.com/blog/2010/12/06/iterm2-iterm/

Shell colors
------------

The colors in the shell prompts for both Bash and Zsh are currently set up assuming the terminal is using [Solarized][] (light) as a color scheme. They may not look very good in other terminal setups.

[solarized]: http://ethanschoonover.com/solarized

The Zsh setup lets you pick from multiple prompts. Run `prompt -l` to see them, and set what you like in `~/.zshrc`.

Installation
------------

	umask 0022
	git clone https://github.com/tangledhelix/dotfiles.git ~/.dotfiles

To install my dotfiles as *your* dotfiles, you can create symlinks with `rake`. If you do *not* run the rake command, everything will be isolated inside of the `.dotfiles` directory and will not interfere with your existing environment.

	rake install:all

Rake will ask you before overwriting any files that already exist.

You can also install subsets of the environment using one of the following.

	rake install:bash
	rake install:zsh
	rake install:vim
	rake install:git

Updating
--------

I periodically change the Vim bundles I use. There are two rake tasks for Vim.

The first updates the bundles from their repositories.

	rake update:vim

The second cleans up any bundles which are no longer known to `Rakefile`.

	rake cleanup:vim


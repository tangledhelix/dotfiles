
About
-----

This repository contains my personal dotfiles, which I use on unix systems of varying flavors, and on my Macs. They are published here because I occasionally want to share them or use them as examples, and this is an easy way to do so. Feel free to use anything you find here.

Note however, that I do not make any particular effort to make this easy for others to use. I randomly move things around, add and remove Vim bundles, according to my needs. If you want to use these dotfiles, I would definitely suggest forking them to your own repo so you can selectively merge changes as you see fit. YMMV.

Compatibility
-------------

I am a Zsh user. This repo goes in conjunction with [Oh My Zsh](https://ohmyz.sh).

I have used this setup with macOS, Solaris, FreeBSD, and Linux systems. Today I primarily use macOS and Linux (Debian and Redhat families).

Some parts of the Zsh and Vim configs may assume you have 256 color support in your terminal. If you are using Apple Terminal before OS X Lion, you don't. Try [iTerm2][] instead.

[iterm2]: http://sites.google.com/site/iterm2home/

I have written two blog posts on the subject of iTerm and iTerm2. Give them a read; color support is only one of several good reasons to switch.

[iTerm > Terminal](http://tangledhelix.com/blog/2010/11/20/iterm-terminal/)

[iTerm2 > iTerm](http://tangledhelix.com/blog/2010/12/06/iterm2-iterm/)

Shell colors
------------

The colors in the Zsh shell prompts may assume a certain color scheme in the terminal; they may look odd in other schemes. I change that color decision on a whim and may forget to update this README.

Installation
------------

I used to use a Perl script to install, but it's been unmaintained for a long time, so I deleted it. I'm using Ansible now.

The Ansible setup requires a `hosts` inventory file. That is not present in this repository as it's specific to me. See Ansible's documentation for info about the format of the inventory file. (There is more than one available format.)

To install or update the Vim bundles, use the install.pl script. The list of Vim bundles is defined in that script. If you modify the list, you'll want to do an update (and maybe a cleanup, if you removed any modules.)

    ./install.pl update:vim

To clean up old Vim bundles, if you removed any from the list:

    ./install.pl cleanup:vim

Note this will just update the repository copy. To install them, use the Ansible playbook. Anything in the bundle directory will be installed on the target.


# About

This repository contains my personal dotfiles, which I use on unix systems of
varying flavors, and on my Macs. They are published here because I occasionally
want to share them or use them as examples, and this is an easy way to do so.
Feel free to use anything you find here.

Note however, that I do not make any particular effort to make this easy for
others to use. I randomly move things around, add and remove Vim bundles,
according to my needs. If you want to use these dotfiles, I would definitely
suggest forking them to your own repo so you can selectively merge changes as
you see fit. YMMV.

# Requirements

I use Ansible to deploy my shell files, that's just about the only requirement.
If you want to use my Vim module updater, that's written in Python 3.

# Compatibility

I am a Zsh user. This repo goes in conjunction with
[Oh My Zsh](https://ohmyz.sh). It'll work fine if you use Bash or another
shell, it just won't do anything to set those shells up.

I'm a Vim/Neovim user. If you use Emacs or something else, same as with Zsh...
not a problem, but you won't get much Emacs functionality from these dotfiles.

I use this setup with macOS, and Linux (RHEL, CentOS, Debian, Ubuntu).

Some parts of the Zsh and Vim configs may assume you have 256 color support in
your terminal. If you are using Apple Terminal before OS X Lion, you don't. Try
[iTerm2][] instead.

[iterm2]: http://sites.google.com/site/iterm2home/

I have written two blog posts on the subject of iTerm and iTerm2. Give them
a read; color support is only one of several good reasons to switch.

[iTerm > Terminal](http://tangledhelix.com/blog/2010/11/20/iterm-terminal/)

[iTerm2 > iTerm](http://tangledhelix.com/blog/2010/12/06/iterm2-iterm/)

# Installation

I use Ansible to deploy my dotfiles. This setup requires an inventory file.
That is not present in this repository as it's specific to me. See Ansible's
documentation for info about the format of the inventory file. (There is more
than one available format.) I keep my inventory files in the `inventory/`
directory, and the default paths is assumed to be `inventory/hosts`.

## Git setup

I use a file `vars/gituser.yml` to define the .gitconfig `user.name` and
`user.email` settings. That's so I can have a different value on my work
laptop and personal laptop. This file is required, but isn't tracked in
git. It looks like this:

```yaml
gituser_name: "John Doe"
gituser_email: "jdoe@example.com"
```

## Vim

To install or update the Vim bundles, use the `update_vim.py` script. The list
of Vim bundles is defined in that script. If you modify the list, you'll want
to do an update. This will refresh existing modules, install new ones, and
clean out old ones no longer in the list.

    ./update_vim.py

Note this will just update the repository copy. To install them, use the
Ansible playbook. Anything in the bundle directory will be installed on the
target.

## Neovim

I'm a fan of [Neovim][], but unfortunately on most servers it's still pretty
old on LTS versions. So I only push Neovim setup to local (which in my case
means macOS).

If you'd like to use my Neovim setup, push it wherever you want. Then run
`:PackerSync` inside nvim to install the plugins. You might have to do it a few
times to do the initial installation.

My full Neovim setup assumes Neovim 0.8, but if you're on an earlier version,
it will try to degrade gracefully by selectively omitting plugins to install
that aren't compatible.

Some of my plugins have underlying requirements. You can install this using
your usual package manager, like `apt` on Ubuntu or `brew` on macOS.

* tree-sitter for AST-based syntax highlighting
* ripgrep for the telescope fuzzy finder

If you're interested in Neovim, you can find plenty of videos on Youtube
to help you get started. The most entertaining one is [ThePrimeagen][],
but there are plenty of others.

[neovim]: https://neovim.io/
[theprimeagen]: https://www.youtube.com/channel/UC8ENHE5xdFSwx71u3fDH5Xw

## Ansible host manifest

A minimal Ansible hosts file for your local system looks like this.

    [all]
    localhost

A typical Ansible deploy to localhost looks something like this.

    ansible-playbook -K -i inventory/hosts -l localhost site.yml

I don't want to write yet another Ansible tutorial so if you want to know more
about Ansible or playbooks, you can look up Ansible's documentation for those
things.


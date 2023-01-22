#!/usr/bin/env python3

# Assumes Github repos. Use shorthand "user/repo-name".
vim_bundles = {
    # insert and delete parens, braces, etc in pairs
    "autopairs": "jiangmiao/auto-pairs",
    # automatically adds ending keyword to blocks (end, endif, ...)
    "endwise": "tpope/vim-endwise",
    # github-flavored markdown plugin
    "ghmarkdown": "jtratner/vim-flavored-markdown",
    # PaperColor theme, based on Material
    "papercolor": "NLKNguyen/papercolor-theme",
    # Vim plugin manager
    "pathogen": "tpope/vim-pathogen",
    # support for Perl
    "perl": "vim-perl/vim-perl",
    # postgres-flavored SQL support
    "pgsql": "exu/pgsql.vim",
    # puppet configuration management server
    "puppet": "rodjek/vim-puppet",
    # status line
    "statline": "millermedeiros/vim-statline",
    # change surrounding things (quotes, parens, etc)
    "surround": "tpope/vim-surround",
    # easily comment / uncomment lines, blocks, selections...
    "tcomment": "tomtom/tcomment_vim"
}

import os
import shutil

dir_path = os.path.dirname(os.path.realpath(__file__))
bundle_path = dir_path + "/roles/vim/files/vim/bundle"

if not os.path.isdir(bundle_path):
    print("=> Creating bundle path")
    os.mkdir(bundle_path)
os.chdir(bundle_path)

# Clean up old bundles no longer in our list
for filename in os.listdir():
    if filename not in vim_bundles:
        print("=> Removing {}".format(filename))
        shutil.rmtree(filename)

for bundle in vim_bundles:
    url = "https://github.com/" + vim_bundles[bundle] + ".git"
    if os.path.isdir(bundle):
        print("=> Updating {}".format(bundle))
        os.chdir(bundle)
        os.system("git pull")
        os.chdir("..")
    else:
        print("=> Installing {}".format(bundle))
        os.system("git clone {} {}".format(url, bundle))

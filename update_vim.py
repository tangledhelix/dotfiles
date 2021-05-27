#!/usr/bin/env python3

# Assumes Github repos. Use shorthand "user/repo-name".
vim_bundles = {
    "autopairs": "jiangmiao/auto-pairs",
    "endwise": "tpope/vim-endwise",
    "ghmarkdown": "jtratner/vim-flavored-markdown",
    "pathogen": "tpope/vim-pathogen",
    "perl": "vim-perl/vim-perl",
    "pgsql": "exu/pgsql.vim",
    "puppet": "puppetlabs/puppet-syntax-vim",
    "statline": "millermedeiros/vim-statline",
    "surround": "tpope/vim-surround",
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

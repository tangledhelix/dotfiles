#!/usr/bin/env perl

use strict;
use warnings;

use lib 'lib';

use Cwd 'abs_path';
use File::Basename;
use File::Path 'remove_tree';

my %files = (
    bash => [ 'bash', 'bash_profile', 'bashrc' ],
    git  => [ 'gitconfig', 'gitignore' ],
    misc => [ 'cvsrc', 'emacs', 'hgrc', 'ircrc', 'pryrc', 'screenrc', 'tcshrc', 'perldb',
              'terminfo', 'tmux.conf', 'perltidyrc', 'inputrc', 'psqlrc', 'colordiffrc',
              'pgclirc' ],
    vim  => [ 'vim', 'vimrc' ],
    zsh  => [ 'zlogin', 'zlogout', 'zshenv', 'zshrc' ],
);

# note: bash is not installed by default!
my @files_all;
foreach my $list ('zsh', 'vim', 'git', 'misc') {
    foreach my $item (@{$files{$list}}) {
        push @files_all, $item;
    }
}

# For github repos, use shorthand "user/repo-name".
# For non-github repos, use a full URL.
# Only git repos are supported currently.
my %vim_bundles = (
    'ack'               => 'mileszs/ack.vim',
    'clam'              => 'sjl/clam.vim',
    'fugitive'          => 'tpope/vim-fugitive',
    'json'              => 'elzr/vim-json',
    # this shouldn't be necessary, but rhel/centos vim are so old that it is.
    'markdown'          => 'tpope/vim-markdown',
    'my-ackmore'        => 'tangledhelix/vim-ackmore',
    'my-endwise'        => 'tangledhelix/vim-endwise',
    'nerdtree'          => 'scrooloose/nerdtree',
    'octopress'         => 'tangledhelix/vim-octopress',
    'pathogen'          => 'tpope/vim-pathogen',
    'perl'              => 'vim-perl/vim-perl',
    'pgsql'             => 'exu/pgsql.vim',
    'quickrun'          => 'thinca/vim-quickrun',
    'repeat'            => 'tpope/vim-repeat',
    'signify'           => 'mhinz/vim-signify',
    'snipmate'          => 'msanders/snipmate.vim',
    'snipmate-snippets' => 'tangledhelix/snipmate-snippets',
    'solarized'         => 'altercation/vim-colors-solarized',
    'statline'          => 'millermedeiros/vim-statline',
    'surround'          => 'tpope/vim-surround',
    'tabular'           => 'godlygeek/tabular',
    'tcomment'          => 'tomtom/tcomment_vim',
    'unimpaired'        => 'tpope/vim-unimpaired'
);

my $replace_all = 0;
my $vim_do_updates = 0;

my $basedir = dirname(abs_path($0));
chdir $basedir;

$ENV{PATH} = '/usr/local/bin:/usr/bin:/bin';

print_help() unless defined($ARGV[0]);

my $use_ssh = 0;

foreach my $action (@ARGV) {

    if ($action eq '--use-ssh') {
        # https is broken here; use ssh URLs for github
        $use_ssh = 1;

    } elsif ($action eq 'bash') {
        foreach my $file (@{$files{bash}}) {
            determine_action($file, 'dotfile');
        }

    } elsif ($action eq 'zsh') {
        foreach my $file (@{$files{zsh}}) {
            determine_action($file, 'dotfile');
        }
        omz_cloner();

    } elsif ($action eq 'update:zsh') {
        omz_updater();

    } elsif ($action eq 'omz') {
        omz_cloner();

    } elsif ($action eq 'vim') {
        foreach my $file (@{$files{vim}}) {
            determine_action($file, 'dotfile');
        }
        vim_bundle_installer();

    } elsif ($action eq 'update:vim') {
        vim_bundle_cleanup();
        vim_bundle_updater();

    } elsif ($action eq 'cleanup:vim') {
        vim_bundle_cleanup();

    } elsif ($action eq 'update:all') {
        foreach my $file (@files_all) {
            determine_action($file, 'dotfile');
        }
        scripts_installer();
        omz_updater();
        vim_bundle_cleanup();
        vim_bundle_updater();

    } elsif ($action eq 'git') {
        foreach my $file (@{$files{git}}) {
            determine_action($file, 'dotfile');
        }

    } elsif ($action eq 'scripts') {
        scripts_installer();

    } elsif ($action eq 'all') {
        foreach my $file (@files_all) {
            determine_action($file, 'dotfile');
        }
        scripts_installer();
        vim_bundle_installer();
        omz_cloner();

    } else {
        print "*** ERROR: Unknown action $action\n";
        print_help();
    }

}

sub print_help {

    print <<EOF;

Usage: $0 <target>

    all         - Install everything

    bash        - Install bash files only
    git         - Install git files only
    zsh         - Install zsh files only
    vim         - Install vim files and bundles only
    scripts     - Install my motley collection of scripts

    update:vim  - Update vim bundles
    update:zsh  - Update oh-my-zsh and its submodules

    update      - Update both vim and zsh

    update:all  - Install everything, update both vim and zsh

    --use-ssh   - Sub SSH urls instead of https for github

EOF

    exit;
}

sub determine_action {
    my $file = shift;
    my $type = shift;

    my $src_path;
    my $link_path;

    if ($type eq 'dotfile') {
        $src_path = "$basedir/$file";
        $link_path = "$ENV{HOME}/.$file";
    } elsif ($type eq 'script') {
        $src_path = "$basedir/scripts/$file";
        $link_path = "$ENV{HOME}/bin/$file";
    } else {
        die "*** determine_action(): Type is unknown!\n";
    }

    if (-l $link_path and (readlink($link_path) eq $src_path)) {
        print "    skipping $link_path (already linked)\n";
        return;
    }

    if (-d $link_path) {
        warn "** $link_path is a directory, skipping!\n";
        return;
    }

    if (-f $link_path or -l $link_path) {
        if ($replace_all) {
            replace_file($src_path, $link_path);
        } else {
            print "Overwrite ~/.$file? [yNaq] ";
            chomp(my $choice = <STDIN>);
            if ($choice eq 'a') {
                $replace_all = 1;
                replace_file($src_path, $link_path);
            } elsif ($choice eq 'y') {
                replace_file($src_path, $link_path);
            } elsif ($choice eq 'q') {
                exit;
            } else {
                print "    skipping $link_path\n";
            }
        }
    } else {
        link_file($src_path, $link_path);
    }
}

sub link_file {
    my $src_path = shift;
    my $link_path = shift;

    print "    linking $link_path\n";
    symlink $src_path, $link_path or warn "Unable to link $link_path\n";
}

sub replace_file {
    my $src_path = shift;
    my $link_path = shift;

    print "    removing old $link_path\n";
    unlink $link_path or warn "Could not remove $link_path";
    link_file($src_path, $link_path);
}

# clone my omz repository
sub omz_cloner {
    my $omz_path = "$basedir/oh-my-zsh";
    my $repo_url = 'https://github.com/tangledhelix/oh-my-zsh.git';
    if ($use_ssh) {
        $repo_url = 'git@github.com:tangledhelix/oh-my-zsh.git';
    }
    if (-f $omz_path or -d $omz_path) {
        print "    $omz_path already exists, skipping\n";
        print "To reinstall OMZ, rename or remove $omz_path and try again.\n";
        return;
    }
    system "git clone $repo_url $omz_path";
    system "cd $omz_path && git submodule init";
    if ($use_ssh) {
        omz_remotes_set_ssh();
    }
    system "cd $omz_path && git submodule update --recursive";
}

# update the omz repository
sub omz_updater {
    my $omz_path = "$basedir/oh-my-zsh";
    system "cd $omz_path && git pull && git submodule update --init --recursive";
}

# install or update vim bundles
sub vim_bundle_installer {
    my $bundle_path = "$ENV{HOME}/.vim/bundle";
    mkdir $bundle_path unless -d $bundle_path;

    foreach my $bundle (keys %vim_bundles) {
        my $repo = $vim_bundles{$bundle};
        unless ($repo =~ m{^(https?|git)://}) {
            if ($use_ssh) {
                $repo = "git\@github.com:$repo.git";
            } else {
                $repo = "https://github.com/$repo.git";
            }
        }
        my $this_bundle_path = "$bundle_path/$bundle";
        if (-d $this_bundle_path) {
            if ($vim_do_updates) {
                print "    updating vim bundle $bundle\n";
                system "cd $this_bundle_path && git pull";
            } else {
                print "    skipping vim bundle $bundle (already exists)\n";
            }
        } else {
            print "    cloning vim bundle $bundle\n";
            system "git clone $repo $this_bundle_path";
        }
    }

}

sub vim_bundle_updater {
    $vim_do_updates = 1;
    vim_bundle_installer();
}

# clean out old vim bundles
sub vim_bundle_cleanup {
    my $bundle_path = "$ENV{HOME}/.vim/bundle";
    foreach my $dir (glob "$bundle_path/*") {
        my $basename = basename $dir;
        unless ($vim_bundles{$basename}) {
            print "    cleaning up bundle $basename\n";
            remove_tree($dir);
        }
    }
}

# install script symlinks
sub scripts_installer {
    my $install_path = "$ENV{HOME}/bin";
    mkdir $install_path, 0700 unless -d $install_path;
    foreach my $script (glob "$basedir/scripts/*") {
        determine_action(basename($script), 'script');
    }
}

# stupid hack to get around ACLs; update submodules in omz to use ssh.
sub omz_remotes_set_ssh {
    chdir "$basedir/oh-my-zsh";
    $ENV{PATH} = '/usr/local/bin:' . $ENV{PATH};

    open my $fh, '-|', 'git submodule';
    while (<$fh>) {
        my @parts = split;
        my $module_path = $parts[1];

        open my $fh2, '-|', "git config --get submodule.${module_path}.url";
        chomp(my $url = <$fh2>);
        if ($url =~ /^https:/) {
            $url =~ s{^https://}{git\@};
            $url =~ s{/}{:};
            system "git config submodule.${module_path}.url $url";
        }
    }
}

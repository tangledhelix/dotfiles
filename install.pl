#!/usr/bin/env perl

use strict;
use warnings;

use lib 'lib';

use Cwd 'abs_path';
use File::Basename;
use File::Path 'remove_tree';
use YAML qw/DumpFile LoadFile/;

my %files = (
    bash => [ 'bash', 'bash_profile', 'bashrc', 'inputrc' ],
    git  => [ 'gitignore' ],
    misc => [ 'cvsrc', 'emacs', 'hgrc', 'ircrc', 'pryrc', 'screenrc', 'tcshrc',
              'terminfo', 'tmux.conf' ],
    vim  => [ 'vim', 'vimrc' ],
    zsh  => [ 'zlogin', 'zlogout', 'zshenv', 'zshrc' ],
);

my @files_all;
foreach my $list (keys %files) {
    foreach my $item (@{$files{$list}}) {
        push @files_all, $item;
    }
}

my %vim_bundles = (
    'abolish'           => 'tpope/vim-abolish',
    'clam'              => 'sjl/clam.vim',
    'ctrlp'             => 'kien/ctrlp.vim',
    'easymotion'        => 'Lokaltog/vim-easymotion',
    'endwise'           => 'tpope/vim-endwise',
    'fugitive'          => 'tpope/vim-fugitive',
    'gitgutter'         => 'airblade/vim-gitgutter',
    'gitv'              => 'gregsexton/gitv',
    'gundo'             => 'sjl/gundo.vim',
    'jellybeans'        => 'nanotech/jellybeans.vim',
    'octopress'         => 'tangledhelix/vim-octopress',
    'pathogen'          => 'tpope/vim-pathogen',
    'perl'              => 'vim-perl/vim-perl',
    'powerline'         => 'Lokaltog/vim-powerline',
    'puppet'            => 'puppetlabs/puppet-syntax-vim',
    'quickrun'          => 'thinca/vim-quickrun',
    'repeat'            => 'tpope/vim-repeat',
    'snipmate'          => 'msanders/snipmate.vim',
    'snipmate-snippets' => 'tangledhelix/snipmate-snippets',
    'surround'          => 'tpope/vim-surround',
    'syntastic'         => 'scrooloose/syntastic',
    'tabular'           => 'godlygeek/tabular',
    'tcomment'          => 'tomtom/tcomment_vim',
    'textobj-rubyblock' => 'nelstrom/vim-textobj-rubyblock',
    'textobj-user'      => 'kana/vim-textobj-user',
    'unimpaired'        => 'tpope/vim-unimpaired',
);

my $replace_all = 0;
my $vim_do_updates = 0;

my $basedir = dirname(abs_path($0));
chdir $basedir;

print_help() unless defined($ARGV[0]);
my $action = $ARGV[0];

$ENV{PATH} = '/usr/local/bin:/usr/bin:/bin';

if ($action eq 'bash') {
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

} elsif ($action eq 'update') {
    omz_updater();
    vim_bundle_cleanup();
    vim_bundle_updater();

} elsif ($action eq 'git') {
    foreach my $file (@{$files{git}}) {
        determine_action($file, 'dotfile');
    }
    gitconfig_installer();

} elsif ($action eq 'scripts') {
    scripts_installer();

} elsif ($action eq 'all') {
    foreach my $file (@files_all) {
        determine_action($file, 'dotfile');
    }
    scripts_installer();
    vim_bundle_installer();
    omz_cloner();
    gitconfig_installer();

} else {
    print_help();
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
    if (-f $omz_path or -d $omz_path) {
        print "    $omz_path already exists, skipping\n";
        print "To reinstall OMZ, rename or remove $omz_path and try again.\n";
        return;
    }
    system "git clone $repo_url $omz_path";
    system "cd $omz_path && git submodule update --init --recursive";
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
            system "git clone https://github.com/$repo.git $this_bundle_path";
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

# The ~/.gitconfig file is generated dynamically so that I can have my
# GitHub API token configured in it without putting my token into my GitHub
# dotfiles repo, which is publicly visible.

sub gitconfig_installer {
    my $template_file = 'gitconfig.tmpl';
    my $output_file = "$ENV{HOME}/.gitconfig";
    my $cache_file = "$output_file.cache";
    my $gitconfig_params = {};

    # If we find an older install with the symlink in place,
    # clean that up first
    if (-l $output_file) {
        if (unlink $output_file) {
            print "    deleted symlink $output_file\n";
        } else {
            warn "Unable to unlink $output_file";
        }
    }

    unless (-f $cache_file) {

        print "    creating ~/.gitconfig.cache\n\n";
        print "Enter .gitconfig data\n";
        print "(press enter to leave a value blank.)\n\n";

        my $input;

        print 'Name: ';
        chomp($gitconfig_params->{git_name} = <STDIN>);

        print 'Email address: ';
        chomp($gitconfig_params->{git_email} = <STDIN>);

        print 'GitHub username: ';
        chomp($gitconfig_params->{github_username} = <STDIN>);

        print 'GitHub API token: ';
        chomp($gitconfig_params->{github_api_token} = <STDIN>);

        DumpFile($cache_file, $gitconfig_params);

        if ((chmod 0600, $cache_file) != 1) {
            warn "chmod of $cache_file failed!";
        }
    }

    print "    generating ~/.gitconfig\n";

    my $template_vars = LoadFile($cache_file);

    open my $template, $template_file or die "Can't read .gitconfig template";
    open my $out, ">$output_file" or die "Can't write ~/.gitconfig";

    while (<$template>) {
        s/__GIT_NAME__/name = $template_vars->{git_name}/;
        s/__GIT_EMAIL__/email = $template_vars->{git_email}/;
        s/__GITHUB_USERNAME__/user = $template_vars->{github_username}/;
        s/__GITHUB_API_TOKEN__/token = $template_vars->{github_api_token}/;
        print $out $_;
    }

    if (chmod(0600, $output_file) != 1) {
        warn "Unable to chmod $output_file";
    }

}


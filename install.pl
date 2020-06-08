#!/usr/bin/env perl

use strict;
use warnings;

use lib 'lib';

use Cwd ('abs_path', 'getcwd');
use File::Basename;
use File::Path 'remove_tree';

# For github repos, use shorthand "user/repo-name".
# For non-github repos, use a full URL.
# Only git repos are supported currently.
my %vim_bundles = (
    'ack' => 'mileszs/ack.vim',
    'docker' => 'honza/dockerfile.vim',
    'fugitive' => 'tpope/vim-fugitive',
    'ghmarkdown' => 'jtratner/vim-flavored-markdown',
    'json' => 'elzr/vim-json',
    'my-ackmore' => 'tangledhelix/vim-ackmore',
    'my-endwise' => 'tangledhelix/vim-endwise',
    'pathogen' => 'tpope/vim-pathogen',
    'perl' => 'vim-perl/vim-perl',
    'pgsql' => 'exu/pgsql.vim',
    'puppet' => 'puppetlabs/puppet-syntax-vim',
    'quickrun' => 'thinca/vim-quickrun',
    'repeat' => 'tpope/vim-repeat',
    'statline' => 'millermedeiros/vim-statline',
    'surround' => 'tpope/vim-surround',
    'tcomment' => 'tomtom/tcomment_vim',
    'autopairs' => 'jiangmiao/auto-pairs',
);

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

    } elsif ($action eq 'update:vim') {
        vim_bundle_cleanup();
        vim_bundle_updater();

    } elsif ($action eq 'cleanup:vim') {
        vim_bundle_cleanup();

    } else {
        print "*** ERROR: Unknown action $action\n";
        print_help();
    }

}

sub print_help {

    print <<EOF;

Usage: $0 <target>

    update:vim  - Update vim bundles
    cleanup:vim - Cleanup vim bundles

    --use-ssh   - Sub SSH urls instead of https for github

EOF

    exit;
}

# install or update vim bundles
sub vim_bundle_installer {
    my $bundle_path = "${basedir}/vim/bundle";
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
                my $old_cwd = getcwd;
                chdir $this_bundle_path;
                system 'git', 'pull';
                chdir $old_cwd;
            } else {
                print "    skipping vim bundle $bundle (already exists)\n";
            }
        } else {
            print "    cloning vim bundle $bundle\n";
            system 'git', 'clone', $repo, $this_bundle_path;
        }
    }

}

sub vim_bundle_updater {
    $vim_do_updates = 1;
    vim_bundle_installer();
}

# clean out old vim bundles
sub vim_bundle_cleanup {
    my $bundle_path = "${basedir}/vim/bundle";
    foreach my $dir (glob "$bundle_path/*") {
        my $basename = basename $dir;
        unless ($vim_bundles{$basename}) {
            print "    cleaning up bundle $basename\n";
            remove_tree($dir);
        }
    }
}

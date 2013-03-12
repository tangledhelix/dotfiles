#!/usr/bin/env perl
#
# use ssh to execute perl script remotely
#

# You can change PERL and REMOTE_CMD constants to reflect your real
# environment...

use constant PERL => 'perl'; # maybe "/usr/local/bin/perl"
use constant REMOTE_CMD => 'ssh';
use constant CAT_CMD => 'cat';

use strict;
use warnings;
use vars qw($VERSION);
$VERSION = '1.00';

use constant USAGE => <<EOU;

Usage:

   $0 \\
      [-v]                                 \\
      [-r<remote command flags>]           \\
      [-R<remote command>]                 \\
      [-Q<perl path>]                      \\
      [<usual perl flags>]                 \\
      <[<remote user>@]remote_host>[,...]  \\
      [<local_script.pl | -e 'perl code'>] \\
      [<script args>]

EOU

# options for command line parsing
my $verbose; # -v
my @remote_opts; # opts for ssh/remote command
my $remote_cmd; # ssh substitute
my @perl_opts; # opts for remote perl
my $perl_cmd; # remote perl path

# extract options. This is very simple parsing of options and force
# the args to be precisely ordered.
while(defined $ARGV[0] and $ARGV[0]=~/^-/) {
  $_=shift;
  if    (/^-v/)     { $verbose=1 }
  elsif (/^-r(.*)/) { push @remote_opts,$1 }
  elsif (/^-R(.*)/) { $remote_cmd=$1 }
  elsif (/^-Q(.*)/) { $perl_cmd=$1 }
  else { push @perl_opts,"'$_'" }
}

# use the default REMOTE_CMD
$remote_cmd||=REMOTE_CMD;

# read remote machine name:
my $machines=shift or die "error: remote machine not specified\n".USAGE;
my @machines=split(',',$machines);

# script name... when available:
my $file=shift;

# get the perl code to run remotely:
my $code;
if(defined $file and $file eq '-e') {
  # perl code is in cmd line after the -e switch.
  $code=shift or die "error: no perl code after '-e'\n".USAGE;
}
else {
  if (defined $file) {
    if($file=~/(.+):(.+)/) {
      # read perl code from remote file
      open(F,"$remote_cmd '$1' ".CAT_CMD." '$2'|")
	or die "error: unable to read remote file '$2' from '$1' ($!)\n";
    }
    else {
      # read perl code from file.
      open(F,"< $file")
	or die "error: unable to open '$file' ($!)\n";
    }
  }
  else { *F=*STDIN } # read perl code from stdin
  {
    # slurp the file to $code
    local $/=undef;
    $code=<F>;
  }
  # gets perl path and flags for first line in src file if available:
  if ($code=~/\A\#!(.*)$/m) {
    my $line=$1;
    if ($line=~/\s*(\S+)\s*(.*)/) {
      $perl_cmd||=$1;
      # anything in the line after the perl path will be considered to
      # be flags. I know this could be improved.
      push @perl_opts,$2 if defined $2;
    }
  }
}

# use the default PERL location if it is yet unknow
$perl_cmd||=PERL;

# convert code to hex string
my $packed = unpack "h*",$code;

# this is the remote program to decode and run the script:
my $decoder = q{'BEGIN{eval"sub _R{".(pack"h*",shift)."}"}_R(@ARGV)'};
# There was a simpler decoder but it didn't works with the -n flag so
# I have changed it...
# my $decoder = q{'eval pack"h*",shift'};

# format script args with "'" between them:.
my $args='';
{
  local $"="' '";
  $args="'@ARGV'" if @ARGV;
}

foreach my $machine (@machines) {
  # complete ssh cmd. Remote command is escaped.
  my $cmd="$remote_cmd @remote_opts $machine ".
    quotemeta "$perl_cmd @perl_opts -e $decoder $packed $args";

  # print cmd if verbosity enabled
  print STDERR "remote cmd:\n$cmd\n\n" if $verbose;

  # run it and report problems
  system($cmd)
    and print STDERR "Unable to exec ($!).\nRemote command was:\n$cmd\n\n";
}

#################################################
# documentation:


=head1 NAME

sperl - runs perl scripts in remote machines through ssh


=head1 SCRIPT CATEGORIES

Networking
UNIX/System_administration
Perl/Utilities


=head1 README

sperl is some kind of enhanced perl that lets you work in a network
environment and run scripts and oneliners in remote machines without
the need to 


=head1 USAGE

  $ sperl \
      [-v]                                                \
      [-r<remote command flags>]                          \
      [-R<remote command>]                                \
      [-Q<perl path>]                                     \
      [<usual perl flags>]                                \
      <[<remote user>@]remote_host>[,...]                 \
      [<[<[<user>@]machine>:]script.pl | -e 'perl code'>] \
      [<script args>]


=head1 INSTALLATION

To install sperl, copy it to some place in your path like
/usr/local/bin/sperl and allow execution of it with C<chmod 755
/your/path/to/sperl>.

If you want, you can edit the script and change the PERL and
REMOTE_CMD constants at the beginning to match your real environment.


=head1 DESCRIPTION

C<sperl> lets you run a locally stored perl script in a remote machine
for which ssh (or equivalent) access is available.

It doesn't need any special module installed in local or remote
machines, just plain perl.

If there isn't script name in the command line, neither C<-e> option,
sperl will try to read the code form stdin as perl use to do.

It's possible to take the script file from another remote machine
with the syntax C<machine:/path/to/script.pl> or even
C<user@machine:/path/to/script.pl>.

It's also possible to include several remote host names separated by
commas and the script will be run in all of them. For example C<hippo,bugs,bill@www.microsoft.com>


=head1 OPTIONS

C<sperl> accepts the same command line options as C<perl> does. The
options are passed unchanged to the remote perl interpreter so some of
them like C<-S> are nonsense.

Additionally, it accepts some specific options:

=over

=item -rE<lt>remote command flagsE<gt>

pass options to ssh. For instance C<-r-v>

=item -RE<lt>remote commandE<gt>

specify the command to use in place of ssh to connect to the remote
machine. for instance C<-Rrsh>.

=item -QE<lt>remote perl pathE<gt>

specify the location of the perl interpreter in the remote
machine. By default, sperl will try to look for the perl path in the
script first line, if it uses the notation C<#!/path/to/perl>. As its
last resource it expects perl to be in the PATH.

=item -v

dumps the remote command to stderr before running it. This is primary
for debugging purposes.

=back


=head1 EXAMPLES

  [salvador@hippo:~]$ sperl admin@willy \
   > -e 'print "hello from ".`hostname`'
  hello from willy

  # the -t option force ssh to allocate a new tty...
  [salvador@hippo:~]$ sperl -w -r-t willy -e 'print $count+1,"\n"'
  Use of uninitialized value at (eval 1) line 1.
  1

  # you can even invoke the perl debugger remotely:
  [salvador@hippo:~]$ sperl -d -r-t willy -e 1

  Loading DB routines from perl5db.pl version 1.0401
  Emacs support available.
  
  Enter h or `h h' for help.

  main::(-e:1):   BEGIN{eval"sub _R{".(pack"h*",shift)."}"}_R(@ARGV)
    DB<1> p `hostname`
  p `hostname`
  willy

    DB<2> ...

  # running the same code in several machines:
  [salvador@hippo:~]$ sperl bugs,willy,hippo -e \
  > 'chomp($h=`hostname`);print "hello from $h!!!\n"'
  hello from bugs!!!
  hello from willy!!!
  hello from hippo!!!



=head1 CHANGES

=over

=item sperl 1.00     Thu Sep 23 1999

First public release

=back


=head1 BUGS AND LIMITATIONS

This is a beta release so expect errors in it.

Lots of spelling errors in the docs... Help me!!!

The order of the options in the command line is very inflexible.

Switch parsing for the first line of the script is not very clever and
it will produce unexpected results if something complex is there.

Scripts with C<__END__> or C<__DATA__> sections will fail.

I don't know if there is any possibility to make this to work in
Microsoft's world.


=head1 AUTHOR

Salvador Fandiño García <salvador@cesat.es, fandino@usa.net>


=head1 SEE ALSO

L<perl(1)>, L<ssh(1)> or L<rsh(1)>, L<perlrun(1)>.


=cut 

#!/usr/bin/env perl
#
# Takes a password and outputs Apache MD5.
#
# 05 Feb 2004 - Dan Lowe <dan@tangledhelix.com>

use strict;

# Location of htpasswd binary
my $htpasswdProgram = '/usr/local/bin/htpasswd';

# -n : do not create a file, print to stdout instead
# -m : use md5
# -b : take passwd on cmd line rather than prompting for it
#      (necessary for CGI environment)
my $htpasswdFlags = '-n -m -b';

use CGI qw/:standard:/;

print <<_EOF_;
Content-type: text/html

<!DOCTYPE html>
<html>
<head>
    <title>MD5 password generator</title>
</head>
<body bgcolor="#ffffff" text="#000000">
_EOF_

# If either password field is defined, assume the user wants to encrypt

if (CGI::param('password1') or CGI::param('password2')) {

    # Make sure the strings match each other.
    if (CGI::param('password1') ne CGI::param('password2')) {

        # mismatch...
        print "ERROR: Password mismatch. <br> <br>\n";

    } else {

        # Password strings matched...

        # We have a password to encrypt.  password1 is good
        # enough because we already know it matches password2.
        my $myPass = CGI::param('password1');

        # Call htpasswd to do the work for us. Apache MD5
        # is not the same as other MD5 stuff so I didn't use
        # normal stuff like MD5 or Digest::MD5.

        die "Unable to execute $htpasswdProgram\n"
        unless -x $htpasswdProgram;

        open HTPROG, "$htpasswdProgram $htpasswdFlags dan $myPass |"
            or die "Unable to call $htpasswdProg\n";

        my $result = <HTPROG>;
        chomp($result);

        close HTPROG;

        #  trim off username garbage
        $result =~ s/^dan://;

        print <<_EOF_;
<p><center>
Your password is: <br><br>
<strong> $result </strong>
</center></p><br><br>
_EOF_

    }
}

# Form to get a password

print <<_EOF_;

<p><center>
<form method="post">
Enter the password twice so I know it's right.<br>
Then I'll encrypt it for you.<br><br>
<input type="password" size="30" name="password1"><br>
<input type="password" size="30" name="password2"><br><br>
<input type="submit" name="Submit" value="Submit">
</form>
</center></p><br><br>
</body>
</html>
_EOF_

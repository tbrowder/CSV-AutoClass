#!/usr/bin/env raku

use lib "../lib"; # DELETE BEFORE PUBLISHING (OR COMMENT THE LINE OUT)
use CSV-AutoClass;

if not @*ARGS.elems {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} <csv file> | go [...opts]

    Given a CSV file named, say, 'groups.csv', with the first row
    being a header row, produce a class 'Group' that has
    the same attributes and a 'new' method that can create
    a 'Group' object from a data line in that file.

    Note the format of the CSV file name requires all lower case
    letters (and possibly trailing numbers), and a plural form,
    so the class will be named as a single object to match the
    data lines in the input file.

    If the 'go' arg is entered, the example CSV input file
    '$example' is output to STDOUT.

    Options
        debug
    HERE

    exit;
}

my $debug  = 0;
my $go     = 0;
my $csvfil;
my $cname; # abcs.csv => Abc [<-- results in 'Abc' as the $cname (class name)]

for @*ARGS {
    if $_.IO.r {
        $csvfil = $_;
        # we need at least a two-letter stem in order to create a class
        if $csvfil ~~ /(<lower><lower><alnum>+) '.' csv $/ {
            $cname = ~$0;
            # we require an 's' on the end
            if $cname ~~ / s $/ {
                $cname ~~ s/s$//;
            }
            else {
                die "FATAL: Improper CSV file name format: '$csvfil'";
            }
            $cname = tc $cname;
        }
        else {
            die "FATAL: Improper CSV file name format: '$csvfil'";
        }
        next;
    }
    when /:i ^g/ { $go    = 1 }
    when /:i ^d/ { $debug = 1 }
    default { die "FATAL: Unknown arg '$_'" }
}

execute $csvfil, $cname;

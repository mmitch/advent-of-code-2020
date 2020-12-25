#!/usr/bin/env perl
use strict;
use warnings;

# use named subroutine parameters
use feature 'signatures';
no warnings 'experimental::signatures';
## no critic (ProhibitSubroutinePrototypes)

use constant DIRECTION => {
    0 => 'N',
    1 => 'E',
    2 => 'S',
    3 => 'W',
};

my $facing = 1;
my $ew_pos  = 0;
my $ns_pos  = 0;

# can't use constant because of self-reference:
# 'F' command needs a prototype
my $ACTIONS;
$ACTIONS = {
    # $_[0] is the first parameter passed to the subroutine
    'N' => sub {
	$ns_pos += $_[0];
    },
	'E' => sub {
	    $ew_pos += $_[0];
    },
	'S' => sub {
	    $ns_pos -= $_[0];
    },
	'W' => sub {
	    $ew_pos -= $_[0];
    },
	'L' => sub {
	    $facing -= ( $_[0] / 90 );
	    $facing %= 4;
    },
	'R' => sub {
	    $facing += ( $_[0] / 90 );
	    $facing %= 4;
    },
	'F' => sub {
	    my $direction = DIRECTION->{$facing};
	    $ACTIONS->{$direction}->($_[0]);
    }
};

sub parse_command($command) {
    die "unparseable command: $1" unless $command =~ /^([NSEWLRF])(\d+)$/;
    return ($1, $2);
}

while (my $line = <DATA>) {
    my ($action, $value) = parse_command($line);
    $ACTIONS->{$action}->($value);
}
printf "%d : %d ==> %d\n", $ew_pos, $ns_pos, abs($ew_pos) + abs($ns_pos);

__DATA__
F10
N3
F7
R90
F11

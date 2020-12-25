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

my $ship = {
    EW_POS => 0,
    NS_POS => 0,
};

my $waypoint = {
    EW_POS => 10,
    NS_POS => 1,
};

# can't use constant because of self-reference:
# 'F' command needs a prototype
my $ACTIONS;
$ACTIONS = {
    # $_[0] is the first parameter passed to the subroutine (the object to move)
    # $_[1] is the second parameter (the value)
    'N' => sub {
	my ($obj, $value) = @_;
	$obj->{NS_POS} += $value;
    },
	'E' => sub {
	my ($obj, $value) = @_;
	$obj->{EW_POS} += $value;
    },
	'S' => sub {
	my ($obj, $value) = @_;
	$obj->{NS_POS} -= $value;
    },
	'W' => sub {
	my ($obj, $value) = @_;
	$obj->{EW_POS} -= $value;
    },
	'L' => sub {
	    my ($obj, $value) = @_;
	    for (1 .. ( $value / 90 )) {
		# look ma, no temps!
		( $obj->{EW_POS}, $obj->{NS_POS} ) = ( -$obj->{NS_POS}, $obj->{EW_POS} );
	    }
    },
	'R' => sub {
	    my ($obj, $value) = @_;
	    for (1 .. ( $value / 90 )) {
		# look ma, no temps!
		( $obj->{EW_POS}, $obj->{NS_POS} ) = ( $obj->{NS_POS}, -$obj->{EW_POS} );
	    }
    },
	'F' => sub {
	    my ($obj, $value) = @_;
	    for (1 .. $value) {
		$ACTIONS->{'E'}->($ship, $waypoint->{EW_POS});
		$ACTIONS->{'N'}->($ship, $waypoint->{NS_POS});
	    }
    }
};

sub parse_command($command) {
    die "unparseable command: $1" unless $command =~ /^([NSEWLRF])(\d+)$/;
    return ($1, $2);
}

while (my $line = <DATA>) {
    my ($action, $value) = parse_command($line);
    $ACTIONS->{$action}->($waypoint, $value);
}
printf "%d : %d ==> %d\n", $ship->{EW_POS}, $ship->{NS_POS}, abs($ship->{EW_POS}) + abs($ship->{NS_POS});

__DATA__
F10
N3
F7
R90
F11

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
    FACING => 1,
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
	    $obj->{FACING} -= ( $value / 90 );
	    $obj->{FACING} %= 4;
    },
	'R' => sub {
	    my ($obj, $value) = @_;
	    $obj->{FACING} += ( $value / 90 );
	    $obj->{FACING} %= 4;
    },
	'F' => sub {
	    my ($obj, $value) = @_;
	    my $direction = DIRECTION->{$obj->{FACING}};
	    $ACTIONS->{$direction}->($obj, $value);
    }
};

sub parse_command($command) {
    die "unparseable command: $1" unless $command =~ /^([NSEWLRF])(\d+)$/;
    return ($1, $2);
}

while (my $line = <DATA>) {
    my ($action, $value) = parse_command($line);
    $ACTIONS->{$action}->($ship, $value);
}
printf "%d : %d ==> %d\n", $ship->{EW_POS}, $ship->{NS_POS}, abs($ship->{EW_POS}) + abs($ship->{NS_POS});

__DATA__
F10
N3
F7
R90
F11

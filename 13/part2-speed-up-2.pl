#!/usr/bin/env perl
use strict;
use warnings;

# use named subroutine parameters
use feature 'signatures';
no warnings 'experimental::signatures';
## no critic (ProhibitSubroutinePrototypes)

use constant DONT_CARE => 'x';
use constant TRUE  => 1;
use constant FALSE => 0;

my $initial_timestamp;
my @bus_lines;

sub parse_data() {
    $initial_timestamp = <DATA>;
    chomp $initial_timestamp;

    my $bus_lines = <DATA>;
    chomp $bus_lines;

    @bus_lines = split /,/, $bus_lines;
}

sub bus_line_departs_at($bus_line, $timestamp) {
    if ($bus_line eq DONT_CARE) {
	return TRUE;
    }
    return $timestamp % $bus_line == 0;
}

my $skip           = 1;
my $first_mismatch = 0;
sub all_bus_lines_depart_sequentially_starting_at($timestamp) {
    # we match from left to right.
    # if the first n timestamps match, we adjust our timestamp skip
    # so that they will always in the future.
    for (my $offset = $first_mismatch; $offset < @bus_lines; $offset++) {
	my $bus_line = $bus_lines[$offset];
	if (!bus_line_departs_at($bus_line, $timestamp + $offset)) {
	    $first_mismatch = $offset;
	    return FALSE;
	}
	if ($bus_line ne DONT_CARE) {
	    $skip *= $bus_line;
	}
    }
    return TRUE;
}

# main program
parse_data();
my $timestamp = $initial_timestamp;
while(1) {
    if (all_bus_lines_depart_sequentially_starting_at($timestamp)) {
	print "solution = $timestamp\n";
	exit 0;
    }
    # speed up by skipping more than 1 timestamp on a mismatch
    $timestamp += $skip;
}


__DATA__
1
17,x,13,19

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

sub all_bus_lines_depart_sequentially_starting_at($timestamp) {
    my $offset = 0;
    for my $bus_line ( @bus_lines ) {
	if (!bus_line_departs_at($bus_line, $timestamp + $offset)) {
	    return FALSE;
	}
	$offset++;
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
    $timestamp++;
}


__DATA__
1
17,x,13,19

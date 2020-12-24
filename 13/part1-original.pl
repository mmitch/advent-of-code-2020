#!/usr/bin/env perl
use strict;
use warnings;

# use named subroutine parameters
use feature 'signatures';
no warnings 'experimental::signatures';
## no critic (ProhibitSubroutinePrototypes)

use constant TRUE  => 1;
use constant FALSE => 0;

my $initial_timestamp;
my @bus_lines;

sub parse_data() {
    $initial_timestamp = <DATA>;
    chomp $initial_timestamp;

    my $bus_lines = <DATA>;
    chomp $bus_lines;

    @bus_lines = grep { $_ =~ /^[0-9]+/ } split /,/, $bus_lines;
}

sub bus_line_departs_at($bus_line, $timestamp) {
    return $timestamp % $bus_line == 0;
}

my $solution;
sub any_bus_line_departs_at($timestamp) {
    for my $bus_line ( @bus_lines ) {
	if (bus_line_departs_at($bus_line, $timestamp)) {
	    my $waiting_time = $timestamp - $initial_timestamp;
	    $solution = $waiting_time * $bus_line;
	    return TRUE;
	}
    }
    return FALSE;
}

# main program
parse_data();
my $timestamp = $initial_timestamp;
while(1) {
    if (any_bus_line_departs_at($timestamp)) {
	print "solution = $solution\n";
	exit 0;
    }
    $timestamp++;
}


__DATA__
939
7,13,x,x,59,x,31,19

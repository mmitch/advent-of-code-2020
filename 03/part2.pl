#!/usr/bin/env perl
use strict;
use warnings;

# use named subroutine parameters
use feature 'signatures';
no warnings 'experimental::signatures';
## no critic (ProhibitSubroutinePrototypes)

use constant SLOPES => ( [1, 1], [3, 1], [5, 1], [7, 1], [1, 2] );

# save start of __DATA__
my $data_start = tell DATA;

sub count_trees($slope_right, $slope_down) {
    my $trees_encountered = 0;
    my $xpos = 0;

    # reset input
    seek DATA, $data_start, 0;

    while (my $line = <DATA>) {
	chomp $line;
	last if $line eq '';

	my $width = length $line;
	
	# check for tree
	$trees_encountered++ if substr($line, $xpos, 1) eq '#';
	
	# move tobbogan
	$xpos += $slope_right;
	$xpos %= $width;
	foreach (2 .. $slope_down) {
	    my $skipped_downward = <DATA>;
	}
    }
    return $trees_encountered;
}

my $product = 1;
foreach my $slope (SLOPES) {
    $product *= count_trees($slope->[0], $slope->[1]);
}

print "tree product $product\n";

__DATA__
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#

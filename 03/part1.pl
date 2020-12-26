#!/usr/bin/env perl
use strict;
use warnings;

# use named subroutine parameters
use feature 'signatures';
no warnings 'experimental::signatures';
## no critic (ProhibitSubroutinePrototypes)

use constant SLOPE => 3;

my $trees_encountered = 0;
my $xpos = 0;
while (my $line = <DATA>) {
    chomp $line;
    my $width = length $line;

    # check for tree
    $trees_encountered++ if substr($line, $xpos, 1) eq '#';

    # move tobbogan
    $xpos += SLOPE;
    $xpos %= $width;
}

print "trees $trees_encountered\n";

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

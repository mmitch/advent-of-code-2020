#!/usr/bin/env perl
use strict;
use warnings;

# use named subroutine parameters
use feature 'signatures';
no warnings 'experimental::signatures';
## no critic (ProhibitSubroutinePrototypes)

# expense report input data is located  at end of script
use constant SUM_TO_FIND => 2020;

my @sorted_expenses;

sub read_expenses() {
    my @expenses;
    while (my $line = <DATA>) {
	chomp $line;
	push @expenses, $line;
    }
    @sorted_expenses = sort @expenses;
}

my $last = @sorted_expenses - 1;
my $i = 0;
my $j = 1;
my $k = 2;
sub get_next_triplet() {

    # no end condition because we expect to find a match before the permutation is over
    my $triplet = [ @sorted_expenses[$i,$j,$k] ];
    $k++;
    if ($k > $last) {
	$j++;
	if ($j > $last) {
	    $i++;
	    $j = $i+1;
	}
	$k = $j+1;
    }
    return $triplet;
}

sub sum($numbers) {
    my $sum = 0;
    $sum += $_ foreach @{$numbers};
    return $sum;
}

sub product($numbers) {
    my $product = 1;
    $product *= $_ foreach @{$numbers};
    return $product;
}

sub sum_matches($pair) {
    return sum($pair) == SUM_TO_FIND;
}

# main program
read_expenses;
while (my $pair = get_next_triplet()) {
    if (sum_matches($pair)) {
	printf "found ( %s )\n", join (', ', @{$pair});
	printf "sum    : %d\n", sum($pair);
	printf "product: %d\n", product($pair);
	exit 0;
    }
}

__DATA__
1721
979
366
299
675
1456

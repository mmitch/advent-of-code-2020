#!/usr/bin/env perl
use strict;
use warnings;

# use named subroutine parameters
use feature 'signatures';
no warnings 'experimental::signatures';
## no critic (ProhibitSubroutinePrototypes)

# expense report input data is located  at end of script
use constant SUM_TO_FIND => 2020;

# a hash where we only use the keys: basically this is a set
my %expenses;

sub record_expenses() {
    while (my $line = <DATA>) {
	chomp $line;
	$expenses{$line}++; # this creates the hash key, the value is irrelevant
    }
}

sub calculate_match($expense) {
    return SUM_TO_FIND - $expense;
}

sub match_exists($match) {
    return exists $expenses{$match};
}

# main program
record_expenses;
foreach my $expense (keys %expenses) {
    my $possible_match = calculate_match($expense);
    if (match_exists($possible_match)) {
	print "found a match:\n";
	printf "%d + %d = %d\n", $expense, $possible_match, $expense + $possible_match;
	printf "%d * %d = %d\n", $expense, $possible_match, $expense * $possible_match;
	exit 0;
    }
}
die "no match found";


__DATA__
1721
979
366
299
675
1456

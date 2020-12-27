#!/usr/bin/env perl
use strict;
use warnings;

# use named subroutine parameters
use feature 'signatures';
no warnings 'experimental::signatures';
## no critic (ProhibitSubroutinePrototypes)

my $bag_rules;
my $reverse;

sub find_all_parents($what) {
    my %parents = ( $what => 1 );
    $parents{$_}++ foreach map { find_all_parents($_) } keys %{$reverse->{$what}};
    return keys %parents;
}

while (my $line = <DATA>) {
    chomp $line;
    next unless $line =~ /^([a-z ]+) bags contain (.+)\.$/;
    my ($what, $contents) = ($1, $2);
    my @contents;
    foreach my $content (split /, /, $contents) {
	if ($content =~ /^(\d+) ([a-z ]+) bags?$/) {
	    push @contents, {
		AMOUNT => $1,
		WHAT   => $2,
	    };
	    $reverse->{$2}->{$what}++;
	}
    }
    $bag_rules->{$what} = \@contents;
}

printf "found: %d\n", scalar find_all_parents('shiny gold') - 1;

__DATA__
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.

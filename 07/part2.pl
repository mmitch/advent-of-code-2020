#!/usr/bin/env perl
use strict;
use warnings;

# use named subroutine parameters
use feature 'signatures';
no warnings 'experimental::signatures';
## no critic (ProhibitSubroutinePrototypes)

my $bag_rules;
my $reverse;

sub count_all_children($what) {
    my $count = 1;
    foreach my $child (@{$bag_rules->{$what}}) {
	$count += $child->{AMOUNT} * count_all_children($child->{WHAT});
    }
    return $count;
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

printf "found: %d\n", scalar count_all_children('shiny gold') - 1;

__DATA__
shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.

#!/usr/bin/env perl
use strict;
use warnings;

# use named subroutine parameters
use feature 'signatures';
no warnings 'experimental::signatures';
## no critic (ProhibitSubroutinePrototypes)

my $first;

sub start_group() {
    $first = 1;
    return {};
}

sub get_group_sum($group) {
    return scalar keys %{$group};
}

sub add_answers_to_group($line, $group) {
    if (!$first) {
	my $new = {};
	$new->{$_}++ foreach split //, $line;
	# remove existing answers that are not given again
	foreach my $existing (keys %{$group}) {
	    delete $group->{$existing} unless exists $new->{$existing};
	}
    }
    else {
	# init with first answers
	$group->{$_}++ foreach split //, $line;
	$first = 0;
    }
}

my $group_sums = 0;
my $group = start_group();
while (my $line = <DATA>) {
    chomp $line;
    if ($line eq '') {
	$group_sums += get_group_sum($group);
	$group = start_group();
    }
    else {
	add_answers_to_group($line, $group);
    }
}
$group_sums += get_group_sum($group);

print "$group_sums\n";

__DATA__
abc

a
b
c

ab
ac

a
a
a
a

b

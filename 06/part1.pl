#!/usr/bin/env perl
use strict;
use warnings;

# use named subroutine parameters
use feature 'signatures';
no warnings 'experimental::signatures';
## no critic (ProhibitSubroutinePrototypes)

sub start_group() {
    return {};
}

sub get_group_sum($group) {
    return scalar keys %{$group};
}

sub add_answers_to_group($line, $group) {
    $group->{$_}++ foreach split //, $line;
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

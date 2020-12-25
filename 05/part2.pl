#!/usr/bin/env perl
use strict;
use warnings;

# use named subroutine parameters
use feature 'signatures';
no warnings 'experimental::signatures';
## no critic (ProhibitSubroutinePrototypes)


# The task basically uses a lot of words to occlude that the number is
# given in plain binary (althouth "binary boarding" and "binary space
# partitioning" might give it away).
# B and R are 1, F and L are # 0. Everything can be converted as-is.

sub get_seat_id($boarding_pass) {
    $boarding_pass =~ tr/BR/1/;
    $boarding_pass =~ tr/FL/0/;
    return oct('0b'.$boarding_pass);
}

my %seats_seen;

my $max_seat_id = 0;
while (my $boarding_pass = <DATA>) {
    chomp $boarding_pass;
    my $seat_id = get_seat_id($boarding_pass);
    printf "%s -> %d\n", $boarding_pass, $seat_id;
    $seats_seen{$seat_id}++;
    $max_seat_id = $seat_id if $seat_id > $max_seat_id;
}
printf "max seat id: %d\n", $max_seat_id;

for my $seat_id (0 .. $max_seat_id) {
    if (!exists $seats_seen{$seat_id}
	and exists $seats_seen{$seat_id - 1}
	and exists $seats_seen{$seat_id + 1})
    {
	printf "%d is your seat\n", $seat_id;
	exit 0;	
    }
}
die "seat not found";

__DATA__
FBFBBFFRLR
BFFFBBFRRR
FFFBBBFRRR
BBFFBBFRLL

#!/usr/bin/env perl
use strict;
use warnings;

# use named subroutine parameters
use feature 'signatures';
no warnings 'experimental::signatures';
## no critic (ProhibitSubroutinePrototypes)

use constant DIGITS => {
    'F' => 0, 'B' => 1, 
    'L' => 0, 'R' => 1, 
};

sub convert_to_decimal($digits, $base) {
    my $decimal = 0;
    my @digits = split //, $digits;
    foreach my $digit (@digits) {
	$decimal *= $base;
	$decimal += DIGITS->{$digit};
    }
    return $decimal;
}

use constant SEATS_PER_ROW => convert_to_decimal('RRR', 2) + 1;
sub get_seat_id($boarding_pass) {
    my $row_string   = substr($boarding_pass, 0, 7);
    my $seat_string  = substr($boarding_pass, 7, 3);

    my $row  = convert_to_decimal($row_string,  2);
    my $seat = convert_to_decimal($seat_string, 2);

    return $row * SEATS_PER_ROW + $seat;
}

my $max_seat_id = 0;
while (my $boarding_pass = <DATA>) {
    chomp $boarding_pass;
    my $seat_id = get_seat_id($boarding_pass);
    printf "%s -> %d\n", $boarding_pass, $seat_id;
    $max_seat_id = $seat_id if $seat_id > $max_seat_id;
}
printf "max seat id: %d\n", $max_seat_id;

__DATA__
FBFBBFFRLR
BFFFBBFRRR
FFFBBBFRRR
BBFFBBFRLL

#!/usr/bin/env perl
use strict;
use warnings;

# use named subroutine parameters
use feature 'signatures';
no warnings 'experimental::signatures';
## no critic (ProhibitSubroutinePrototypes)


use constant STARTING_NUMBERS => ( 0, 3, 6 );
use constant LAST_TURN        => 30000000;
use constant EXPECTED_NUMBER  => 436;

my $number_spoken = {};
my $current_turn = 1;
my $last_number_spoken;

sub calculate_last_seen($number) {
    my $record = $number_spoken->{$number};
    return 0 unless $record->{before_last};
    return $record->{last} - $record->{before_last};
}

sub record_number($number) {
    $number_spoken->{$number}->{before_last} = $number_spoken->{$number}->{last};
    $number_spoken->{$number}->{last} = $current_turn;
}

sub speak_number($number) {
#    printf "Turn %d: %d\n", $current_turn, $number; ## output is too slow
    record_number($number);
    $last_number_spoken = $number;
}

sub next_turn() {
    $current_turn++;
}

sub record_starting_numbers() {
    foreach my $number (STARTING_NUMBERS) {
	speak_number($number);
	next_turn;
    }
}

# main program
record_starting_numbers();

while ($current_turn <= LAST_TURN) {
    my $number = calculate_last_seen($last_number_spoken);
    speak_number($number);
    print "$current_turn\n" if $current_turn % 1000000 == 0; ## provide some kind of visual progress
    next_turn;
}

die "unexpected result: $last_number_spoken != " . EXPECTED_NUMBER unless $last_number_spoken == EXPECTED_NUMBER;

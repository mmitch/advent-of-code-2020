#!/usr/bin/env perl
use strict;
use warnings;

# use named subroutine parameters
use feature 'signatures';
no warnings 'experimental::signatures';
## no critic (ProhibitSubroutinePrototypes)


sub read_passwords() {
    my @passwords;
    while (my $line = <DATA>) {
	chomp $line;
	die $line unless $line =~ /^(\d+)-(\d+) ([^:]): (.*)$/;
	push @passwords, {
	    CHAR => $3,
	    MIN  => $1,
	    MAX  => $2,
	    PASSWORD => $4,
	};
    }
    return @passwords;
}

sub get_character_frequencies($word) {
    my %character_frequencies;
    $character_frequencies{$_}++ foreach split //, $word;
    return \%character_frequencies;
}

sub is_valid($password) {
    my $character_frequencies = get_character_frequencies($password->{PASSWORD});
    my $count = $character_frequencies->{$password->{CHAR}} // 0;
    return ($count >= $password->{MIN} and $count <= $password->{MAX});
}

my @valid_passwords = grep { is_valid($_) } read_passwords();
printf "%d\n", scalar @valid_passwords;

__DATA__
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc

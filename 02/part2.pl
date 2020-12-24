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
    my $to_check = substr( $password->{PASSWORD}, ($password->{MIN})-1, 1 ) . substr( $password->{PASSWORD}, ($password->{MAX}-1), 1 );
    my $character_frequencies = get_character_frequencies($to_check);
    my $count = $character_frequencies->{$password->{CHAR}} // 0;
return ($count == 1);
}

my @valid_passwords = grep { is_valid($_) } read_passwords();
printf "%d\n", scalar @valid_passwords;

__DATA__
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc

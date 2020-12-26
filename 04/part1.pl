#!/usr/bin/env perl
use strict;
use warnings;

# use named subroutine parameters
use feature 'signatures';
no warnings 'experimental::signatures';
## no critic (ProhibitSubroutinePrototypes)

use constant TRUE  => 1;
use constant FALSE => 0;
use constant REQUIRED_FIELDS => qw(
    byr
    iyr
    eyr
    hgt
    hcl
    ecl
    pid
    );

sub start_passport() {
    return {};
}

sub is_valid($passport) {
    foreach my $field (REQUIRED_FIELDS) {
	return FALSE unless exists $passport->{$field};
    }
    return TRUE;
}

sub add_fields_to_passport($line, $passport) {
    foreach my $key_value (split /\s/, $line) {
	my ($key, $value) = split /:/, $key_value;
	$passport->{$key} = $value;
    }
}

my $valid_passports = 0;
my $passport = start_passport();
while (my $line = <DATA>) {
    chomp $line;
    if ($line eq '') {
	$valid_passports++ if is_valid($passport);
	$passport = start_passport();
    }
    else {
	add_fields_to_passport($line, $passport);
    }
}
$valid_passports++ if is_valid($passport);

print "valid: $valid_passports\n";

__DATA__
ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in

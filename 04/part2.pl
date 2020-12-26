#!/usr/bin/env perl
use strict;
use warnings;

# use named subroutine parameters
use feature 'signatures';
no warnings 'experimental::signatures';
## no critic (ProhibitSubroutinePrototypes)

use constant TRUE  => 1;
use constant FALSE => 0;

my $FIELD_VALIDATIONS = {
    'byr' => sub {
	my $value = $_[0];
	return ($value =~ /^\d{4}$/
		and $value >= 1920
		and $value <= 2002);
    },
	'iyr' => sub {
	    my $value = $_[0];
	    return ($value =~ /^\d{4}$/
		    and $value >= 2010
		    and $value <= 2020);
    },
	'eyr' => sub {
	    my $value = $_[0];
	    return ($value =~ /^\d{4}$/
		    and $value >= 2020
		    and $value <= 2030);
    },
	'hgt' => sub {
	    my $value = $_[0];
	    return ($value =~ /^(\d+)(in|cm)$/
		    and ($2 eq 'cm' ?
			 ($1 >= 150 and $1 <= 193) : 
			 ($1 >=  59 and $1 <=  76)));
    },
	'hcl' => sub {
	    my $value = $_[0];
	    return ($value =~ /^#[0-9a-f]{6}$/);
    },
	'ecl' => sub {
	    my $value = $_[0];
	    return ($value =~ /^(amb|blu|brn|gry|grn|hzl|oth)$/);
    },
	'pid' => sub {
	    my $value = $_[0];
	    return ($value =~ /^\d{9}$/);
    },
    };

sub start_passport() {
    return {};
}

sub is_valid($passport) {
    foreach my $field (keys %{$FIELD_VALIDATIONS}) {
	my $validation = $FIELD_VALIDATIONS->{$field};
	my $value = $passport->{$field} // '';
	return FALSE unless $validation->($value);
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
eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007

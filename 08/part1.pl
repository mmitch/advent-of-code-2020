#!/usr/bin/env perl
use strict;
use warnings;

# use named subroutine parameters
use feature 'signatures';
no warnings 'experimental::signatures';
## no critic (ProhibitSubroutinePrototypes)

my $acc = 0;
my $pc  = 0;

use constant EXE => {
    'nop' => sub { $pc++; },
	'acc' => sub { $pc++; $acc+= $_[0]; },
	'jmp' => sub { $pc += $_[0]; },
};

my @program = ();
while (my $line = <DATA>) {
    chomp $line;
    die $line unless $line =~ /^([a-z]{3}) ([+-]\d+)$/;
    push @program, {
	INS => $1,
	ARG => $2,
	VIS => 0,
    };
}

while (1) {
    my $ins = $program[$pc]->{INS};
    my $arg = $program[$pc]->{ARG};

    EXE->{$ins}->($arg);

    last if $program[$pc]->{VIS} > 0;

    $program[$pc]->{VIS}++;
}

printf "looping!  last acc: %d,  next pc = %d\n", $acc, $pc;

__DATA__
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6

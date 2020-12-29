#!/usr/bin/env perl
use strict;
use warnings;

# use named subroutine parameters
use feature 'signatures';
no warnings 'experimental::signatures';
## no critic (ProhibitSubroutinePrototypes)

my $acc;
my $pc;

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

sub run_program()
{
    $pc  = 0;
    $acc = 0;
    $_->{VIS} = 0 foreach @program;
    
    while (1) {
	my $ins = $program[$pc]->{INS};
	my $arg = $program[$pc]->{ARG};
	
	EXE->{$ins}->($arg);
	
	return 1 if $pc == scalar @program;
	return 0 if $program[$pc]->{VIS} > 0;
	
	$program[$pc]->{VIS}++;
    }
}

sub test_variants() {
    for my $change ( 0 .. @program - 1 ) {
	my $old = $program[$change]->{INS};
	next if $old eq 'acc';
	
	if ($old eq 'nop') {
	    $program[$change]->{INS} = 'jmp';
	} else {
	    $program[$change]->{INS} = 'nop';
	}
	return 1 if run_program();
	$program[$change]->{INS} = $old;
    }
    
    return 0;
}

die unless test_variants();
printf "ended successfully!  last acc: %d,  next pc = %d\n", $acc, $pc;

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

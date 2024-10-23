#!/usr/bin/perl -w
use strict;

my $MIN_REP = $ARGV[0];
my $MAX_REP = $ARGV[1];

my $n = 200;
my $L = 1.1e6;
my $N = 1e4;
my $mu = 1.25e-8;
my $meanR = 1e-8;
my $theta = 4 * $N * $mu * $L;
my $meanRho = 4 * $N * $meanR * $L;

for(my $i = $MIN_REP; $i <= $MAX_REP; $i++) {
	my $line = sprintf("./discoal %d 1 %d -t %lf -Pre %lf %lf > Constant_neut_%d.ms", $n, $L, $theta, $meanRho, 3*$meanRho, $i);
	
	print $line, "\n\n";
	
	`$line`;
}

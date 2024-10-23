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


my $infreq_lower_log10 = log(0.001) / log(10);
my $infreq_upper_log10 = log(0.1) / log(10);
my $mutsel_lower_log10 = log(2 * $N * 0.005) / log(10);
my $mutsel_upper_log10 = log(2 * $N * 0.5) / log(10);
my $selend_lower = 0.0;
my $selend_upper = 1200 / (4 * $N);


for(my $i = $MIN_REP; $i <= $MAX_REP; $i++) {
	my $infreq = 10**( rand( $infreq_upper_log10 - $infreq_lower_log10 ) + $infreq_lower_log10 );
	my $mutsel = 10**( rand( $mutsel_upper_log10 - $mutsel_lower_log10 ) + $mutsel_lower_log10 );
	my $selend = rand( $selend_upper - $selend_lower ) + $selend_lower;
	
	my $line = sprintf("./discoal %d 1 %d -t %lf -Pre %lf %lf -ws %lf -a %lf -x 0.5 -f %lf > Constant_sweep_%d.ms", $n, $L, $theta, $meanRho, 3*$meanRho, $selend, $mutsel, $infreq, $i);
	
	print $line, "\n\n";
	
	`$line`;
}

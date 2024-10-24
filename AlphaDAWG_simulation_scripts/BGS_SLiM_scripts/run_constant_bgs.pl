#!/usr/bin/perl -w
use strict;

my $NREPS = $ARGV[0];

my $lambda = $ARGV[1];
my $mr = 1.25e-8;
my $sel = $ARGV[2]; # Either 0.1 or 0.5 for wearker or strong BGS
my $chr = 1100000;
my $mean_rr = 1e-8;
my $samp = 200;
my $size = 1e4;
my $tsamp = 12*$size;

for(my $i = 1; $i <= $NREPS; $i++) {
	my $rr = -$mean_rr * log( rand(1) );
	
	while($rr > 3*$mean_rr) {
		$rr = -$mean_rr * log( rand(1) );
	}
	
	my $line = sprintf("./slim -d d_mr=%e -d d_sel=%lf -d d_chr=%d -d d_rr=%e -d d_samp=%d -d d_size=%d constant.eidos | sed -n -e \"/#OUT/,\\\$p\" > output_%d.ms", $mr*$lambda, $sel*$lambda, $chr, $rr*$lambda, $samp, $size/$lambda, $i);

	`$line`;
}



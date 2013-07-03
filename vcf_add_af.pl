#!/usr/bin/env perl
#############################################
# Calculates allele frequency 
# based on nucleotide counts in 
# tab-delimited file assumed to come from 
# strelka SNV output and SnpSift extractFields
# (http://snpeff.sourceforge.net)
# Inserts columns AFTER the GEN[0].DP and GEN[1].DP fields.
# Uses stdin/stdout.
#############################################

use strict; 
use warnings;
#use Data::Dumper;
use List::Util qw(first);
#use List::MoreUtils qw(uniq);

# my @field_names = ();
# my @genotype_names = ();
# my $hash = {};
while (<>) { 
    print q(##FORMAT=<ID=AF,Number=1,Type=Float,Description="Allele fraction for tier1">),"\n" 
	if (/^##FORMAT=<ID=DP,/);
    if (/^#/) { print; next }
    chomp; my @F = split(/\t/);
    my $REF = $F[3];
    my $ALT = (split ",", $F[4])[0];
    my @FORMAT = split ":", $F[8];
    push @FORMAT, "AF";
#    print "@FORMAT\n";
    $F[8] = join ":", @FORMAT;
    my $iTIR = first { $FORMAT[$_] eq "TIR" } 0..$#FORMAT;
    my $iDP  = first { $FORMAT[$_] eq "DP" } 0..$#FORMAT;
    my $iNT = {};
    foreach my $nt ("A","C","G","T") {
	$iNT->{$nt} = first { $FORMAT[$_] eq $nt."U" } 0..$#FORMAT;
    }
    
    my $snvs_indels = "";
    if ( defined($iDP) && 
	 defined($iTIR) ) { $snvs_indels = "indels"; }
    elsif ( defined($iDP) &&
	    defined($iNT->{"A"}) &&
	    defined($iNT->{"C"}) &&
	    defined($iNT->{"G"}) &&
	    defined($iNT->{"T"}) ) { $snvs_indels = "snvs"; }
    else {
	die "Cannot find DP & TIR or DP, AU, CU, GU & TU fields";
    }
    
    for (9..$#F) {
	next if ($F[$_] eq "."); ### if genotype field is "." do nothing
	my $AF = "."; ### if genotype field is ".:.:.:.:.:.:." then add a dot for AF
	my @GT = split ":", $F[$_];
	my $DP = $GT[$iDP];
	if ($DP ne "."){
	    my $DP_ALT = 0;
	    if ($snvs_indels eq "snvs") { 
		$DP_ALT = (split ",", $GT[$iNT->{$ALT}])[0]; 
	    } elsif ($snvs_indels eq "indels") { 
		$DP_ALT = (split ",", $GT[$iTIR])[0]; 
	    }
	    
	    if ($DP == 0){
		$AF = 0;
	    } else {
		$AF = $DP_ALT / $DP;
	    }
	    $AF = sprintf("%.3f", $AF);
	}
	push @GT, $AF;
#	print "$DP_ALT\n";
	$F[$_] = join ":", @GT;
    }
    
    print join("\t", @F), "\n";		      
    
}

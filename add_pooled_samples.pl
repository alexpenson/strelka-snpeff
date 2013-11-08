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
#use Math::Round;

my @input_field_names = ();
my %hash = ();
while (<>) { 
    chomp;
    if ($. == 1) { 
	### READ COLUMN NAMES
	@input_field_names = split(/\t/); 
	
	### WRITE COLUMN NAMES (WITH NEW ONES INSERTED)
	# [] for array ref
	my $output_header = join("\t", insert_normal_tumor_columns(\@input_field_names, \@input_field_names, ['normal_FREQ','normal_DP'],['tumor_FREQ','tumor_DP']));
	$output_header =~ s/GEN\[0\]./blood_/g;
	$output_header =~ s/GEN\[1\]./n1_/g;
	$output_header =~ s/GEN\[2\]./n2_/g;
	$output_header =~ s/GEN\[3\]./t1_/g;
	$output_header =~ s/GEN\[4\]./t2_/g;
	print "$output_header\n";
	next;
    }
    
    
### READ FIELDS
    my @input_fields = split(/\t/);
    @hash{@input_field_names} = split(/\t/);
    
    my $n1_freq = $hash{'GEN[1].FREQ'};
    my $n2_freq = $hash{'GEN[2].FREQ'};
    my $t1_freq = $hash{'GEN[3].FREQ'};
    my $t2_freq = $hash{'GEN[4].FREQ'};
    my $n1_dp = $hash{'GEN[1].DP'};
    my $n2_dp = $hash{'GEN[2].DP'};
    my $t1_dp = $hash{'GEN[3].DP'};
    my $t2_dp = $hash{'GEN[4].DP'};
    
    my $nc_dp = $n1_dp + $n2_dp;
    my $tc_dp = $t1_dp + $t2_dp;
    my $nc_freq = ($n1_freq * $n1_dp + $n2_freq * $n2_dp) / $nc_dp;
    my $tc_freq = ($t1_freq * $t1_dp + $t2_freq * $t2_dp) / $tc_dp;
#     print join("\t", 
# 	       $t1_freq,
# 	       $t1_dp,
# 	       $t2_freq,
# 	       $t2_dp,
# 	       ($t1_freq * $t1_dp),
# 	       ($t2_freq * $t2_dp),
# 	       $tc_freq,
# 	       $tc_dp,
# 	), "\n";

    
    print join("\t", 
	       insert_normal_tumor_columns(
		   \@input_field_names, 
		   \@input_fields, 
		   [sprintf("%.2f",$nc_freq),$nc_dp], 
		   [sprintf("%.2f",$tc_freq),$tc_dp]
	       )
	), "\n";
### debug: one line only
#    exit 
}

sub insert_normal_tumor_columns {
    ### this function inserts entries into each line taken from the input file
    ### an entry for normal and tumor are are inserted AFTER columns named:
    ### DO NOT modify the input arrays
    my $normal_column_name = 'GEN[2].DP';
    my $tumor_column_name = 'GEN[4].DP';

    my ($input_field_names) = shift; ### from first line (header) of the input file
    my ($input_fields) = shift;
    my ($normal_fields) = shift;
    my ($tumor_fields) = shift;

    my $normal_index = first { $input_field_names->[$_] eq $normal_column_name } 0..$#$input_field_names;
    my $tumor_index  = first { $input_field_names->[$_] eq $tumor_column_name  } 0..$#$input_field_names;
    my @output_fields = @$input_fields;
    splice ( @output_fields, $normal_index+1, 0, @$normal_fields );
    ### assume the normal fields are the the left of the tumor fields!!
    ### increase tumor index accordingly
    splice ( @output_fields, $tumor_index+1+$#$normal_fields+1,  0, @$tumor_fields  );
    return @output_fields;
}

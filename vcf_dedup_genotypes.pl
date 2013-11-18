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
use Data::Dumper;
use List::Util qw(first);
use List::MoreUtils qw(uniq);
#use Math::Round;

my @field_names = ();
my @genotype_names = ();
my $hash = {};
#my ($normal_depth_index, $tumor_depth_index);
#my @nt = ("A","C","G","T");
while (<>) { 
    if (/^##/) { print; next }
    chomp;
    if (/^#CHROM/) { 
	### READ COLUMN NAMES
	@field_names = split(/\t/); 
	### numerically sort
#	@genotype_names = sort {$a <=> $b} (
	### lexically sort
	@genotype_names = uniq (@field_names[9..$#field_names]);
	@genotype_names = sort (@genotype_names);
# 	print "@genotype_names\n";
# 	print Dumper($hash);
	print join("\t", (@field_names[0..8],@genotype_names)), "\n";
	next;
    }

    
    ### READ FIELDS
    my @input_fields = split(/\t/);

    ### RESET HASH OF GENOTYPE INFO
    @$hash{@genotype_names} = (".") x scalar @genotype_names;
    for (9..$#field_names) {
	next if ($input_fields[$_] eq "." );
	next if ($input_fields[$_] eq ".:.:.:.:.:.:.:." );
#	print $field_names[$_],"\t",$input_fields[$_],"\n";
	if ($hash->{$field_names[$_]} ne $input_fields[$_]) {
# 	    if ( $hash->{$field_names[$_]} ne "." ) {
# 		warn("two entries for genotype $genotype_names[$_]:");
# 		warn($hash->{$field_names[$_]});
# 		warn($input_fields[$_]);
# 	    }
	    $hash->{$field_names[$_]} = $input_fields[$_];
	} 
    }

    ### replace . with .:.:.:.:.:.:.:.:.:.:.
    my $N_FORMAT_FIELDS = scalar split(":", $input_fields[8]);
    while ( my ($genotype_name, $field) = each %$hash ) {
	if ($field eq ".") {
	    $hash->{$genotype_name} = "." . ":." x ($N_FORMAT_FIELDS - 1);
	}
    }
#    print @$hash->{@genotype_names},"\n";
    print join("\t", (@input_fields[0..8],@$hash{@genotype_names})), "\n"; 
}
#     @hash{@input_field_names} = split(/\t/);

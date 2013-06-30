
# ### first argument is the stats html produced by "snpEff eff"
# if [[ $# -eq 0 ]]; then
#     EFF_STATS="-noStats"
# else
#     EFF_STATS="-stats $1"
#     echo "writing output stats html to $1" >&2 ### write to STDERR
# ### "-csvStats"
# fi

strelka_results=$1; shift
output_prefix=$1; shift

# input_vcf=$( readlink -m $1 ); shift
# output_prefix=${input_vcf/%.vcf/} ### remove trailing ".vcf"

SNPEFF_HOME=/ifs/scratch/c2b2/rr_lab/shares/snpEff
SNPEFF="-jar $SNPEFF_HOME/snpEff.jar -c $SNPEFF_HOME/snpEff.config"
SNPSIFT="-jar $SNPEFF_HOME/SnpSift.jar"

### "SnpSift extractFields" and
### "SnpSift annotate" 
### requires input file as an argument (although it can be - for STDIN)

cat >&2 <<EOF
reading from strelka results folder:
$strelka_results

writing files:
$output_prefix.$snvs_indels.ann.vcf
$output_prefix.$snvs_indels.tsv
EOF


for snvs_indels in snvs indels; do
    (java -Xmx2G  $SNPSIFT annotate $SNPEFF_HOME/dbSnp132.vcf -v - | \
	java -Xmx70m $SNPSIFT filter   "( ! exists ID  )") \
	< $strelka_results/passed.somatic.${snvs_indels}.vcf \
	> $output_prefix.$snvs_indels.dbSnp.vcf
    
    (java -Xmx4G  $SNPEFF  GRCh37.70 -noStats -v -cancer -canon -no-downstream -no-upstream -no-intergenic -no-intron -no-utr | \
	java -Xmx2G  $SNPSIFT annotate $SNPEFF_HOME/dbSnp.vcf -v -) \
	< $output_prefix.$snvs_indels.dbSnp.vcf \
	> $output_prefix.$snvs_indels.ann.vcf
done    

snvs_indels=snvs
($SNPEFF_HOME/scripts/vcfEffOneNSyn.pl | \
    java -Xmx70m $SNPSIFT extractFields - \
    CHROM POS ID REF ALT \
    GEN[1].DP GEN[1].AU[0] GEN[1].CU[0] GEN[1].GU[0] GEN[1].TU[0] \
    GEN[0].DP GEN[0].AU[0] GEN[0].CU[0] GEN[0].GU[0] GEN[0].TU[0] \
    "EFF[*].EFFECT" "EFF[*].IMPACT" "EFF[*].FUNCLASS" "EFF[*].CODON" \
    "EFF[*].AA" "EFF[*].AA_LEN" "EFF[*].GENE" "EFF[*].BIOTYPE" \
    "EFF[*].CODING" "EFF[*].TRID" "EFF[*].RANK" | \
    /ifs/scratch/c2b2/rr_lab/shares/forNoddy/allele_freq_${snvs_indels}_strelka_snpEff.pl) \
    < $output_prefix.$snvs_indels.ann.vcf \
    > $output_prefix.$snvs_indels.tsv

snvs_indels=indels
($SNPEFF_HOME/scripts/vcfEffOneNSyn.pl | \
    java -Xmx4G -jar /ifs/scratch/c2b2/rr_lab/shares/snpEff/SnpSift.jar extractFields - \
    CHROM POS ID REF ALT \
    QSI SGT RC IC IHP \
    GEN[1].DP GEN[1].TIR[0] \
    GEN[0].DP GEN[0].TIR[0] \
    "EFF[*].EFFECT" "EFF[*].IMPACT" "EFF[*].FUNCLASS" "EFF[*].CODON" "EFF[*].AA" \
    "EFF[*].AA_LEN" "EFF[*].GENE" "EFF[*].BIOTYPE" "EFF[*].CODING" "EFF[*].TRID" "EFF[*].RANK" | \
    /ifs/scratch/c2b2/rr_lab/shares/forNoddy/allele_freq_${snvs_indels}_strelka_snpEff.pl) \
    < $output_prefix.$snvs_indels.ann.vcf \
    > $output_prefix.$snvs_indels.tsv

# \
# dbnsfpEnsembl_transcriptid dbnsfpUniprot_acc dbnsfp29way_logOdds \
# dbnsfp1000Gp1_AF dbnsfpPolyphen2_HVAR_pred dbnsfpInterpro_domain dbnsfpSIFT_score
# java -Xmx4G  $SNPSIFT dbnsfp   $SNPEFF_HOME/dbNSFP2.0.txt -v - > $prefix.eff.dbSnp.dbNSFP.vcf
# cat $prefix.eff.dbSnp.dbNSFP.vcf | java -Xmx4G $SNPSIFT extractFields - CHROM POS ID REF ALT GEN[1].DP GEN[1].AU[0] GEN[1].CU[0] GEN[1].GU[0] GEN[1].TU[0] GEN[0].DP GEN[0].AU[0] GEN[0].CU[0] GEN[0].GU[0] GEN[0].TU[0]\
#  "EFF[*].EFFECT" "EFF[*].IMPACT" "EFF[*].FUNCLASS" "EFF[*].CODON" "EFF[*].AA" "EFF[*].AA_LEN" "EFF[*].GENE" "EFF[*].BIOTYPE" "EFF[*].CODING" "EFF[*].TRID" "EFF[*].RANK" dbnsfpEnsembl_transcriptid dbnsfpUniprot_acc dbnsfp29way_logOdds dbnsfp1000Gp1_AF\
#  dbnsfpPolyphen2_HVAR_pred dbnsfpInterpro_domain dbnsfpSIFT_score > $prefix.eff.dbSnp.dbNSFP.tsv 
# cat $prefix.eff.dbSnp.dbNSFP.tsv | /ifs/scratch/c2b2/rr_lab/shares/forNoddy/allele_freq_strelka_snpEff.pl > $prefix.eff.dbSnp.dbNSFP.AF.tsv
# cat $prefix.eff.dbSnp.dbNSFP.AF.tsv | grep -v 'rs' | grep 'NON_SYNONYMOUS_CODING' | awk -F'\t' '$7>.20' | awk -F'\t' '$6>8' > $prefix.FILT.tsv

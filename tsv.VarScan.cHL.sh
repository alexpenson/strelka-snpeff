SNPEFF_HOME=/ifs/scratch/c2b2/rr_lab/shares/snpEff
SNPEFF="-jar $SNPEFF_HOME/snpEff.jar -c $SNPEFF_HOME/snpEff.config"
SNPSIFT="-jar $SNPEFF_HOME/SnpSift.jar"

# java -Xmx4G  $SNPEFF  GRCh37.71 -noStats -v -lof -cancer -canon -no-downstream -no-upstream -no-intergenic -no-intron -no-utr $input > $output_prefix.eff.vcf
# java -Xmx1G  $SNPSIFT annotate $SNPEFF_HOME/dbSnp138.vcf -v $output_prefix.eff.vcf > $output_prefix.eff.dbSnp.vcf
# java -Xmx1G  $SNPSIFT annotate /ifs/scratch/c2b2/rr_lab/shares/ref/COSMIC/CosmicVariants_v66_20130725.vcf -v $output_prefix.eff.dbSnp.vcf > $output_prefix.eff.dbSnp.cosmic.vcf

$SNPEFF_HOME/scripts/vcfEffOneHigh.pl | \
    java -Xmx70m $SNPSIFT extractFields - \
    CHROM POS ID REF ALT \
    "GEN[0].FREQ" "GEN[0].DP" "GEN[0].ADF" \
    "GEN[1].FREQ" "GEN[1].DP" "GEN[1].ADF" \
    "GEN[2].FREQ" "GEN[2].DP" "GEN[2].ADF" \
    "GEN[3].FREQ" "GEN[3].DP" "GEN[3].ADF" \
    "GEN[4].FREQ" "GEN[4].DP" "GEN[4].ADF" \
    "EFF[*].EFFECT" "EFF[*].IMPACT" "EFF[*].FUNCLASS" "EFF[*].CODON" \
    "EFF[*].AA" "EFF[*].AA_LEN" "EFF[*].GENE" "EFF[*].BIOTYPE" \
    "EFF[*].CODING" "EFF[*].TRID" "EFF[*].RANK" dbSNPBuildID COSMIC_NSAMP N

# $SNPEFF_HOME/scripts/vcfEffOneHigh.pl | \
#     java -Xmx70m $SNPSIFT extractFields - \
#     CHROM POS ID REF ALT \
#     "GEN[0].FREQ" "GEN[0].DP" \
#     "GEN[1].FREQ" "GEN[1].DP" \
#     "GEN[2].FREQ" "GEN[2].DP" \
#     "GEN[3].FREQ" "GEN[3].DP" \
#     "GEN[4].FREQ" "GEN[4].DP" \
#     "EFF[*].EFFECT" "EFF[*].IMPACT" "EFF[*].FUNCLASS" "EFF[*].CODON" \
#     "EFF[*].AA" "EFF[*].AA_LEN" "EFF[*].GENE" "EFF[*].BIOTYPE" \
#     "EFF[*].CODING" "EFF[*].TRID" "EFF[*].RANK" dbSNPBuildID COSMIC_NSAMP 


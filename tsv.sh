SNPEFF_HOME=/ifs/scratch/c2b2/rr_lab/shares/snpEff-v3.3
SNPEFF="-jar $SNPEFF_HOME/snpEff.jar -c $SNPEFF_HOME/snpEff.config"
SNPSIFT="-jar $SNPEFF_HOME/SnpSift.jar"

$SNPEFF_HOME/scripts/vcfEffOneHigh.pl | \
    /ifs/scratch/c2b2/rr_lab/shares/strelka-snpeff/vcf_add_af.pl | \
    java -Xmx70m $SNPSIFT extractFields - \
    CHROM POS ID REF ALT \
    "GEN[0].AF" "GEN[0].DP" \
    "GEN[1].AF" "GEN[1].DP" \
    "EFF[*].EFFECT" "EFF[*].IMPACT" "EFF[*].FUNCLASS" "EFF[*].CODON" \
    "EFF[*].AA" "EFF[*].AA_LEN" "EFF[*].GENE" "EFF[*].BIOTYPE" \
    "EFF[*].CODING" "EFF[*].TRID" "EFF[*].RANK" \
    dbSNPBuildID COSMIC_NSAMP SGT QSS \
    dbNSFP_Polyphen2_HVAR_pred dbNSFP_SIFT_score


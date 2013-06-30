SNPEFF_HOME=/ifs/scratch/c2b2/rr_lab/shares/snpEff
SNPEFF="-jar $SNPEFF_HOME/snpEff.jar -c $SNPEFF_HOME/snpEff.config"
SNPSIFT="-jar $SNPEFF_HOME/SnpSift.jar"

$SNPEFF_HOME/scripts/vcfEffOneHigh.pl | \
    java -Xmx70m $SNPSIFT extractFields - \
    CHROM POS ID REF ALT \
    "GEN[*].AF" "GEN[*].DP" \
    "EFF[*].EFFECT" "EFF[*].IMPACT" "EFF[*].FUNCLASS" "EFF[*].CODON" \
    "EFF[*].AA" "EFF[*].AA_LEN" "EFF[*].GENE" "EFF[*].BIOTYPE" \
    "EFF[*].CODING" "EFF[*].TRID" "EFF[*].RANK"


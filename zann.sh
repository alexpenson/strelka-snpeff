SNPEFF_HOME=/ifs/scratch/c2b2/rr_lab/shares/snpEff
SNPEFF="-jar $SNPEFF_HOME/snpEff.jar -c $SNPEFF_HOME/snpEff.config"
SNPSIFT="-jar $SNPEFF_HOME/SnpSift.jar"

zcat | \
    java -Xmx3G  $SNPEFF  GRCh37.70 -noStats -v -lof -cancer -canon -no-downstream -no-upstream -no-intergenic -no-intron -no-utr | \
    java -Xmx1G  $SNPSIFT annotate $SNPEFF_HOME/dbSnp.vcf -v - | \
    java -Xmx1G  $SNPSIFT annotate /ifs/scratch/c2b2/rr_lab/shares/ref/COSMICv64/CosmicVariants_v64_02042013_noLimit.vcf -v - | \
    gzip -c

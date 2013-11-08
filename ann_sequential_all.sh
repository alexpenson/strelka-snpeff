SNPEFF_HOME=/ifs/scratch/c2b2/rr_lab/shares/snpEff
SNPEFF="-jar $SNPEFF_HOME/snpEff.jar -c $SNPEFF_HOME/snpEff.config"
SNPSIFT="-jar $SNPEFF_HOME/SnpSift.jar"

input=$1; shift
output_prefix=$1; shift

java -Xmx5G  $SNPEFF  GRCh37.71 -noStats -v \
    -lof \
    -interval $SNPEFF_HOME/db/encode/wgEncodeDukeDnase8988T.fdr01peaks.hg19.bb \
    -nextprot \
    -motif \
    -cancer \
    -canon \
    -no-downstream -no-upstream -no-intergenic -no-intron -no-utr \
    $input \
    > $output_prefix.eff.vcf
java -Xmx1G  $SNPSIFT annotate $SNPEFF_HOME/dbSnp.vcf -v $output_prefix.eff.vcf > $output_prefix.eff.dbSnp.vcf
java -Xmx1G  $SNPSIFT annotate /ifs/scratch/c2b2/rr_lab/shares/ref/COSMICv64/CosmicVariants_v64_02042013_noLimit.vcf -v $output_prefix.eff.dbSnp.vcf > $output_prefix.eff.dbSnp.cosmic.vcf

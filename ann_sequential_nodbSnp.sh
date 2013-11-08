SNPEFF_HOME=/ifs/scratch/c2b2/rr_lab/shares/snpEff-v3.3
SNPEFF="-jar $SNPEFF_HOME/snpEff.jar -c $SNPEFF_HOME/snpEff.config"
SNPSIFT="-jar $SNPEFF_HOME/SnpSift.jar"

input=$1; shift
output_prefix=${input/.vcf/}

java -Xmx4G  $SNPEFF  GRCh37.71 -noStats -v -lof -cancer -canon -no-downstream -no-upstream -no-intergenic -no-intron -no-utr $input > $output_prefix.eff.vcf
#java -Xmx1G  $SNPSIFT annotate $SNPEFF_HOME/dbSnp138.vcf -v $output_prefix.eff.vcf > $output_prefix.eff.dbSnp.vcf
java -Xmx1G  $SNPSIFT annotate /ifs/scratch/c2b2/rr_lab/shares/ref/COSMIC/CosmicVariants_v66_20130725.vcf -v $output_prefix.eff.vcf > $output_prefix.eff.cosmic.vcf

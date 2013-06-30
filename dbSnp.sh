SNPEFF_HOME=/ifs/scratch/c2b2/rr_lab/shares/snpEff
SNPEFF="-jar $SNPEFF_HOME/snpEff.jar -c $SNPEFF_HOME/snpEff.config"
SNPSIFT="-jar $SNPEFF_HOME/SnpSift.jar"

java -Xmx4G  $SNPSIFT annotate $SNPEFF_HOME/dbSnp132.vcf -v - | \
    java -Xmx70m $SNPSIFT filter   "( ! exists ID  )"
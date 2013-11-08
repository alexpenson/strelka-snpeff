SNPEFF_HOME=/ifs/scratch/c2b2/rr_lab/shares/snpEff-v3.3
SNPEFF="-jar $SNPEFF_HOME/snpEff.jar -c $SNPEFF_HOME/snpEff.config"
SNPSIFT="-jar $SNPEFF_HOME/SnpSift.jar"

java -Xmx3G  $SNPSIFT annotate $SNPEFF_HOME/dbSnp138.vcf -v - | \
    java -Xmx70m $SNPSIFT filter   "( ! exists ID  )"

SNPEFF_HOME=/ifs/scratch/c2b2/rr_lab/shares/snpEff-v3.3
# SNPEFF="-jar $SNPEFF_HOME/snpEff.jar -c $SNPEFF_HOME/snpEff.config"
# SNPSIFT="-jar $SNPEFF_HOME/SnpSift.jar"

java -Xmx3G -jar $SNPEFF_HOME/SnpSift.jar annotate $SNPEFF_HOME/dbSnp138.vcf -v - | \
    java -Xmx70m -jar $SNPEFF_HOME/SnpSift.jar filter "( exists ID  )"

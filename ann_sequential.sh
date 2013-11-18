SNPEFF_HOME=/ifs/scratch/c2b2/rr_lab/shares/snpEff-v3.3
SNPEFF="-jar $SNPEFF_HOME/snpEff.jar -c $SNPEFF_HOME/snpEff.config"
SNPSIFT="-jar $SNPEFF_HOME/SnpSift.jar"

input=$1; shift
output_prefix=${input/.vcf/}

java -Xmx4G -jar $SNPEFF_HOME/snpEff.jar -v \
    -c $SNPEFF_HOME/snpEff.config GRCh37.71 \
    -spliceSiteSize 4 \
    -noStats \
    -lof \
    -cancer \
    -canon \
    -no-downstream \
    -no-upstream \
    -no-intergenic \
    $input \
    > $output_prefix.eff.vcf
java -Xmx4G -jar $SNPEFF_HOME/SnpSift.jar annotate -v \
    $SNPEFF_HOME/dbSnp138.vcf \
    $output_prefix.eff.vcf \
    > $output_prefix.eff.dbSnp.vcf
java -Xmx4G -jar $SNPEFF_HOME/SnpSift.jar \
    annotate -v \
    /ifs/scratch/c2b2/rr_lab/shares/ref/COSMIC/CosmicVariants_v67_20131024.vcf \
    $output_prefix.eff.dbSnp.vcf \
    > $output_prefix.eff.dbSnp.cosmic.vcf
# java -Xmx4G -jar $SNPEFF_HOME/SnpSift.jar \
#     dbnsfp -v -a \
#     $SNPEFF_HOME/dbNSFP2.1.txt \
#     $output_prefix.eff.dbSnp.cosmic.vcf \
#     > $output_prefix.eff.dbSnp.cosmic.dbNSFP.vcf
# sed -i 's/GERP++/GERP/gi' $output_prefix.eff.dbSnp.cosmic.dbNSFP.vcf ### remove plus signs in GERP++ which can screw up downstream tools
#    -f SIFT_pred,Polyphen2_HDIV_pred,Polyphen2_HVAR_pred,LRT_pred,MutationTaster_pred,MutationAssessor_pred,FATHMM_pred \

rm $output_prefix.eff.vcf $output_prefix.eff.dbSnp.vcf #$output_prefix.eff.dbSnp.cosmic.vcf


#!/bin/bash
## merges snvs and indels in strelka output folders called $patient-b-t1 and $patient-b-t2
patient=$1; shift

# directory for the merged files
mkdir $patient

# rename INFO fields in tumor2
# sed 's/QSI/QSI2/g' $patient-b-t2/results/passed.somatic.indels.vcf > $patient-b-t2/results/passed.somatic.indels2.vcf
# sed -e 's/QSS/QSS2/g' -e 's/SGT/SGT2/g' $patient-b-t2/results/passed.somatic.snvs.vcf > $patient-b-t2/results/passed.somatic.snvs2.vcf

function bgzip_tabix_vcf {
    for i in "$@"; do
        bgzip $i
        tabix -p vcf $i.gz
    done
}

# bgzip_tabix_vcf $patient-b-t1/results/passed.somatic.indels.vcf $patient-b-t1/results/passed.somatic.snvs.vcf
# bgzip_tabix_vcf $patient-b-t2/results/passed.somatic.indels2.vcf $patient-b-t2/results/passed.somatic.snvs2.vcf

# merge tumor1 and tumor2
for i in snv indel; do
    
#    bgzip_tabix_vcf $patient-b-t1/results/passed.somatic.${i}s.vcf.gz $patient-b-t2/results/passed.somatic.${i}s2.vcf

    bcftools merge $patient-b-t1/results/passed.somatic.${i}s.vcf.gz $patient-b-t2/results/passed.somatic.${i}s2.vcf.gz \
    | ./replace_sample.sed \
    | /ifs/scratch/c2b2/rr_lab/shares/strelka-snpeff/vcf_dedup_genotypes.pl \
    | /ifs/scratch/c2b2/rr_lab/shares/strelka-snpeff/vcf_add_af.pl \
    | grep -v ".:.:.:.:.:.:.:.:." \
    > $patient/passed.somatic.${i}s.filt.vcf
done
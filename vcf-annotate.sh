#!/bin/bash

/ifs/scratch/c2b2/rr_lab/shares/vcftools/bin/vcf-annotate -a /ifs/scratch/c2b2/rr_lab/shares/snpEff-v3.3/dbNSFP2.1_variant.chr1.gz \
-d desc.txt \
-c CHROM,FROM,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,SIFT_score,SIFT_score_converted,SIFT_pred,Polyphen2_HDIV_score,Polyphen2_HDIV_pred,Polyphen2_HVAR_score,Polyphen2_HVAR_pred,LRT_score,LRT_score_converted,LRT_pred,MutationTaster_score,MutationTaster_score_converted,MutationTaster_pred,MutationAssessor_score,MutationAssessor_score_converted,MutationAssessor_pred,FATHMM_score,FATHMM_score_converted,FATHMM_pred,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-
#-c CHROM,FROM,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,SIFT_score,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,- \
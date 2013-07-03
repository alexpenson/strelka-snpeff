#$ -pe smp 8
STRELKA_INSTALL_DIR=/ifs/scratch/c2b2/rr_lab/shares/strelka_workflow-1.0.5
ref_bwa_genome=/ifs/scratch/c2b2/rr_lab/shares/ref/hg19/bwa/genome/hg19.fa
config=$STRELKA_INSTALL_DIR/etc/strelka_config_bwa_default.ini

tumor=$1; shift			### bam file
normal=$1; shift
outputdir=$1; shift		### error if outputdir exists

$STRELKA_INSTALL_DIR/bin/configureStrelkaWorkflow.pl --tumor=$tumor --normal=$normal --ref=$ref_bwa_genome --config=$config --output-dir=$outputdir
make -j 8 -C $outputdir

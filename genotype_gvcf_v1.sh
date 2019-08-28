#!/bin/bash
#PBS -l mem=62gb,nodes=1:ppn=12,walltime=96:00:00
#PBS -m abe
#PBS -M rmoran@umn.edu
#PBS -q mcgaugh
#PBS -N genomeV1_genotyping
#PBS -j oe

echo -n "Ran: "
date

# Load modules
module load java

# Set paths
#   V1
REF="/home/mcgaughs/shared/References/Astyanax_mexicanus_102/Astyanax_mexicanus.AstMex102.dna.toplevel.fa"
GVCF_DIR="/home/mcgaughs/shared/Datasets/per_individual.g.vcfs/v1_cavefish/gvcfs"
REGION="/home/mcgaughs/shared/References/Astyanax_mexicanus_102"
OUTDIR="/home/mcgaughs/shared/Datasets/all_sites_LARGE_gvcf/raw_cavefish"

#fix path to GATK
GATK="/home/mcgaughs/shared/Software/GenomeAnalysisTK-3.8-0-ge9d806836/GenomeAnalysisTK.jar"


SAMPLE_LIST=($(find ${GVCF_DIR} -maxdepth 1 -name '*.g.vcf.gz' | sort -V))

GATK_IN=()
for s in "${SAMPLE_LIST[@]}"
do
    GATK_IN+=("-V $s")
done


export _JAVA_OPTIONS="-Xmx61000m"
java -Djava.io.tmpdir=/panfs/roc/scratch/rmoran/java_tmp \
    -jar ${GATK} \
    -T GenotypeGVCFs \
    -R ${REF} \
    -L ${REGION}/vcf_intervals.list \
    -nt 12 \
    ${GATK_IN[@]} \
    --heterozygosity 0.005 \
    --includeNonVariantSites \
    -o ${OUTDIR}/Cavefish_v1_186samples.wInvariant.vcf 

echo -n "Done: "
date


cd /home/mcgaughs/shared/Datasets/all_sites_LARGE_gvcf/raw_cavefish; chmod 770 Cavefish_v1_186samples.wInvariant.vcf

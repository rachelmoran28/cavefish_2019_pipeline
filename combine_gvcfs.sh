#!/bin/bash
#PBS -l mem=16gb,nodes=1:ppn=1,walltime=48:00:00
#PBS -m abe
#PBS -M rmoran@umn.edu
#PBS -q mesabi
#PBS -t 1-21

# Load modules
module load java

# Set paths
GATK="/panfs/roc/groups/14/mcgaughs/shared/Software/GenomeAnalysisTK-3.8-0-ge9d806836/GenomeAnalysisTK.jar"
#   V2
REF="/home/mcgaughs/shared/References/2017-09_Astyanax_mexicanus/7994_ref_Astyanax_mexicanus-2.0_Complete_gbID.fa"
GVCF_DIR="/home/mcgaughs/shared/Datasets/per_individual.g.vcfs/v2_surfacefish/gvcfs"
OUTPUT_DIR="/home/mcgaughs/shared/Datasets/all_sites_LARGE_gvcf/raw_surfacefish/combined_gvcf"

#Combine GVCFs based on population
POPS=("Aeneus" "Arroyo" "Asty" "CabMoro" "Chica1" "Chica5" "Choy" "Escon" "Gallinas" "Jineo" "Mante" "Molino" "Nicara" "Pachon" "Peroles" "Rascon" "Subter" "Surface" "Tigre" "Tinaja" "Vasquez")
CURR_POP=${POPS[${PBS_ARRAYID}]}

# Build the sample list
SAMPLE_LIST=($(find ${GVCF_DIR} -name '*.g.vcf.gz' | grep ${CURR_POP} |  sort -V))

# Put them into a format that will be accepted by the GATK command line
GATK_IN=()
for s in "${SAMPLE_LIST[@]}"
do
    GATK_IN+=("-V $s")
done

mkdir -p ${OUTPUT_DIR}

export _JAVA_OPTIONS="-Xmx15000m -Djava.io.tmpdir=/panfs/roc/scratch/rmoran/java_tmp"
java -jar ${GATK} \
    -T CombineGVCFs \
    -R ${REF} \
    ${GATK_IN[@]} \
    -o ${OUTPUT_DIR}/${CURR_POP}_Comb.g.vcf.gz

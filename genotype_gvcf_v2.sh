#!/bin/bash
#PBS -l mem=998gb,nodes=1:ppn=32,walltime=96:00:00
#PBS -m abe
#PBS -M rmoran@umn.edu
#PBS -q ram1t
#PBS -N genomeV2_genotyping
#PBS -j oe
#PBS -t 1-26

# Load modules
module load java

# Set paths
GATK="/home/mcgaughs/shared/Software/GenomeAnalysisTK-3.8-0-ge9d806836/GenomeAnalysisTK.jar"
#   V2
REF="/home/mcgaughs/shared/References/2017-09_Astyanax_mexicanus/7994_ref_Astyanax_mexicanus-2.0_Complete_gbID.fa"
#  

REGFOF="/home/mcgaughs/shared/References/2017-09_Astyanax_mexicanus/GATK_Regions.fof"
GVCF_DIR="/home/mcgaughs/shared/Datasets/per_individual.g.vcfs/v2_surfacefish/gvcfs"

OUTPUT_DIR="/home/mcgaughs/shared/Datasets/all_sites_LARGE_gvcf/raw_surfacefish" 

# Build the sample list
SAMPLE_LIST=($(find ${GVCF_DIR} -maxdepth 1 -name '*.g.vcf.gz' | sort -V))
# Put them into a format that will be accepted by the GATK command line
GATK_IN=()
for s in "${SAMPLE_LIST[@]}"
do
    GATK_IN+=("-V $s")
done

# We have defined a file-of-files that lists regions to operate over. This is
# because we want to separate variant calling by chromosome. Chromosomes 1-25
# have their own files and all of the unmapped contigs get their own file
REGION=$(sed "${PBS_ARRAYID}q;d" ${REGFOF})
# We define the output region based on the basename of the intervals file that
# was read from the file-of-files
REG_BNAME=$(basename ${REGION})
REG_OUT=${REG_BNAME/.intervals/}

export _JAVA_OPTIONS="-Xmx990g"
java -Djava.io.tmpdir=/scratch.local \
    -jar ${GATK} \
    -T GenotypeGVCFs \
    -R ${REF} \
    -L ${REGION} \
    -nt 32 \
    ${GATK_IN[@]} \
    --includeNonVariantSites \
    --heterozygosity 0.005 \
    -o ${OUTPUT_DIR}/${REG_OUT}_Surfacefish_v2_186samples_wInvariant.vcf


echo -n "Done: "
date


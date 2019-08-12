#!/bin/bash
#PBS -l mem=126gb,nodes=1:ppn=16,walltime=10:00:00 
#PBS -m abe 
#PBS -j oe
#PBS -M rmoran@umn.edu
#PBS -q sb128
#PBS -N split_full_bams
#PBS -t 1-118

module load samtools/1.7


#Cave fish genome
export BAM_DIR="/home/mcgaughs/shared/Datasets/bams/cave.fish.reference.genome/v1_cavefish_raw_bams"
export MAP_DIR="/home/mcgaughs/shared/Datasets/bams/cave.fish.reference.genome/v1_cavefish_mapped_reads"
export UNMAP_DIR="/home/mcgaughs/shared/Datasets/bams/cave.fish.reference.genome/v1_cavefish_unmapped_reads"

#Surface genome
#export BAM_DIR="/home/mcgaughs/shared/Datasets/bams/surface.fish.reference.genome/v2_surfacefish_raw_bams"
#export MAP_DIR="/home/mcgaughs/shared/Datasets/bams/surface.fish.reference.genome/v2_surfacefish_mapped_reads"
#export UNMAP_DIR="/home/mcgaughs/shared/Datasets/bams/surface.fish.reference.genome/v2_surfacefish_unmapped_reads"

# Get a list of the input alignments
ALNS=($(find ${BAM_DIR} -maxdepth 1 -name '*_rgadd.bam' | sort -V))

# Use PBS_ARRAYID to get a sample to process
C_ALN=${ALNS[${PBS_ARRAYID}]}

# Get the sample name from the file name. We will use the sample name for the
# sample flags
bname=$(basename ${C_ALN})
sample=${bname/.bam}

samtools view -hb -@ 16 -f 4 ${C_ALN} > ${UNMAP_DIR}/${sample}_unmapped.bam
samtools view -hb -@ 16 -F 260 ${C_ALN} > ${MAP_DIR}/${sample}_mapped.bam

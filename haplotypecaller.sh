#!/bin/bash
#PBS -l mem=62gb,nodes=1:ppn=24,walltime=20:00:00
#PBS -m abe
#PBS -M rmoran@umn.edu
#PBS -q mesabi
#PBS -N cavefish_genome_hcalling
#PBS -j oe
#PBS -t 1-119

#script used by Rachel to process samples Summer 2019, adapted from /home/mcgaughs/aherman/RIS_work/array_haplotypecaller.sh 
#Note: use bams with mapped reads only

 
echo -n "Ran: "
date

# Load modules
module load java
module load gatk/3.7.0


# Set paths
#   V1 Cavefish Genome
REF="/home/mcgaughs/shared/References/Astyanax_mexicanus_102/Astyanax_mexicanus.AstMex102.dna.toplevel.fa"
ALN_DIR="/home/mcgaughs/shared/Datasets/bams/cave.fish.reference.genome/v1_cavefish_mapped_reads"
GATK="/soft/gatk/3.7.0/GenomeAnalysisTK.jar"


#   V2 Surface Genome
#REF="/panfs/roc/groups/14/mcgaughs/shared/References/2017-09_Astyanax_mexicanus/7994_ref_Astyanax_mexicanus-2.0_Complete_gbID.fa"
#ALN_DIR="/home/mcgaughs/shared/Datasets/bams/surface.fish.reference.genome/v2_surfacefish_mapped_reads"
#GATK="/soft/gatk/3.7.0/GenomeAnalysisTK.jar"

###### GATK="/panfs/roc/groups/14/mcgaughs/shared/Software/GenomeAnalysisTK-3.8-0-ge9d806836/GenomeAnalysisTK.jar"



# Get the samples to analyze
SAMPLE_LIST=($(find ${ALN_DIR} -name '*_dupsmarked_rgadd_mapped.bam' | sort -V))
CURRENT_SAMPLE=${SAMPLE_LIST[${PBS_ARRAYID}]}

# Get the sample name
FNAME=$(basename ${CURRENT_SAMPLE})
SAMPLENAME=${FNAME/_dupsmarked_rgadd_mapped.bam/}
export _JAVA_OPTIONS="-Xmx61g"

#set the output directory
OUTDIR="/home/mcgaughs/shared/Datasets/per_individual.g.vcfs/v1_cavefish"
#OUTDIR="/home/mcgaughs/shared/Datasets/per_individual.g.vcfs/v2_surfacefish"

#Note: --emitRefConfidence option should be BP_RESOLUTION, not GVCF

export _JAVA_OPTIONS="-Xmx61g"
java -jar ${GATK} \
    -T HaplotypeCaller \
    -R ${REF} \
    -I ${CURRENT_SAMPLE} \
    -o ${OUTDIR}/${SAMPLENAME}.g.vcf \
    -nct 24 \
    --genotyping_mode DISCOVERY \
    --heterozygosity 0.005 \
    --emitRefConfidence BP_RESOLUTION \
    -variant_index_type LINEAR \
    -variant_index_parameter 128000

echo -n "Done: "
date

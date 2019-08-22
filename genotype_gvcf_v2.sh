#!/bin/bash
#PBS -l mem=62gb,nodes=1:ppn=24,walltime=48:00:00
#PBS -m abe
#PBS -M rmoran@umn.edu
#PBS -q mesabi
#PBS -N genomeV2_genotyping
#PBS -j oe

# Load modules
module load java
module load gatk/3.7.0

# Set paths
GATK="/panfs/roc/msisoft/gatk/3.7.0/GenomeAnalysisTK.jar"
#   V2
REF="/home/mcgaughs/shared/References/2017-09_Astyanax_mexicanus/7994_ref_Astyanax_mexicanus-2.0_Complete_gbID.fa"
#   V1
#REF="/home/mcgaughs/shared/References/Astyanax_mexicanus_102/Astyanax_mexicanus.AstMex102.dna.toplevel.fa"
REGFOF="/home/mcgaughs/shared/References/2017-09_Astyanax_mexicanus/GATK_Regions.fof"
GVCF_DIR="/home/mcgaughs/shared/Datasets/per_individual.g.vcfs/v2_surfacefish"

OUTPUT_DIR="/home/mcgaughs/shared/Datasets/all_sites_LARGE_gvcf/raw_surfacefish" 

# Build the sample list
SAMPLE_LIST=($(find ${GVCF_DIR} -name '*.g.vcf.gz' | sort -V))
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

export _JAVA_OPTIONS="-Xmx61000m"
java -Djava.io.tmpdir=/scratch.local \
    -jar ${GATK} \
    -T GenotypeGVCFs \
    -R ${REF} \
    -L ${REGION} \
    -nt 24 \
    ${GATK_IN[@]} \
    --includeNonVariantSites \
    --heterozygosity 0.005 \
    -o ${OUTPUT_DIR}/Surfacefish_v2_186samples_wInvariant.vcf

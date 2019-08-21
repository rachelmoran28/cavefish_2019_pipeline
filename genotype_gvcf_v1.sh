#!/bin/bash
#PBS -l mem=126gb,nodes=1:ppn=16,walltime=96:00:00
#PBS -m abe
#PBS -M rmoran@umn.edu
#PBS -q sb128
#PBS -N genomeV1_genotyping
#PBS -j oe

echo -n "Ran: "
date

# Load modules
module load java
module load gatk/3.7.0 #used for V1 genome for compatibility with Eli's stuff.

# Set paths
#   V1
REF="/home/mcgaughs/shared/References/Astyanax_mexicanus_102/Astyanax_mexicanus.AstMex102.dna.toplevel.fa"
IODIR="/home/mcgaughs/shared/Datasets/per_individual.g.vcfs/v1_cavefish"
REGION="/home/mcgaughs/shared/References/Astyanax_mexicanus_102"

#fix path to GATK
GATK=/panfs/roc/msisoft/gatk/3.7.0/GenomeAnalysisTK.jar

VCFS=($(find ${IODIR}/GVCFs -type f -name *.g.vcf.gz))

GATK_IN=()

for f in ${VCFS[@]}
do
	GATK_IN+=("-V $f")
done


export _JAVA_OPTIONS="-Xmx990g"
java -Djava.io.tmpdir=/scratch.local \
    -jar ${GATK} \
    -T GenotypeGVCFs \
    -R ${REF} \
    -L ${REGION}/vcf_intervals.list \ 
    ${GATK_IN[@]} \
    -o ${IODIR}/Cavefish_v1_183samples.wInvariant.vcf \ 
    -nt 16 \
    --includeNonVariantSites

echo -n "Done: "
date

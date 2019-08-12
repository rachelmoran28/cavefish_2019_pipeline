#!/bin/bash
#PBS -l mem=998gb,nodes=1:ppn=32,walltime=96:00:00
#PBS -m abe
#PBS -M rmoran@umn.edu
#PBS -q ram1t
#PBS -A mcgaughs
#PBS -N genomeV1_genotyping
#PBS -j oe

echo -n "Ran: "
date

# Load modules
module load java
#module load gatk/3.7.0 #used for V1 genome for compatibility with Eli's stuff.

# Set paths
#   V1
REF="/home/mcgaughs/shared/References/Astyanax_mexicanus_102/Astyanax_mexicanus.AstMex102.dna.toplevel.fa"
IODIR="/panfs/roc/scratch/aherman/RIS_cavefish/old_genome_mapping"
GATK=/panfs/roc/groups/14/mcgaughs/shared/Software/GenomeAnalysisTK-3.8-0-ge9d806836/GenomeAnalysisTK.jar
VCFS=($(find ${IODIR}/GVCFs -type f -name *.g.vcf))

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
    -L ${IODIR}/vcf_restart3_intervals.list \ . ### What is "vcf_restart3_intervals.list"?
    ${GATK_IN[@]} \
    -o ${IODIR}/Astyanax_v1genome_ahsamples_restart3.full.vcf \
    -nt 32 \
    --includeNonVariantSites

echo -n "Done: "
date

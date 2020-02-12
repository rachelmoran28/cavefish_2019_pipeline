#!/bin/bash
#PBS -l mem=62gb,nodes=1:ppn=1,walltime=24:00:00
#PBS -A mcgaughs
#PBS -m abe
#PBS -M rmoran@umn.edu
#PBS -q mangi
#PBS -N SelectFilterCombineVariants

GATK="/home/mcgaughs/shared/Software/GenomeAnalysisTK-3.8-0-ge9d806836/GenomeAnalysisTK.jar"
#   V2
REF="/home/mcgaughs/shared/References/2017-09_Astyanax_mexicanus/7994_ref_Astyanax_mexicanus-2.0_Complete_gbID.fa"
# 
RAW=/home/mcgaughs/shared/Datasets/all_sites_LARGE_gvcf/raw_surfacefish/new_qual_filtered
FILTERED=/home/mcgaughs/shared/Datasets/all_sites_LARGE_gvcf/filtered_surfacefish


#Subset to SNPs-only callset
export _JAVA_OPTIONS="-Xmx61g"
java -Djava.io.tmpdir=/scratch.local \
    -jar ${GATK} \
    -T SelectVariants \
    -V ${RAW}/Chr_4_Surfacefish_v2_267samples_wInvariant.vcf.gz \
    -select-type SNP \
    -o ${FILTERED}/subset_snps/Chr4_Surfacefish_snps_subset.vcf.gz
echo -n "Done: subset snps"
date


#Subset to mixed/indels-only callset
export _JAVA_OPTIONS="-Xmx61g"
java -Djava.io.tmpdir=/scratch.local \
    -jar ${GATK} \
    -T SelectVariants \
    -V ${RAW}/Chr_4_Surfacefish_v2_267samples_wInvariant.vcf.gz \
    -select-type MIXED \
    -o ${FILTERED}/subset_mixed/Chr4_Surfacefish_mixed_subset.vcf.gz
echo -n "Done: subset mixed"
date

#Hard-filter SNPs on multiple expressions 
export _JAVA_OPTIONS="-Xmx61g"
java -Djava.io.tmpdir=/scratch.local \
    -jar ${GATK} \
    -T VariantFiltration \
    -R ${REF} \
    -V ${FILTERED}/subset_snps/Chr4_Surfacefish_snps_subset.vcf.gz \
    -filter "QD < 2.0" --filter-name "QD2" \
    -filter "FS > 60.0" --filter-name "FS60" \
    -filter "MQ < 40.0" --filter-name "MQ40" \
    -filter "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" \
    -filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" \
    -o ${FILTERED}/filtered_snps/Chr4_Surfacefish_snps_filtered.vcf.gz \
echo -n "Done: filter snps"
date



#Hard-filter mixed/indels on multiple expressions
export _JAVA_OPTIONS="-Xmx61g"
java -Djava.io.tmpdir=/scratch.local \
    -jar ${GATK} \
    -T VariantFiltration \
    -R ${REF} \
    -V ${FILTERED}/subset_mixed/Chr4_Surfacefish_mixed_subset.vcf.gz \
    -filter "QD < 2.0" --filter-name "QD2" \
    -filter "FS > 200.0" --filter-name "FS200" \
    -filter "ReadPosRankSum < -20.0" --filter-name "ReadPosRankSum-20" \
    -o ${FILTERED}/filtered_mixed/Chr4_Surfacefish_mixed_filtered.vcf.gz
echo -n "Done: filter mixed"
date


#Combine filtered variant sets
export _JAVA_OPTIONS="-Xmx61g"
java -Djava.io.tmpdir=/scratch.local \
    -jar ${GATK} \
    -T CombineVariants \
    -R ${REF} \
    -V ${FILTERED}/filtered_snps/Chr4_Surfacefish_snps_filtered.vcf.gz  \
    -V ${FILTERED}/filtered_mixed/Chr4_Surfacefish_mixed_filtered.vcf.gz  \
    -o ${FILTERED}/combined_filtered/Chr4_Surfacefish_filtered.vcf.gz 
echo -n "Done: combine filtered sets"
date

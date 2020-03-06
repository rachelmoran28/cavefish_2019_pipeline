#!/bin/bash
#PBS -l mem=998gb,nodes=1:ppn=32,walltime=6:00:00
#PBS -m abe
#PBS -M rmoran@umn.edu
#PBS -q ram1t
#PBS -N SelectFilterCombineVariants_array
#PBS -t 1-36


module load java


#Define paths
REF="/home/mcgaughs/shared/References/2017-09_Astyanax_mexicanus/7994_ref_Astyanax_mexicanus-2.0_Complete_gbID.fa"
RAW=/home/mcgaughs/shared/Datasets/all_sites_LARGE_vcfs/raw_surfacefish/new_qual_filtered
FILTERED=/home/mcgaughs/shared/Datasets/all_sites_LARGE_vcfs/filtered_surfacefish


# We have defined a file-of-files that lists regions to operate over. This is
# because we separated variant calling by chromosome. Chromosomes 1-25
# have their own files and the unmapped contigs get their own files (broken up into Un 1-10)
REGFOF="/home/mcgaughs/shared/References/2017-09_Astyanax_mexicanus/GATK_Regions_final.fof"
REGION=$(sed "${PBS_ARRAYID}q;d" ${REGFOF})
# We define the output region based on the basename of the intervals file that
# was read from the file-of-files
REG_BNAME=$(basename ${REGION})
REG_OUT=${REG_BNAME/.intervals/}




### Need to use GATK 3 for SelectVariants and VariantFiltration steps ###
GATK="/home/mcgaughs/shared/Software/GenomeAnalysisTK-3.8-0-ge9d806836/GenomeAnalysisTK.jar"

export _JAVA_OPTIONS="-Xmx990g"


##################################################
###### Subset NO_VARIATION, SNPS, MIXED/INDELS, and  #######
##################################################


#Subset monomorphic sites
java -Djava.io.tmpdir=/scratch.local -jar ${GATK} \
    -T SelectVariants \
    -R ${REF} \
    -V ${RAW}/${REG_OUT}_Surfacefish_v2_267samples_wInvariant.vcf.gz \
    --selectTypeToExclude INDEL \
    --selectTypeToExclude MIXED \
    --selectTypeToExclude MNP \
    --selectTypeToExclude SYMBOLIC \
    --selectTypeToInclude NO_VARIATION \
    -nt 32 \
    -o ${FILTERED}/subset_mono/${REG_OUT}_Surfacefish_mono_subset.vcf

echo -n "Done: subset mono"
date


#Subset SNPs
java -Djava.io.tmpdir=/scratch.local -jar ${GATK} \
    -T SelectVariants \
    -R ${REF} \
    -V ${RAW}/${REG_OUT}_Surfacefish_v2_267samples_wInvariant.vcf.gz \
    -selectType SNP \
    -nt 32 \
    -o ${FILTERED}/subset_snps/${REG_OUT}_Surfacefish_snps_subset.vcf

echo -n "Done: subset snps"
date


#Subset  mixed/indels
java -Djava.io.tmpdir=/scratch.local -jar ${GATK} \
    -T SelectVariants \
    -R ${REF} \
    -V ${RAW}/${REG_OUT}_Surfacefish_v2_267samples_wInvariant.vcf.gz \
    -selectType MIXED \
    -selectType INDEL \
    -nt 32 \
    -o ${FILTERED}/subset_mixed/${REG_OUT}_Surfacefish_mixed_indels_subset.vcf

echo -n "Done: subset mixed/indels"
date




##############################
######   Hard Filter  ########
##############################

#Apply hard-filter flags to mono sites 
java -Djava.io.tmpdir=/scratch.local -jar ${GATK} -T VariantFiltration -R ${REF} \
    -V ${FILTERED}/subset_mono/Chr_5_Surfacefish_mono_subset.vcf \
    -filter "QD < 2.0" -filterName "QD2" \
    -filter "FS > 60.0" -filterName "FS60" \
    -filter "MQ < 40.0" -filterName "MQ40" \
    -o ${FILTERED}/filtered_mono/Chr_5_Surfacefish_mono_filtered.vcf

echo -n "Done: filter mono"
date


#Apply hard-filter flags to SNPs 
java -Djava.io.tmpdir=/scratch.local -jar ${GATK} -T VariantFiltration -R ${REF} \
    -V ${FILTERED}/subset_snps/${REG_OUT}_Surfacefish_snps_subset.vcf \
    -filter "QD < 2.0" -filterName "QD2" \
    -filter "FS > 60.0" -filterName "FS60" \
    -filter "MQ < 40.0" -filterName "MQ40" \
    -filter "MQRankSum < -12.5" -filterName "MQRankSum-12.5" \
    -filter "ReadPosRankSum < -8.0" -filterName "ReadPosRankSum-8" \
    -o ${FILTERED}/filtered_snps/${REG_OUT}_Surfacefish_snps_filtered.vcf

echo -n "Done: filter snps"
date


#Apply hard-filter flags to mixed/indels 
java -Djava.io.tmpdir=/scratch.local -jar ${GATK} -T VariantFiltration -R ${REF} \
    -V ${FILTERED}/subset_mixed/${REG_OUT}_Surfacefish_mixed_subset.vcf \
    -filter "QD < 2.0" -filterName "QD2" \
    -filter "FS > 200.0" -filterName "FS200" \
    -filter "ReadPosRankSum < -20.0" -filterName "ReadPosRankSum-20" \
    -o ${FILTERED}/filtered_mixed/${REG_OUT}_Surfacefish_mixed_indels_filtered.vcf

echo -n "Done: filter mixed"
date



###########################################################
######   Select Only Sites that Pass Hard Filters  ########
###########################################################

#Retian monomorphic sites that PASS filters
java -Djava.io.tmpdir=/scratch.local -jar ${GATK} -T SelectVariants -R ${REF} \
    -V ${FILTERED}/filtered_mono/Chr_5_Surfacefish_mono_filtered.vcf \
    -nt 32 \
    --excludeFiltered \
    -o ${FILTERED}/filtered_mono/Chr_5_Surfacefish_mono_filtered_PASS_ONLY.vcf

echo -n "Done: subset PASS mono"
date

#There's a bug in GATK where indels are retained even when you specify "--selectTypeToExclude INDEL", so need this extra step to make sure we only have monomorphic sites here
cat ${FILTERED}/filtered_mono/${REG_OUT}_Surfacefish_mono_filtered_PASS_ONLY.vcf | grep '#' > ${FILTERED}/filtered_mono/${REG_OUT}_header;
cat ${FILTERED}/filtered_mono/${REG_OUT}_Surfacefish_mono_filtered_PASS_ONLY.vcf | grep -v '#' | awk 'length($4)==1 && length($5)==1 {print}' >> ${FILTERED}/filtered_mono/${REG_OUT}_header && mv ${FILTERED}/filtered_mono/${REG_OUT}_header ${FILTERED}/filtered_mono/${REG_OUT}_Surfacefish_mono_filtered_PASS_ONLY.vcf


#Retain SNPs that PASS filters
java -Djava.io.tmpdir=/scratch.local -jar ${GATK} -T SelectVariants -R ${REF} \
    -V ${FILTERED}/filtered_snps/${REG_OUT}_Surfacefish_snps_filtered.vcf \
    -nt 32 \
    --excludeFiltered \
    -o ${FILTERED}/filtered_snps/${REG_OUT}_Surfacefish_snps_filtered_PASS_ONLY.vcf

echo -n "Done: subset PASS snps"
date


#Retain mixed/indels that PASS filters
java -Djava.io.tmpdir=/scratch.local -jar ${GATK} -T SelectVariants -R ${REF} \
    -V ${FILTERED}/filtered_mixed/${REG_OUT}_Surfacefish_mixed_indels_filtered.vcf \
    -nt 32 \
    --excludeFiltered \
    -o ${FILTERED}/filtered_mixed/${REG_OUT}_Surfacefish_mixed_indels_filtered_PASS_ONLY.vcf

echo -n "Done: subset PASS mixed"
date



#############################################################
#####   Merge all filtered sites back into one VCF ######
#############################################################


### Need to switch to GATK4 to use MergeVcfs  ###
GATK4="/home/mcgaughs/rmoran/miniconda3/bin/gatk"


#Combine filtered sets
java -Djava.io.tmpdir=/scratch.local
${GATK4} --java-options "-Xmx990g" MergeVcfs \
    -R ${REF} \
    -I ${FILTERED}/filtered_snps/${REG_OUT}_Surfacefish_snps_filtered_PASS_ONLY.vcf  \
    -I ${FILTERED}/filtered_mixed/${REG_OUT}_Surfacefish_mixed_indels_filtered_PASS_ONLY.vcf  \
    -I ${FILTERED}/filtered_mono/${REG_OUT}_Surfacefish_mono_filtered_PASS_ONLY.vcf  \
    -O ${FILTERED}/combined_filtered/${REG_OUT}_Surfacefish_filtered_all_combined_PASS_ONLY.vcf

echo -n "Done: merge all filtered sets"
date

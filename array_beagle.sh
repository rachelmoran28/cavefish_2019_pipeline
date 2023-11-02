#!/bin/bash
#PBS -l mem=998gb,nodes=1:ppn=32,walltime=24:00:00
#PBS -m abe
#PBS -M rmoran@umn.edu
#PBS -q ram1t
#PBS -N array_phase
#PBS -t 1-35



# Load modules
module load xz-utils
module load bcftools


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




HOME=/home/mcgaughs/shared/Datasets/all_sites_LARGE_vcfs/filtered_surfacefish/combined_filtered/246Indvs_RepsMasked

cd ${HOME}

src=/home/mcgaughs/shared/Software

java -jar -Xmx990G $src/beagle.24Mar20.5f5.jar nthreads=32 gt=${REG_OUT}_HardFiltered_246Indv_SurfaceRef_wInvar.RepsRemoved.vcf.gz impute=false out=${REG_OUT}_HardFiltered_246Indv_SurfaceRef_wInvar.RepsRemoved.phased

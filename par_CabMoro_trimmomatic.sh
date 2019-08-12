#!/bin/bash
#PBS -l mem=126gb,nodes=1:ppn=16,walltime=96:00:00 
#PBS -m abe 
#PBS -j oe
#PBS -M rmoran@umn.edu 
#PBS -q sb128
#PBS -N par_trim_CabMoro


#       The home folder
export HOME=/home/mcgaughs/shared/Datasets/RAW_NGS/CabMoro

export TRIM_DIR=/panfs/roc/groups/14/mcgaughs/shared/Software/Trimmomatic-0.30/

module load parallel
module load java

#       Define a bash function for doing the processing
#       since it is the same for each file, and we don't want to keep repeating

partrim() {
        #get sample name from CabMoro_SampID.txt, the first argument "-a" supplied to parallel at the end of the script 
        SAMP=${1}
        
        #trim low quality
        java -Xmx2g -jar ${TRIM_DIR}trimmomatic-0.30.jar PE -phred33\
        ${SAMP}_R1.fastq.gz ${SAMP}_R2.fastq.gz\
        ${SAMP}_adtrim_trim_pair_R1.fastq.gz ${SAMP}_adtrim_trim_unpair_R1.fastq.gz\
        ${SAMP}_adtrim_trim_pair_R2.fastq.gz ${SAMP}_adtrim_trim_unpair_R2.fastq.gz\
        ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:keepBothReads SLIDINGWINDOW:6:30 MINLEN:40
}
#   Export function so we can call it with parallel
export -f partrim
#       cd into the reads directory
cd ${HOME}

parallel --joblog CabMoro_trimmomatic_parallel_logfile.txt -a CabMoro_SampID.txt partrim

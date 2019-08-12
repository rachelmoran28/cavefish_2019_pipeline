#!/bin/bash
#PBS -l mem=62gb,nodes=1:ppn=24,walltime=48:00:00 
#PBS -m abe 
#PBS -j oe
#PBS -M rmoran@umn.edu 
#PBS -q mesabi
#PBS -N par_trimmomatic_Gross_NGS_samples


#       The home folder
export HOME=/home/mcgaughs/shared/Datasets/RAW_NGS/Gross_NGS_Data/renamed_fastqs/cutadapt_out

# path to trimmomatic executable
export TRIM_DIR=/panfs/roc/groups/14/mcgaughs/shared/Software/Trimmomatic-0.30/

module load parallel
module load java

#       Define a bash function for doing the processing

partrim() {
        #Get each sample name from the list Gross_misc_SampleID.txt (suplied to the parallel command with the -a flag)
        SAMP=${1}
        
        #trim low quality
        java -Xmx2g -jar ${TRIM_DIR}trimmomatic-0.30.jar PE -phred33\
        ${SAMP}_adtrim_R1.fastq.gz ${SAMP}_adtrim_R2.fastq.gz\
        ${SAMP}_adtrim_trim_pair_R1.fastq.gz ${SAMP}_adtrim_trim_unpair_R1.fastq.gz\
        ${SAMP}_adtrim_trim_pair_R2.fastq.gz ${SAMP}_adtrim_trim_unpair_R2.fastq.gz\
        SLIDINGWINDOW:6:30 MINLEN:40
}

#   Export function so we can call it with parallel
export -f partrim
#       cd into the reads directory
cd ${HOME}

parallel --joblog Gross_misc_trimmomatic_parallel_logfile.txt -a Gross_misc_SampleID.txt partrim

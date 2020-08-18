#!/bin/bash
#PBS -l mem=62gb,nodes=1:ppn=24,walltime=48:00:00 
#PBS -m abe 
#PBS -j oe
#PBS -M rmoran@umn.edu 
#PBS -q mangi
#PBS -N par_proc10x



#process_10xReads.py [-h] [--version] [-o OUTPUT_DIR] [-a] [-i] [-b BCTRIM] [-t TRIM] [-g] [--quiet] [-1 read1 [read1 ...]] [-2 read2 [read2 ...]]
   
   
export HOME=/home/mcgaughs/shared/Datasets/RAW_NGS/CombinedReads10X

export PROC=/home/mcgaughs/rmoran/software/proc10xG

export OUT=/home/mcgaughs/shared/Datasets/Reads_ready_to_align/TenX/

module load parallel
module load python2


parcut() {
    #get sample ID from SampleID.txt (first argument supplied to parallel with -a)
    SAMP=${1}

    #cut the adapters
    $PROC/process_10xReads.py -a -o $OUT/${SAMP} -1 ${SAMP}_R1.fastq.gz -2 ${SAMP}_R2.fastq.gz 
} 


#   Export function so we can call it with parallel
export -f parcut

#cd into the reads directory
cd ${HOME}

parallel --joblog proc10x_parallel_logfile.txt -a TenX_SampID.txt parcut

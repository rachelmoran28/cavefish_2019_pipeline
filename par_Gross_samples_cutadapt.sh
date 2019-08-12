#!/bin/bash
#PBS -l mem=62gb,nodes=1:ppn=24,walltime=48:00:00 
#PBS -m abe 
#PBS -j oe
#PBS -M rmoran@umn.edu 
#PBS -q mesabi
#PBS -N par_cutadapt_Gross_NGS_samples


#The home folder
export HOME=/home/mcgaughs/shared/Datasets/RAW_NGS/Gross_NGS_Data/renamed_fastqs

export R1_adapter="GATCGGAAGAGCACACGTCTGAACTCCAGTCACNNNNNNATCTCGTATGCCGTCTTCTGCTTG" #the R1 adapter has a unique barcode for each individual, but we couldn't get this info from BGI so using N's as wildcards
export R2_adapter="AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT" #the R2 adapter is the same for each individual

export CUT=/home/mcgaughs/shared/Software/cutadapt-1.2.1/bin

module load parallel
module load python2

#Define a bash function for doing the processing
#since it is the same for each file, and we don't want to keep repeating

parcut() {
    #get sample ID from Gross_misc_SampleID.txt (first argument supplied to parallel with -a)
    SAMP=${1}

    #cut the adapters
    $CUT/cutadapt -e 0.01 -a ${R1_adapter} --match-read-wildcards ${SAMP}_R1.fastq.gz > ${SAMP}_adtrim_R1.fastq.gz 
    $CUT/cutadapt -e 0.01 -a ${R2_adapter} ${SAMP}_R2.fastq.gz > ${SAMP}_adtrim_R2.fastq.gz
} 


#   Export function so we can call it with parallel
export -f parcut

#cd into the reads directory
cd ${HOME}

parallel --joblog cutadapt_parallel_logfile.txt -a Gross_misc_SampleID.txt parcut

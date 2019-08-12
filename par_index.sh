#!/bin/bash
#PBS -l nodes=1:ppn=4,walltime=24:00:00 
#PBS -m abe 
#PBS -j oe
#PBS -M rmoran@umn.edu 
#PBS -q mesabi
#PBS -N par_samtools_index


cd /home/mcgaughs/shared/Datasets/bams/cave.fish.reference.genome/v1_cavefish_mapped_reads

module load parallel
module load samtools

#this command will index every bam file in the current direcotry ending in _mapped.bam
parallel samtools index ::: *_mapped.bam

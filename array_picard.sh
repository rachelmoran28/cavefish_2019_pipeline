#!/bin/bash
#PBS -l mem=126gb,nodes=1:ppn=16,walltime=96:00:00
#PBS -m abe
#PBS -j oe
#PBS -M rmoran@umn.edu
#PBS -q sb128
#PBS -t 1-118

# Load modules
module load picard-tools/2.3.0

# And the command list 
CMD_LIST="/home/mcgaughs/shared/Datasets/Reads_ready_to_align/picard_cavefish_commands.txt" 

CMD="$(sed "${PBS_ARRAYID}q;d" ${CMD_LIST})"
eval ${CMD}

{\rtf1\ansi\ansicpg1252\cocoartf2639
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fnil\fcharset0 Menlo-Regular;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
{\*\expandedcolortbl;;\csgray\c0;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural\partightenfactor0

\f0\fs26 \cf2 \CocoaLigature0 #!/bin/bash\
#PBS -l mem=62gb,nodes=1:ppn=4,walltime=48:00:00\
#PBS -m abe\
#PBS -M rmoran@umn.edu\
#PBS -q mangi\
#PBS -N vcfR\
\
cd /home/mcgaughs/shared/Datasets/all_sites_LARGE_vcfs/filtered_surfacefish/combined_filtered/246Indvs_RepsMasked/phased_masked\
\
module load R/3.6.3\
\
#Run an R script in R as a job on the cluster\
Rscript vcfR.R}
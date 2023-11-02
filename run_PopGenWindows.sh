{\rtf1\ansi\ansicpg1252\cocoartf2639
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fnil\fcharset0 Menlo-Regular;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
{\*\expandedcolortbl;;\csgray\c0;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural\partightenfactor0

\f0\fs26 \cf2 \CocoaLigature0 #!/bin/bash\
#SBATCH -p small,amdsmall,astyanax,cavefish\
#SBATCH --nodes=1\
#SBATCH --cpus-per-task=24\
#SBATCH --mem=62gb\
#SBATCH -t 250:00:00\
#SBATCH -J popgenwindows\
\
\
cd /home/mcgaughs/shared/Datasets/all_sites_LARGE_vcfs/filtered_surfacefish/combined_filtered/246Indvs_RepsMasked/phased_masked\
\
\
\
SRC="/home/mcgaughs/shared/Datasets/all_sites_LARGE_vcfs/filtered_surfacefish/combined_filtered/246Indvs_RepsMasked/phased_masked/biallelicSNPs_wInvar_noIndels_phased_masked_ExcludeHet/MAF01"\
BIGVCF="Concat_HardFilt_246Indv_biSNPs_wInvar_noIndels3bpBuffer.AllRepsRemoved.Phased.ExcludeHet.MAF01.Miss02.FIXED.All.Sorted.vcf.gz"\
\
#python parseVCFs.py -i $SRC/Concat_HardFilt_246Indv_biSNPs_wInvar_noIndels3bpBuffer.AllRepsRemoved.Phased.ExcludeHet.MAF01.Miss02.FIXED.All.Sorted.vcf.gz --threads 16 | bgzip > OL_vs_NL_biSNPs_wInvar.geno.gz \
\
python popgenWindows.py -w 50000 -m 5000 -g OL_vs_NL_biSNPs_wInvar.geno.gz -o May2022_OL_vs_NL_50k_popgenWindows.output.csv.gz -f phased -T 24  -p NLC -p NLS -p OLC -p OLS --popsFile OL_NL_samples_tabs.txt\
\
#python popgenWindows.py -w 50000 -m 5000 -g Final_246_biSNPs_wInvar.geno.gz -o July2020_Final_popgenWindows.output.csv.gz -f phased -T 16 --popsFile fixed_PopFile.txt\
\
\
}
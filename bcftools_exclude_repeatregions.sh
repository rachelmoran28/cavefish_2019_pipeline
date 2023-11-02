{\rtf1\ansi\ansicpg1252\cocoartf2639
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fnil\fcharset0 Menlo-Regular;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
{\*\expandedcolortbl;;\csgray\c0;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural\partightenfactor0

\f0\fs26 \cf2 \CocoaLigature0 #PBS -l mem=62gb,nodes=1:ppn=24,walltime=96:00:00 \
#PBS -m abe \
#PBS -j oe\
#PBS -M rmoran@umn.edu \
#PBS -q mangi\
#PBS -N bcftools_rmvindels\
\
# Load modules\
module load xz-utils\
module load bcftools\
# set paths\
#BCFTOOLS="/panfs/roc/groups/14/mcgaughs/shared/Software/bcftools-1.6/bcftools"\
#BCFTOOLS="/panfs/roc/msisoft/bcftools/1.9_gcc-7.2.0_haswell/bin/bcftools"\
VCFTOOLS="/panfs/roc/groups/14/mcgaughs/shared/Software/bin/vcftools"\
VCF_LIB="/panfs/roc/groups/14/mcgaughs/shared/Software/share/perl5"\
\
\
# Set the PERL5LIB variable for vcftools\
export PERL5LIB=$\{VCF_LIB\}\
\
cd /home/mcgaughs/shared/Datasets/all_sites_LARGE_vcfs/filtered_surfacefish/combined_filtered\
\
#$VCFTOOLS --vcf HardFiltered_250Indv_SurfaceRef_biallelicSNPs_wInvar_noIndels_rmv0.4missing.vcf --exclude-bed ../filtered_snps/Amex2_Window_Repeat_mask.NW.bed --recode --recode-INFO-all --out HardFiltered_250Indv_SurfaceRef_biallelicSNPs_wInvar_noIndels_rmv0.4missing_NoRepeats\
\
\
#bcftools view all_filtered_PASS_concat.vcf.gz --threads 24 -S ^../remove_indvs.txt | bgzip -c > HardFiltered_250Indv_SurfaceRef_wInvar.vcf.gz && tabix -s1 -b2 -e2 HardFiltered_250Indv_SurfaceRef_wInvar.vcf.gz\
\
bcftools view HardFiltered_250Indv_SurfaceRef_biallelicSNPs_wInvar_noIndels_rmv0.4missing.vcf -T ^../filtered_snps/Amex2_Window_Repeat_mask.NW.bed --threads 24 > HardFiltered_250Indv_SurfaceRef_biallelicSNPs_wInvar_noIndels_rmv0.4missing_RepsRemoved}
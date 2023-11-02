{\rtf1\ansi\ansicpg1252\cocoartf2639
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fnil\fcharset0 Menlo-Regular;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
{\*\expandedcolortbl;;\csgray\c0;}
\margl1440\margr1440\vieww27500\viewh13700\viewkind0
\pard\tx560\tx1120\tx1680\tx2240\tx2800\tx3360\tx3920\tx4480\tx5040\tx5600\tx6160\tx6720\pardirnatural\partightenfactor0

\f0\fs26 \cf2 \CocoaLigature0 #R script to calculate heterozygosity at each site in a VCF\
\
\
setwd("/home/mcgaughs/shared/Datasets/all_sites_LARGE_vcfs/filtered_surfacefish/combined_filtered/246Indvs_RepsMasked/phased_masked")\
\
library("memuse", lib.loc="/home/mcgaughs/rmoran/Rlibs36")\
library("vcfR", lib.loc="/home/mcgaughs/rmoran/Rlibs36")\
#library("adegenet", lib.loc="/home/mcgaughs/rmoran/Rlibs36")\
\
#Specify a population for each individual in your vcf, in the order they appear in the vcf\
pop <- as.factor(c("AeneusCave","AeneusSurface","Arroyo","Arroyo","Arroyo","Arroyo","Arroyo","Arroyo","Arroyo","Arroyo","Arroyo","Arroyo","CabMoroCave","CabMoroCave","CabMoroCave","CabMoroCave","CabMoroCave","CabMoroCave","CabMoroCave","CabMoroCave","CabMoroCave","CabMoroCave","CabMoroCave","CabMoroCave","CabMoroCaveEyed","CabMoroCaveEyed","CabMoroCaveEyed","CabMoroCaveEyed","CabMoroCaveEyed","CabMoroCaveEyed","CabMoroCaveEyed","CabMoroCaveEyed","CabMoroCaveEyed","CabMoroCaveEyed","CabMoroCaveEyed","CabMoroCaveEyed","CabMoroCaveEyed","CabMoroCaveEyed","CabMoroCaveEyed","CabMoroCaveEyed","CabMoroCaveEyed","CabMoroSurface","CabMoroSurface","CabMoroSurface","CabMoroSurface","CabMoroSurface","CabMoroSurface","Chica","Chica","Chica","Chica","Chica","Chica","Chica","Chica","Chica","Chica","Chica","Chica","Chica","Chica","Chica","Chica","Chica","Chica","Chica","Choy","Choy","Choy","Choy","Choy","Choy","Choy","Choy","Choy","Escondido","Escondido","Escondido","Escondido","Escondido","Escondido","Escondido","Escondido","Escondido","Gallinas","Gallinas","Gallinas","Japlin","Japones","Japones","Japones","Japones","Japones","Jineo","Jineo","Jineo","Jineo","Jineo","Jos","Jos","Jos","Jos","Jos","Mante","Mante","Mante","Mante","Mante","Mante","Mante","Mante","Mante","Mante","Micos","Molino","Molino","Molino","Molino","Molino","Molino","Molino","Molino","Molino","Molino","Molino","Molino","Molino","Molino","Molino","Montecillos","Montecillos","Montecillos","Montecillos","Montecillos","Montecillos","Montecillos","Montecillos","Montecillos","Pachon","Pachon","Pachon","Pachon","Pachon","Pachon","Pachon","Pachon","Pachon","Pachon","Pachon","Pachon","Pachon","Pachon","Pachon","Pachon","Pachon","Pachon","Pachon","Palmaseca","Palmaseca","Palmaseca","Palmaseca","Palmaseca","Palmaseca","Palmaseca","Palmaseca","Peroles","Peroles","Peroles","Peroles","Peroles","Peroles","Peroles","Peroles","Peroles","Rascon","Rascon","Rascon","Rascon","Rascon","Rascon","Rascon","Rascon","Rascon","Rascon","Rascon","Rascon","Rascon","Rascon","Sabinos","Sabinos","Subter","Subter","Subter","Subter","Subter","Subter","Subter","Subter","Tigre","Tigre","Tigre","Tigre","Tigre","Tigre","Tigre","Tigre","Tigre","Tigre","Tinaja","Tinaja","Tinaja","Tinaja","Tinaja","Tinaja","Tinaja","Tinaja","Tinaja","Tinaja","Tinaja","Tinaja","Tinaja","Tinaja","Tinaja","Tinaja","Tinaja","Tinaja","Tinaja","Tinaja","Toro","Toro","Toro","Vasquez","Vasquez","Vasquez","Vasquez","Vasquez","Vasquez","Vasquez","Vasquez","Yerbaniz","Yerbaniz","Yerbaniz","Yerbaniz","Yerbaniz","Yerbaniz","Yerbaniz"))\
\
\
#read in your vcf\
vcf <- read.vcfR("Chr_Un_1_HardFiltered_246Indv_biallelicSNPs_rmv0.4missing.RepsRemoved.phased.masked.vcf.gz")\
myDiff <- genetic_diff(vcf, pops=pop, method='nei')\
\
#Write the output - a csv\
write.csv(myDiff, 'Chr_Un_1_Heterozygosity.csv')}
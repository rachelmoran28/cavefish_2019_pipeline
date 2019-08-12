#!/bin/bash

#usage:  ./make_picard_cavefish_commands.sh > picard_cavefish_commands.txt


# These are the samples that we are analyzing. These will eventually be
# part of filenames, so we define them here, as a bash array.

SAMPLES=(
    "Jineo_1" "Jineo_2" "Jineo_3" "Jineo_4" "Jineo_5"
    
    "Escon_1" "Escon_2" "Escon_3" "Escon_4" "Escon_5" "Escon_6" "Escon_7"
    "Escon_8"
   
    "Arroyo_1Boro" "Arroyo_A2POG" "Arroyo_B2POG" "Arroyo_C4POG" "Arroyo_D4POG" "Arroyo_E4POG"
    "Arroyo_F4POG" "Arroyo_G4POG" "Asty_0305Boro" "Asty_0401Boro" "Gallinas_B4POG" "Gallinas_G3POG"
    "Gallinas_H3POG" "Micos_2Boro" "Molinos_2Boro" "Molinos_D3POG" "Pachon_6Boro" "Pachon_1Gross"
    "Pachon_2Gross"  "Pachon_3Gross"  "Pachon_E2POG"  "Pachon_F2POG"  "Pachon_G2POG" "Pachon_H2POG"
    "Subter_1POG" "Subter_2POG" "Subter_3POG" "Subter_4POG" "Subter_5POG" "Subter_6POG"
    "Subter_7POG" "Subter_8POG" "Surface_1Gross" "Surface_2Gross" "Tinaja_1Boro" "Tinaja_1Gross"
    "Tinaja_2Gross" "Tinaja_3Gross"
    
    "CabMoro_C1Rnd1" "CabMoro_C2Rnd1" "CabMoro_C3Rnd1" "CabMoro_C3Rnd2" "CabMoro_C4Rnd1"
    "CabMoro_C4Rnd2" "CabMoro_C5Rnd1" "CabMoro_C5Rnd2" "CabMoro_C6Rnd1" "CabMoro_C6Rnd2"
    "CabMoro_C7Rnd1" "CabMoro_C7Rnd2" "CabMoro_E10Rnd2" "CabMoro_E11Rnd2" "CabMoro_E12Rnd2"
    "CabMoro_E13Rnd2" "CabMoro_E14Rnd2" "CabMoro_E15Rnd2" "CabMoro_E16Rnd2" "CabMoro_E1Rnd1"
    "CabMoro_E2Rnd1" "CabMoro_E3Rnd1" "CabMoro_E4Rnd1" "CabMoro_E5Rnd1" "CabMoro_E6Rnd1"
    "CabMoro_E7Rnd1" "CabMoro_E8Rnd1" "CabMoro_E8Rnd2" "CabMoro_E9Rnd2" "CabMoro_S1Rnd1"
    "CabMoro_S2Rnd1" "CabMoro_S3Rnd1" "CabMoro_Sr1Rnd1" "CabMoro_Sr2Rnd1" "CabMoro_Sr3Rnd1"

    "Mante_T6151_S25" "Mante_T6152_S24" "Mante_T6153_S28" "Mante_T6154_S29" "Mante_T6155_S26"
    "Mante_T6156_S27" "Mante_T6157_S22" "Mante_T6158_S20" "Mante_T6159_S23" "Mante_T6160_S21"
    "Nicara_T6903_S1" "Nicara_T6904_S2" "Peroles_1_S10" "Peroles_10_T5644_S18" "Peroles_11_T5648_S19"
    "Peroles_2_S11" "Peroles_3_S12" "Peroles_5_T5650_S13" "Peroles_6_T5643_S14" "Peroles_7_T5645_S15"
    "Peroles_8_T5649_S16" "Peroles_9_T5647_S17" "T5879_Tigre_S31" "T5882_Tigre_S30" "Vasquez_V10_S9"
    "Vasquez_V3_S3" "Vasquez_V5_S4" "Vasquez_V6_S5" "Vasquez_V7_S6" "Vasquez_V8_S7" "Vasquez_V9_S8"

    "Pachon_ref"
    )

#Generate two commands for each sample to (1) mark duplicate and (2) add read groups (i.e. sample name)

for s in ${SAMPLES[@]}
do
    echo "java -Xmx61g -jar /panfs/roc/msisoft/picard/2.3.0/picard.jar MarkDuplicates TMP_DIR=/panfs/roc/scratch/rmoran/picard_temp/ INPUT=/home/mcgaughs/shared/Datasets/bams/cave.fish.reference.genome/v1_cavefish_raw_bams/${s}_raw.bam OUTPUT=/home/mcgaughs/shared/Datasets/bams/cave.fish.reference.genome/v1_cavefish_raw_bams/${s}_dupsmarked.bam METRICS_FILE=/home/mcgaughs/shared/Datasets/bams/cave.fish.reference.genome/v1_cavefish_raw_bams/${s}_metrics.txt REMOVE_DUPLICATES="true" CREATE_INDEX="true"; 
    java -Xmx61g -jar /panfs/roc/msisoft/picard/2.3.0/picard.jar AddOrReplaceReadGroups TMP_DIR=TMP_DIR=/panfs/roc/scratch/rmoran/picard_temp/ INPUT=/home/mcgaughs/shared/Datasets/bams/cave.fish.reference.genome/v1_cavefish_raw_bams/${s}_dupsmarked.bam OUTPUT=/home/mcgaughs/shared/Datasets/bams/cave.fish.reference.genome/v1_cavefish_raw_bams/${s}_dupsmarked_rgadd.bam RGID=${s} RGLB=${s} RGPL="Illumina" RGPU=${s} RGSM=${s} CREATE_INDEX="true""
done




#!/bin/bash

#Originally copied from https://github.umn.edu/konox006/SEM_CaveFish/blob/master/Remapping/Scripts/Analysis/Make_Align_Jobs.sh by Tom Kono on 17 July 2018. Lightly modified by Adam Herman.

# Print BWA jobs to STDOUT for easy feeding into task arrays. 

# Define software paths
SEQTK="/home/mcgaughs/shared/Software/seqtk/seqtk"

# Define output directory
OUTDIR="/home/mcgaughs/shared/Datasets/bams/cave.fish.reference.genome/v1_cavefish_raw_bams"
#OUTDIR="/home/mcgaughs/shared/Datasets/bams/surface.fish.reference.genome/v2_surfacefish_raw_bams"

# Define the reference index base
REFBASE="/home/mcgaughs/shared/References/Astyanax_mexicanus_102/BWA/Astyanax_mexicanus.AstMex102.dna.toplevel.fa.gz"
#REFBASE="/home/mcgaughs/shared/References/2017-09_Astyanax_mexicanus/BWA/7994_ref_Astyanax_mexicanus-2.0_Complete_gbID"

# Define the root of all reads
READS_ROOT="/home/mcgaughs/shared/Datasets/Reads_ready_to_align"

# How many threads do we want? 
THREADS="16"

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
    "CabMoro_S2Rnd1" "CabMoro_S3Rnd1" "CabMoro_Sr1Rnd1" "CabMoro_Sr2Rnd1" "CabMoro_Sr3Rnd1" "Mante_T6151_S25" 

    "Mante_T6152_S24" "Mante_T6153_S28" "Mante_T6154_S29" 
    "Mante_T6155_S26" "Mante_T6156_S27" "Mante_T6157_S22" "Mante_T6158_S20" "Mante_T6159_S23" "Mante_T6160_S21"
    "Nicara_T6903_S1" "Nicara_T6904_S2" "Peroles_1_S10" "Peroles_10_T5644_S18" "Peroles_11_T5648_S19"
    "Peroles_2_S11" "Peroles_3_S12" "Peroles_5_T5650_S13" "Peroles_6_T5643_S14" "Peroles_7_T5645_S15"
    "Peroles_8_T5649_S16" "Peroles_9_T5647_S17" "T5879_Tigre_S31" "T5882_Tigre_S30" "Vasquez_V10_S9"
    "Vasquez_V3_S3" "Vasquez_V5_S4" "Vasquez_V6_S5" "Vasquez_V7_S6" "Vasquez_V8_S7" "Vasquez_V9_S8"
    
    "Pachon_ref"
    )

# Then, define a huge associative array that gives the R1,R2,U for each of these
# samples. Not pretty, but easy to iterate.
declare -A READS
READS["Jineo_1_R1"]=${READS_ROOT}/Jineo/Jineo_1_adtrim_trim_pair_R1.fastq.gz
READS["Jineo_1_R2"]=${READS_ROOT}/Jineo/Jineo_1_adtrim_trim_pair_R2.fastq.gz
READS["Jineo_1_U"]=${READS_ROOT}/Jineo/Jineo_1_adtrim_trim_unpair_all.fastq.gz
READS["Jineo_2_R1"]=${READS_ROOT}/Jineo/Jineo_2_adtrim_trim_pair_R1.fastq.gz
READS["Jineo_2_R2"]=${READS_ROOT}/Jineo/Jineo_2_adtrim_trim_pair_R2.fastq.gz
READS["Jineo_2_U"]=${READS_ROOT}/Jineo/Jineo_2_adtrim_trim_unpair_all.fastq.gz
READS["Jineo_3_R1"]=${READS_ROOT}/Jineo/Jineo_3_adtrim_trim_pair_R1.fastq.gz
READS["Jineo_3_R2"]=${READS_ROOT}/Jineo/Jineo_3_adtrim_trim_pair_R2.fastq.gz
READS["Jineo_3_U"]=${READS_ROOT}/Jineo/Jineo_3_adtrim_trim_unpair_all.fastq.gz
READS["Jineo_4_R1"]=${READS_ROOT}/Jineo/Jineo_4_adtrim_trim_pair_R1.fastq.gz
READS["Jineo_4_R2"]=${READS_ROOT}/Jineo/Jineo_4_adtrim_trim_pair_R2.fastq.gz
READS["Jineo_4_U"]=${READS_ROOT}/Jineo/Jineo_4_adtrim_trim_unpair_all.fastq.gz
READS["Jineo_5_R1"]=${READS_ROOT}/Jineo/Jineo_5_adtrim_trim_pair_R1.fastq.gz
READS["Jineo_5_R2"]=${READS_ROOT}/Jineo/Jineo_5_adtrim_trim_pair_R2.fastq.gz
READS["Jineo_5_U"]=${READS_ROOT}/Jineo/Jineo_5_adtrim_trim_unpair_all.fastq.gz
READS["Escon_1_R1"]=${READS_ROOT}/Escondido/Escon_1_adtrim_trim_pair_R1.fastq.gz
READS["Escon_1_R2"]=${READS_ROOT}/Escondido/Escon_1_adtrim_trim_pair_R2.fastq.gz
READS["Escon_1_U"]=${READS_ROOT}/Escondido/Escon_1_adtrim_trim_unpair_all.fastq.gz
READS["Escon_2_R1"]=${READS_ROOT}/Escondido/Escon_2_adtrim_trim_pair_R1.fastq.gz
READS["Escon_2_R2"]=${READS_ROOT}/Escondido/Escon_2_adtrim_trim_pair_R2.fastq.gz
READS["Escon_2_U"]=${READS_ROOT}/Escondido/Escon_2_adtrim_trim_unpair_all.fastq.gz
READS["Escon_3_R1"]=${READS_ROOT}/Escondido/Escon_3_adtrim_trim_pair_R1.fastq.gz
READS["Escon_3_R2"]=${READS_ROOT}/Escondido/Escon_3_adtrim_trim_pair_R2.fastq.gz
READS["Escon_3_U"]=${READS_ROOT}/Escondido/Escon_3_adtrim_trim_unpair_all.fastq.gz
READS["Escon_4_R1"]=${READS_ROOT}/Escondido/Escon_4_adtrim_trim_pair_R1.fastq.gz
READS["Escon_4_R2"]=${READS_ROOT}/Escondido/Escon_4_adtrim_trim_pair_R2.fastq.gz
READS["Escon_4_U"]=${READS_ROOT}/Escondido/Escon_4_adtrim_trim_unpair_all.fastq.gz
READS["Escon_5_R1"]=${READS_ROOT}/Escondido/Escon_5_adtrim_trim_pair_R1.fastq.gz
READS["Escon_5_R2"]=${READS_ROOT}/Escondido/Escon_5_adtrim_trim_pair_R2.fastq.gz
READS["Escon_5_U"]=${READS_ROOT}/Escondido/Escon_5_adtrim_trim_unpair_all.fastq.gz
READS["Escon_6_R1"]=${READS_ROOT}/Escondido/Escon_6_adtrim_trim_pair_R1.fastq.gz
READS["Escon_6_R2"]=${READS_ROOT}/Escondido/Escon_6_adtrim_trim_pair_R2.fastq.gz
READS["Escon_6_U"]=${READS_ROOT}/Escondido/Escon_6_adtrim_trim_unpair_all.fastq.gz
READS["Escon_7_R1"]=${READS_ROOT}/Escondido/Escon_7_adtrim_trim_pair_R1.fastq.gz
READS["Escon_7_R2"]=${READS_ROOT}/Escondido/Escon_7_adtrim_trim_pair_R2.fastq.gz
READS["Escon_7_U"]=${READS_ROOT}/Escondido/Escon_7_adtrim_trim_unpair_all.fastq.gz
READS["Escon_8_R1"]=${READS_ROOT}/Escondido/Escon_8_adtrim_trim_pair_R1.fastq.gz
READS["Escon_8_R2"]=${READS_ROOT}/Escondido/Escon_8_adtrim_trim_pair_R2.fastq.gz
READS["Escon_8_U"]=${READS_ROOT}/Escondido/Escon_8_adtrim_trim_unpair_all.fastq.gz
READS["Arroyo_1Boro_R1"]=${READS_ROOT}/Gross_misc/Arroyo_1Boro_adtrim_trim_pair_R1.fastq.gz
READS["Arroyo_1Boro_R2"]=${READS_ROOT}/Gross_misc/Arroyo_1Boro_adtrim_trim_pair_R2.fastq.gz
READS["Arroyo_1Boro_U"]=${READS_ROOT}/Gross_misc/Arroyo_1Boro_adtrim_trim_unpair_all.fastq.gz
READS["Arroyo_A2POG_R1"]=${READS_ROOT}/Gross_misc/Arroyo_A2POG_adtrim_trim_pair_R1.fastq.gz
READS["Arroyo_A2POG_R2"]=${READS_ROOT}/Gross_misc/Arroyo_A2POG_adtrim_trim_pair_R2.fastq.gz
READS["Arroyo_A2POG_U"]=${READS_ROOT}/Gross_misc/Arroyo_A2POG_adtrim_trim_unpair_all.fastq.gz
READS["Arroyo_B2POG_R1"]=${READS_ROOT}/Gross_misc/Arroyo_B2POG_adtrim_trim_pair_R1.fastq.gz
READS["Arroyo_B2POG_R2"]=${READS_ROOT}/Gross_misc/Arroyo_B2POG_adtrim_trim_pair_R2.fastq.gz
READS["Arroyo_B2POG_U"]=${READS_ROOT}/Gross_misc/Arroyo_B2POG_adtrim_trim_unpair_all.fastq.gz
READS["Arroyo_C4POG_R1"]=${READS_ROOT}/Gross_misc/Arroyo_C4POG_adtrim_trim_pair_R1.fastq.gz
READS["Arroyo_C4POG_R2"]=${READS_ROOT}/Gross_misc/Arroyo_C4POG_adtrim_trim_pair_R2.fastq.gz
READS["Arroyo_C4POG_U"]=${READS_ROOT}/Gross_misc/Arroyo_C4POG_adtrim_trim_unpair_all.fastq.gz
READS["Arroyo_D4POG_R1"]=${READS_ROOT}/Gross_misc/Arroyo_D4POG_adtrim_trim_pair_R1.fastq.gz
READS["Arroyo_D4POG_R2"]=${READS_ROOT}/Gross_misc/Arroyo_D4POG_adtrim_trim_pair_R2.fastq.gz
READS["Arroyo_D4POG_U"]=${READS_ROOT}/Gross_misc/Arroyo_D4POG_adtrim_trim_unpair_all.fastq.gz
READS["Arroyo_E4POG_R1"]=${READS_ROOT}/Gross_misc/Arroyo_E4POG_adtrim_trim_pair_R1.fastq.gz
READS["Arroyo_E4POG_R2"]=${READS_ROOT}/Gross_misc/Arroyo_E4POG_adtrim_trim_pair_R2.fastq.gz
READS["Arroyo_E4POG_U"]=${READS_ROOT}/Gross_misc/Arroyo_E4POG_adtrim_trim_unpair_all.fastq.gz
READS["Arroyo_F4POG_R1"]=${READS_ROOT}/Gross_misc/Arroyo_F4POG_adtrim_trim_pair_R1.fastq.gz
READS["Arroyo_F4POG_R2"]=${READS_ROOT}/Gross_misc/Arroyo_F4POG_adtrim_trim_pair_R2.fastq.gz
READS["Arroyo_F4POG_U"]=${READS_ROOT}/Gross_misc/Arroyo_F4POG_adtrim_trim_unpair_all.fastq.gz
READS["Arroyo_G4POG_R1"]=${READS_ROOT}/Gross_misc/Arroyo_G4POG_adtrim_trim_pair_R1.fastq.gz
READS["Arroyo_G4POG_R2"]=${READS_ROOT}/Gross_misc/Arroyo_G4POG_adtrim_trim_pair_R2.fastq.gz
READS["Arroyo_G4POG_U"]=${READS_ROOT}/Gross_misc/Arroyo_G4POG_adtrim_trim_unpair_all.fastq.gz
READS["Asty_0305Boro_R1"]=${READS_ROOT}/Gross_misc/Asty_0305Boro_adtrim_trim_pair_R1.fastq.gz
READS["Asty_0305Boro_R2"]=${READS_ROOT}/Gross_misc/Asty_0305Boro_adtrim_trim_pair_R2.fastq.gz
READS["Asty_0305Boro_U"]=${READS_ROOT}/Gross_misc/Asty_0305Boro_adtrim_trim_unpair_all.fastq.gz
READS["Asty_0401Boro_R1"]=${READS_ROOT}/Gross_misc/Asty_0401Boro_adtrim_trim_pair_R1.fastq.gz
READS["Asty_0401Boro_R2"]=${READS_ROOT}/Gross_misc/Asty_0401Boro_adtrim_trim_pair_R2.fastq.gz
READS["Asty_0401Boro_U"]=${READS_ROOT}/Gross_misc/Asty_0401Boro_adtrim_trim_unpair_all.fastq.gz
READS["Gallinas_B4POG_R1"]=${READS_ROOT}/Gross_misc/Gallinas_B4POG_adtrim_trim_pair_R1.fastq.gz
READS["Gallinas_B4POG_R2"]=${READS_ROOT}/Gross_misc/Gallinas_B4POG_adtrim_trim_pair_R2.fastq.gz
READS["Gallinas_B4POG_U"]=${READS_ROOT}/Gross_misc/Gallinas_B4POG_adtrim_trim_unpair_all.fastq.gz
READS["Gallinas_G3POG_R1"]=${READS_ROOT}/Gross_misc/Gallinas_G3POG_adtrim_trim_pair_R1.fastq.gz
READS["Gallinas_G3POG_R2"]=${READS_ROOT}/Gross_misc/Gallinas_G3POG_adtrim_trim_pair_R2.fastq.gz
READS["Gallinas_G3POG_U"]=${READS_ROOT}/Gross_misc/Gallinas_G3POG_adtrim_trim_unpair_all.fastq.gz
READS["Gallinas_H3POG_R1"]=${READS_ROOT}/Gross_misc/Gallinas_H3POG_adtrim_trim_pair_R1.fastq.gz
READS["Gallinas_H3POG_R2"]=${READS_ROOT}/Gross_misc/Gallinas_H3POG_adtrim_trim_pair_R2.fastq.gz
READS["Gallinas_H3POG_U"]=${READS_ROOT}/Gross_misc/Gallinas_H3POG_adtrim_trim_unpair_all.fastq.gz
READS["Micos_2Boro_R1"]=${READS_ROOT}/Gross_misc/Micos_2Boro_adtrim_trim_pair_R1.fastq.gz
READS["Micos_2Boro_R2"]=${READS_ROOT}/Gross_misc/Micos_2Boro_adtrim_trim_pair_R2.fastq.gz
READS["Micos_2Boro_U"]=${READS_ROOT}/Gross_misc/Micos_2Boro_adtrim_trim_unpair_all.fastq.gz
READS["Molinos_2Boro_R1"]=${READS_ROOT}/Gross_misc/Molinos_2Boro_adtrim_trim_pair_R1.fastq.gz
READS["Molinos_2Boro_R2"]=${READS_ROOT}/Gross_misc/Molinos_2Boro_adtrim_trim_pair_R2.fastq.gz
READS["Molinos_2Boro_U"]=${READS_ROOT}/Gross_misc/Molinos_2Boro_adtrim_trim_unpair_all.fastq.gz
READS["Molinos_D3POG_R1"]=${READS_ROOT}/Gross_misc/Molinos_D3POG_adtrim_trim_pair_R1.fastq.gz
READS["Molinos_D3POG_R2"]=${READS_ROOT}/Gross_misc/Molinos_D3POG_adtrim_trim_pair_R2.fastq.gz
READS["Molinos_D3POG_U"]=${READS_ROOT}/Gross_misc/Molinos_D3POG_adtrim_trim_unpair_all.fastq.gz
READS["Pachon_1Gross_R1"]=${READS_ROOT}/Gross_misc/Pachon_1Gross_adtrim_trim_pair_R1.fastq.gz
READS["Pachon_1Gross_R2"]=${READS_ROOT}/Gross_misc/Pachon_1Gross_adtrim_trim_pair_R2.fastq.gz
READS["Pachon_1Gross_U"]=${READS_ROOT}/Gross_misc/Pachon_1Gross_adtrim_trim_unpair_all.fastq.gz
READS["Pachon_2Gross_R1"]=${READS_ROOT}/Gross_misc/Pachon_2Gross_adtrim_trim_pair_R1.fastq.gz
READS["Pachon_2Gross_R2"]=${READS_ROOT}/Gross_misc/Pachon_2Gross_adtrim_trim_pair_R2.fastq.gz
READS["Pachon_2Gross_U"]=${READS_ROOT}/Gross_misc/Pachon_2Gross_adtrim_trim_unpair_all.fastq.gz
READS["Pachon_3Gross_R1"]=${READS_ROOT}/Gross_misc/Pachon_3Gross_adtrim_trim_pair_R1.fastq.gz
READS["Pachon_3Gross_R2"]=${READS_ROOT}/Gross_misc/Pachon_3Gross_adtrim_trim_pair_R2.fastq.gz
READS["Pachon_3Gross_U"]=${READS_ROOT}/Gross_misc/Pachon_3Gross_adtrim_trim_unpair_all.fastq.gz
READS["Pachon_6Boro_R1"]=${READS_ROOT}/Gross_misc/Pachon_6Boro_adtrim_trim_pair_R1.fastq.gz
READS["Pachon_6Boro_R2"]=${READS_ROOT}/Gross_misc/Pachon_6Boro_adtrim_trim_pair_R2.fastq.gz
READS["Pachon_6Boro_U"]=${READS_ROOT}/Gross_misc/Pachon_6Boro_adtrim_trim_unpair_all.fastq.gz
READS["Pachon_E2POG_R1"]=${READS_ROOT}/Gross_misc/Pachon_E2POG_adtrim_trim_pair_R1.fastq.gz
READS["Pachon_E2POG_R2"]=${READS_ROOT}/Gross_misc/Pachon_E2POG_adtrim_trim_pair_R2.fastq.gz
READS["Pachon_E2POG_U"]=${READS_ROOT}/Gross_misc/Pachon_E2POG_adtrim_trim_unpair_all.fastq.gz
READS["Pachon_F2POG_R1"]=${READS_ROOT}/Gross_misc/Pachon_F2POG_adtrim_trim_pair_R1.fastq.gz
READS["Pachon_F2POG_R2"]=${READS_ROOT}/Gross_misc/Pachon_F2POG_adtrim_trim_pair_R2.fastq.gz
READS["Pachon_F2POG_U"]=${READS_ROOT}/Gross_misc/Pachon_F2POG_adtrim_trim_unpair_all.fastq.gz
READS["Pachon_G2POG_R1"]=${READS_ROOT}/Gross_misc/Pachon_G2POG_adtrim_trim_pair_R1.fastq.gz
READS["Pachon_G2POG_R2"]=${READS_ROOT}/Gross_misc/Pachon_G2POG_adtrim_trim_pair_R2.fastq.gz
READS["Pachon_G2POG_U"]=${READS_ROOT}/Gross_misc/Pachon_G2POG_adtrim_trim_unpair_all.fastq.gz
READS["Pachon_H2POG_R1"]=${READS_ROOT}/Gross_misc/Pachon_H2POG_adtrim_trim_pair_R1.fastq.gz
READS["Pachon_H2POG_R2"]=${READS_ROOT}/Gross_misc/Pachon_H2POG_adtrim_trim_pair_R2.fastq.gz
READS["Pachon_H2POG_U"]=${READS_ROOT}/Gross_misc/Pachon_H2POG_adtrim_trim_unpair_all.fastq.gz
READS["Subter_1POG_R1"]=${READS_ROOT}/Gross_misc/Subter_1POG_adtrim_trim_pair_R1.fastq.gz
READS["Subter_1POG_R2"]=${READS_ROOT}/Gross_misc/Subter_1POG_adtrim_trim_pair_R2.fastq.gz
READS["Subter_1POG_U"]=${READS_ROOT}/Gross_misc/Subter_1POG_adtrim_trim_unpair_all.fastq.gz
READS["Subter_2POG_R1"]=${READS_ROOT}/Gross_misc/Subter_2POG_adtrim_trim_pair_R1.fastq.gz
READS["Subter_2POG_R2"]=${READS_ROOT}/Gross_misc/Subter_2POG_adtrim_trim_pair_R2.fastq.gz
READS["Subter_2POG_U"]=${READS_ROOT}/Gross_misc/Subter_2POG_adtrim_trim_unpair_all.fastq.gz
READS["Subter_3POG_R1"]=${READS_ROOT}/Gross_misc/Subter_3POG_adtrim_trim_pair_R1.fastq.gz
READS["Subter_3POG_R2"]=${READS_ROOT}/Gross_misc/Subter_3POG_adtrim_trim_pair_R2.fastq.gz
READS["Subter_3POG_U"]=${READS_ROOT}/Gross_misc/Subter_3POG_adtrim_trim_unpair_all.fastq.gz
READS["Subter_4POG_R1"]=${READS_ROOT}/Gross_misc/Subter_4POG_adtrim_trim_pair_R1.fastq.gz
READS["Subter_4POG_R2"]=${READS_ROOT}/Gross_misc/Subter_4POG_adtrim_trim_pair_R2.fastq.gz
READS["Subter_4POG_U"]=${READS_ROOT}/Gross_misc/Subter_4POG_adtrim_trim_unpair_all.fastq.gz
READS["Subter_5POG_R1"]=${READS_ROOT}/Gross_misc/Subter_5POG_adtrim_trim_pair_R1.fastq.gz
READS["Subter_5POG_R2"]=${READS_ROOT}/Gross_misc/Subter_5POG_adtrim_trim_pair_R2.fastq.gz
READS["Subter_5POG_U"]=${READS_ROOT}/Gross_misc/Subter_5POG_adtrim_trim_unpair_all.fastq.gz
READS["Subter_6POG_R1"]=${READS_ROOT}/Gross_misc/Subter_6POG_adtrim_trim_pair_R1.fastq.gz
READS["Subter_6POG_R2"]=${READS_ROOT}/Gross_misc/Subter_6POG_adtrim_trim_pair_R2.fastq.gz
READS["Subter_6POG_U"]=${READS_ROOT}/Gross_misc/Subter_6POG_adtrim_trim_unpair_all.fastq.gz
READS["Subter_7POG_R1"]=${READS_ROOT}/Gross_misc/Subter_7POG_adtrim_trim_pair_R1.fastq.gz
READS["Subter_7POG_R2"]=${READS_ROOT}/Gross_misc/Subter_7POG_adtrim_trim_pair_R2.fastq.gz
READS["Subter_7POG_U"]=${READS_ROOT}/Gross_misc/Subter_7POG_adtrim_trim_unpair_all.fastq.gz
READS["Subter_8POG_R1"]=${READS_ROOT}/Gross_misc/Subter_8POG_adtrim_trim_pair_R1.fastq.gz
READS["Subter_8POG_R2"]=${READS_ROOT}/Gross_misc/Subter_8POG_adtrim_trim_pair_R2.fastq.gz
READS["Subter_8POG_U"]=${READS_ROOT}/Gross_misc/Subter_8POG_adtrim_trim_unpair_all.fastq.gz
READS["Surface_1Gross_R1"]=${READS_ROOT}/Gross_misc/Surface_1Gross_adtrim_trim_pair_R1.fastq.gz
READS["Surface_1Gross_R2"]=${READS_ROOT}/Gross_misc/Surface_1Gross_adtrim_trim_pair_R2.fastq.gz
READS["Surface_1Gross_U"]=${READS_ROOT}/Gross_misc/Surface_1Gross_adtrim_trim_unpair_all.fastq.gz
READS["Surface_2Gross_R1"]=${READS_ROOT}/Gross_misc/Surface_2Gross_adtrim_trim_pair_R1.fastq.gz
READS["Surface_2Gross_R2"]=${READS_ROOT}/Gross_misc/Surface_2Gross_adtrim_trim_pair_R2.fastq.gz
READS["Surface_2Gross_U"]=${READS_ROOT}/Gross_misc/Surface_2Gross_adtrim_trim_unpair_all.fastq.gz
READS["Tinaja_1Boro_R1"]=${READS_ROOT}/Gross_misc/Tinaja_1Boro_adtrim_trim_pair_R1.fastq.gz
READS["Tinaja_1Boro_R2"]=${READS_ROOT}/Gross_misc/Tinaja_1Boro_adtrim_trim_pair_R2.fastq.gz
READS["Tinaja_1Boro_U"]=${READS_ROOT}/Gross_misc/Tinaja_1Boro_adtrim_trim_unpair_all.fastq.gz
READS["Tinaja_1Gross_R1"]=${READS_ROOT}/Gross_misc/Tinaja_1Gross_adtrim_trim_pair_R1.fastq.gz
READS["Tinaja_1Gross_R2"]=${READS_ROOT}/Gross_misc/Tinaja_1Gross_adtrim_trim_pair_R2.fastq.gz
READS["Tinaja_1Gross_U"]=${READS_ROOT}/Gross_misc/Tinaja_1Gross_adtrim_trim_unpair_all.fastq.gz
READS["Tinaja_2Gross_R1"]=${READS_ROOT}/Gross_misc/Tinaja_2Gross_adtrim_trim_pair_R1.fastq.gz
READS["Tinaja_2Gross_R2"]=${READS_ROOT}/Gross_misc/Tinaja_2Gross_adtrim_trim_pair_R2.fastq.gz
READS["Tinaja_2Gross_U"]=${READS_ROOT}/Gross_misc/Tinaja_2Gross_adtrim_trim_unpair_all.fastq.gz
READS["Tinaja_3Gross_R1"]=${READS_ROOT}/Gross_misc/Tinaja_3Gross_adtrim_trim_pair_R1.fastq.gz
READS["Tinaja_3Gross_R2"]=${READS_ROOT}/Gross_misc/Tinaja_3Gross_adtrim_trim_pair_R2.fastq.gz
READS["Tinaja_3Gross_U"]=${READS_ROOT}/Gross_misc/Tinaja_3Gross_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_C1Rnd1_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_C1Rnd1_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_C1Rnd1_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_C1Rnd1_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_C1Rnd1_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_C1Rnd1_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_C2Rnd1_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_C2Rnd1_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_C2Rnd1_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_C2Rnd1_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_C2Rnd1_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_C2Rnd1_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_C3Rnd1_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_C3Rnd1_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_C3Rnd1_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_C3Rnd1_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_C3Rnd1_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_C3Rnd1_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_C3Rnd2_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_C3Rnd2_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_C3Rnd2_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_C3Rnd2_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_C3Rnd2_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_C3Rnd2_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_C4Rnd1_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_C4Rnd1_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_C4Rnd1_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_C4Rnd1_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_C4Rnd1_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_C4Rnd1_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_C4Rnd2_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_C4Rnd2_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_C4Rnd2_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_C4Rnd2_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_C4Rnd2_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_C4Rnd2_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_C5Rnd1_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_C5Rnd1_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_C5Rnd1_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_C5Rnd1_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_C5Rnd1_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_C5Rnd1_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_C5Rnd2_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_C5Rnd2_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_C5Rnd2_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_C5Rnd2_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_C5Rnd2_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_C5Rnd2_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_C6Rnd1_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_C6Rnd1_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_C6Rnd1_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_C6Rnd1_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_C6Rnd1_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_C6Rnd1_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_C6Rnd2_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_C6Rnd2_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_C6Rnd2_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_C6Rnd2_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_C6Rnd2_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_C6Rnd2_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_C7Rnd1_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_C7Rnd1_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_C7Rnd1_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_C7Rnd1_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_C7Rnd1_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_C7Rnd1_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_C7Rnd2_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_C7Rnd2_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_C7Rnd2_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_C7Rnd2_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_C7Rnd2_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_C7Rnd2_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_E10Rnd2_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_E10Rnd2_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_E10Rnd2_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_E10Rnd2_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_E10Rnd2_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_E10Rnd2_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_E11Rnd2_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_E11Rnd2_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_E11Rnd2_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_E11Rnd2_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_E11Rnd2_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_E11Rnd2_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_E12Rnd2_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_E10Rnd2_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_E12Rnd2_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_E10Rnd2_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_E12Rnd2_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_E10Rnd2_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_E13Rnd2_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_E11Rnd2_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_E13Rnd2_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_E11Rnd2_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_E13Rnd2_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_E11Rnd2_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_E14Rnd2_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_E12Rnd2_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_E14Rnd2_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_E12Rnd2_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_E14Rnd2_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_E12Rnd2_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_E15Rnd2_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_E13Rnd2_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_E15Rnd2_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_E13Rnd2_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_E15Rnd2_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_E13Rnd2_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_E16Rnd2_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_E14Rnd2_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_E16Rnd2_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_E14Rnd2_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_E16Rnd2_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_E14Rnd2_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_E1Rnd1_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_E15Rnd2_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_E1Rnd1_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_E15Rnd2_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_E1Rnd1_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_E15Rnd2_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_E2Rnd1_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_E16Rnd2_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_E2Rnd1_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_E16Rnd2_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_E2Rnd1_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_E16Rnd2_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_E3Rnd1_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_E1Rnd1_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_E3Rnd1_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_E1Rnd1_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_E3Rnd1_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_E1Rnd1_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_E4Rnd1_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_E2Rnd1_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_E4Rnd1_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_E2Rnd1_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_E4Rnd1_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_E2Rnd1_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_E5Rnd1_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_E3Rnd1_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_E5Rnd1_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_E3Rnd1_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_E5Rnd1_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_E3Rnd1_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_E6Rnd1_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_E4Rnd1_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_E6Rnd1_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_E4Rnd1_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_E6Rnd1_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_E4Rnd1_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_E7Rnd1_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_E5Rnd1_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_E7Rnd1_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_E5Rnd1_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_E7Rnd1_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_E5Rnd1_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_E8Rnd1_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_E6Rnd1_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_E8Rnd1_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_E6Rnd1_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_E8Rnd1_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_E6Rnd1_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_E8Rnd2_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_E6Rnd1_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_E8Rnd2_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_E6Rnd1_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_E8Rnd2_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_E6Rnd1_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_E9Rnd2_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_E7Rnd1_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_E9Rnd2_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_E7Rnd1_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_E9Rnd2_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_E7Rnd1_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_S1Rnd1_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_E8Rnd1_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_S1Rnd1_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_E8Rnd1_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_S1Rnd1_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_E8Rnd1_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_S2Rnd1_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_E8Rnd2_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_S2Rnd1_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_E8Rnd2_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_S2Rnd1_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_E8Rnd2_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_S3Rnd1_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_E9Rnd2_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_S3Rnd1_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_E9Rnd2_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_S3Rnd1_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_E9Rnd2_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_Sr1Rnd1_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_S1Rnd1_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_Sr1Rnd1_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_S1Rnd1_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_Sr1Rnd1_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_S1Rnd1_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_Sr2Rnd1_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_S2Rnd1_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_Sr2Rnd1_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_S2Rnd1_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_Sr2Rnd1_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_S2Rnd1_adtrim_trim_unpair_all.fastq.gz
READS["CabMoro_Sr3Rnd1_R1"]=${READS_ROOT}/Caballo_Moro/CabMoro_S3Rnd1_adtrim_trim_pair_R1.fastq.gz
READS["CabMoro_Sr3Rnd1_R2"]=${READS_ROOT}/Caballo_Moro/CabMoro_S3Rnd1_adtrim_trim_pair_R2.fastq.gz
READS["CabMoro_Sr3Rnd1_U"]=${READS_ROOT}/Caballo_Moro/CabMoro_S3Rnd1_adtrim_trim_unpair_all.fastq.gz
READS["Mante_T6151_S25_R1"]=${READS_ROOT}/June2019/Mante_T6151_S25_adtrim_trim_pair_R1.fastq.gz
READS["Mante_T6151_S25_R2"]=${READS_ROOT}/June2019/Mante_T6151_S25_adtrim_trim_pair_R2.fastq.gz
READS["Mante_T6151_S25_U"]=${READS_ROOT}/June2019/Mante_T6151_S25_adtrim_trim_unpair_all.fastq.gz
READS["Mante_T6152_S24_R1"]=${READS_ROOT}/June2019/Mante_T6152_S24_adtrim_trim_pair_R1.fastq.gz
READS["Mante_T6152_S24_R2"]=${READS_ROOT}/June2019/Mante_T6152_S24_adtrim_trim_pair_R2.fastq.gz
READS["Mante_T6152_S24_U"]=${READS_ROOT}/June2019/Mante_T6152_S24_adtrim_trim_unpair_all.fastq.gz
READS["Mante_T6153_S28_R1"]=${READS_ROOT}/June2019/Mante_T6153_S28_adtrim_trim_pair_R1.fastq.gz
READS["Mante_T6153_S28_R2"]=${READS_ROOT}/June2019/Mante_T6153_S28_adtrim_trim_pair_R2.fastq.gz
READS["Mante_T6153_S28_U"]=${READS_ROOT}/June2019/Mante_T6153_S28_adtrim_trim_unpair_all.fastq.gz
READS["Mante_T6154_S29_R1"]=${READS_ROOT}/June2019/Mante_T6154_S29_adtrim_trim_pair_R1.fastq.gz
READS["Mante_T6154_S29_R2"]=${READS_ROOT}/June2019/Mante_T6154_S29_adtrim_trim_pair_R2.fastq.gz
READS["Mante_T6154_S29_U"]=${READS_ROOT}/June2019/Mante_T6154_S29_adtrim_trim_unpair_all.fastq.gz
READS["Mante_T6155_S26_R1"]=${READS_ROOT}/June2019/Mante_T6155_S26_adtrim_trim_pair_R1.fastq.gz
READS["Mante_T6155_S26_R2"]=${READS_ROOT}/June2019/Mante_T6155_S26_adtrim_trim_pair_R2.fastq.gz
READS["Mante_T6155_S26_U"]=${READS_ROOT}/June2019/Mante_T6155_S26_adtrim_trim_unpair_all.fastq.gz
READS["Mante_T6156_S27_R1"]=${READS_ROOT}/June2019/Mante_T6156_S27_adtrim_trim_pair_R1.fastq.gz
READS["Mante_T6156_S27_R2"]=${READS_ROOT}/June2019/Mante_T6156_S27_adtrim_trim_pair_R2.fastq.gz
READS["Mante_T6156_S27_U"]=${READS_ROOT}/June2019/Mante_T6156_S27_adtrim_trim_unpair_all.fastq.gz
READS["Mante_T6157_S22_R1"]=${READS_ROOT}/June2019/Mante_T6157_S22_adtrim_trim_pair_R1.fastq.gz
READS["Mante_T6157_S22_R2"]=${READS_ROOT}/June2019/Mante_T6157_S22_adtrim_trim_pair_R2.fastq.gz
READS["Mante_T6157_S22_U"]=${READS_ROOT}/June2019/Mante_T6157_S22_adtrim_trim_unpair_all.fastq.gz
READS["Mante_T6158_S20_R1"]=${READS_ROOT}/June2019/Mante_T6158_S20_adtrim_trim_pair_R1.fastq.gz
READS["Mante_T6158_S20_R2"]=${READS_ROOT}/June2019/Mante_T6158_S20_adtrim_trim_pair_R2.fastq.gz
READS["Mante_T6158_S20_U"]=${READS_ROOT}/June2019/Mante_T6158_S20_adtrim_trim_unpair_all.fastq.gz
READS["Mante_T6159_S23_R1"]=${READS_ROOT}/June2019/Mante_T6159_S23_adtrim_trim_pair_R1.fastq.gz
READS["Mante_T6159_S23_R2"]=${READS_ROOT}/June2019/Mante_T6159_S23_adtrim_trim_pair_R2.fastq.gz
READS["Mante_T6159_S23_U"]=${READS_ROOT}/June2019/Mante_T6159_S23_adtrim_trim_unpair_all.fastq.gz
READS["Mante_T6160_S21_R1"]=${READS_ROOT}/June2019/Mante_T6160_S21_adtrim_trim_pair_R1.fastq.gz
READS["Mante_T6160_S21_R2"]=${READS_ROOT}/June2019/Mante_T6160_S21_adtrim_trim_pair_R2.fastq.gz
READS["Mante_T6160_S21_U"]=${READS_ROOT}/June2019/Mante_T6160_S21_adtrim_trim_unpair_all.fastq.gz
READS["Nicara_T6903_S1_R1"]=${READS_ROOT}/June2019/Nicara_T6903_S1_adtrim_trim_pair_R1.fastq.gz
READS["Nicara_T6903_S1_R2"]=${READS_ROOT}/June2019/Nicara_T6903_S1_adtrim_trim_pair_R2.fastq.gz
READS["Nicara_T6903_S1_U"]=${READS_ROOT}/June2019/Nicara_T6903_S1_adtrim_trim_unpair_all.fastq.gz
READS["Nicara_T6904_S2_R1"]=${READS_ROOT}/June2019/Nicara_T6904_S2_adtrim_trim_pair_R1.fastq.gz
READS["Nicara_T6904_S2_R2"]=${READS_ROOT}/June2019/Nicara_T6904_S2_adtrim_trim_pair_R2.fastq.gz
READS["Nicara_T6904_S2_U"]=${READS_ROOT}/June2019/Nicara_T6904_S2_adtrim_trim_unpair_all.fastq.gz
READS["Peroles_1_S10_R1"]=${READS_ROOT}/June2019/Peroles_1_S10_adtrim_trim_pair_R1.fastq.gz
READS["Peroles_1_S10_R2"]=${READS_ROOT}/June2019/Peroles_1_S10_adtrim_trim_pair_R2.fastq.gz
READS["Peroles_1_S10_U"]=${READS_ROOT}/June2019/Peroles_1_S10_adtrim_trim_unpair_all.fastq.gz
READS["Peroles_10_T5644_S18_R1"]=${READS_ROOT}/June2019/Peroles_10_T5644_S18_adtrim_trim_pair_R1.fastq.gz
READS["Peroles_10_T5644_S18_R2"]=${READS_ROOT}/June2019/Peroles_10_T5644_S18_adtrim_trim_pair_R2.fastq.gz
READS["Peroles_10_T5644_S18_U"]=${READS_ROOT}/June2019/Peroles_10_T5644_S18_adtrim_trim_unpair_all.fastq.gz
READS["Peroles_11_T5648_S19_R1"]=${READS_ROOT}/June2019/Peroles_11_T5648_S19_adtrim_trim_pair_R1.fastq.gz
READS["Peroles_11_T5648_S19_R2"]=${READS_ROOT}/June2019/Peroles_11_T5648_S19_adtrim_trim_pair_R2.fastq.gz
READS["Peroles_11_T5648_S19_U"]=${READS_ROOT}/June2019/Peroles_11_T5648_S19_adtrim_trim_unpair_all.fastq.gz
READS["Peroles_2_S11_R1"]=${READS_ROOT}/June2019/Peroles_2_S11_adtrim_trim_pair_R1.fastq.gz
READS["Peroles_2_S11_R2"]=${READS_ROOT}/June2019/Peroles_2_S11_adtrim_trim_pair_R2.fastq.gz
READS["Peroles_2_S11_U"]=${READS_ROOT}/June2019/Peroles_2_S11_adtrim_trim_unpair_all.fastq.gz
READS["Peroles_3_S12_R1"]=${READS_ROOT}/June2019/Peroles_3_S12_adtrim_trim_pair_R1.fastq.gz
READS["Peroles_3_S12_R2"]=${READS_ROOT}/June2019/Peroles_3_S12_adtrim_trim_pair_R2.fastq.gz
READS["Peroles_3_S12_U"]=${READS_ROOT}/June2019/Peroles_3_S12_adtrim_trim_unpair_all.fastq.gz
READS["Peroles_5_T5650_S13_R1"]=${READS_ROOT}/June2019/Peroles_5_T5650_S13_adtrim_trim_pair_R1.fastq.gz
READS["Peroles_5_T5650_S13_R2"]=${READS_ROOT}/June2019/Peroles_5_T5650_S13_adtrim_trim_pair_R2.fastq.gz
READS["Peroles_5_T5650_S13_U"]=${READS_ROOT}/June2019/Peroles_5_T5650_S13_adtrim_trim_unpair_all.fastq.gz
READS["Peroles_6_T5643_S14_R1"]=${READS_ROOT}/June2019/Peroles_6_T5643_S14_adtrim_trim_pair_R1.fastq.gz
READS["Peroles_6_T5643_S14_R2"]=${READS_ROOT}/June2019/Peroles_6_T5643_S14_adtrim_trim_pair_R2.fastq.gz
READS["Peroles_6_T5643_S14_U"]=${READS_ROOT}/June2019/Peroles_6_T5643_S14_adtrim_trim_unpair_all.fastq.gz
READS["Peroles_7_T5645_S15_R1"]=${READS_ROOT}/June2019/Peroles_7_T5645_S15_adtrim_trim_pair_R1.fastq.gz
READS["Peroles_7_T5645_S15_R2"]=${READS_ROOT}/June2019/Peroles_7_T5645_S15_adtrim_trim_pair_R2.fastq.gz
READS["Peroles_7_T5645_S15_U"]=${READS_ROOT}/June2019/Peroles_7_T5645_S15_adtrim_trim_unpair_all.fastq.gz
READS["Peroles_8_T5649_S16_R1"]=${READS_ROOT}/June2019/Peroles_8_T5649_S16_adtrim_trim_pair_R1.fastq.gz
READS["Peroles_8_T5649_S16_R2"]=${READS_ROOT}/June2019/Peroles_8_T5649_S16_adtrim_trim_pair_R2.fastq.gz
READS["Peroles_8_T5649_S16_U"]=${READS_ROOT}/June2019/Peroles_8_T5649_S16_adtrim_trim_unpair_all.fastq.gz
READS["Peroles_9_T5647_S17_R1"]=${READS_ROOT}/June2019/Peroles_9_T5647_S17_adtrim_trim_pair_R1.fastq.gz
READS["Peroles_9_T5647_S17_R2"]=${READS_ROOT}/June2019/Peroles_9_T5647_S17_adtrim_trim_pair_R2.fastq.gz
READS["Peroles_9_T5647_S17_U"]=${READS_ROOT}/June2019/Peroles_9_T5647_S17_adtrim_trim_unpair_all.fastq.gz
READS["T5879_Tigre_S31_R1"]=${READS_ROOT}/June2019/T5879_Tigre_S31_adtrim_trim_pair_R1.fastq.gz
READS["T5879_Tigre_S31_R2"]=${READS_ROOT}/June2019/T5879_Tigre_S31_adtrim_trim_pair_R2.fastq.gz
READS["T5879_Tigre_S31_U"]=${READS_ROOT}/June2019/T5879_Tigre_S31_adtrim_trim_unpair_all.fastq.gz
READS["T5882_Tigre_S30_R1"]=${READS_ROOT}/June2019/T5882_Tigre_S30_adtrim_trim_pair_R1.fastq.gz
READS["T5882_Tigre_S30_R2"]=${READS_ROOT}/June2019/T5882_Tigre_S30_adtrim_trim_pair_R2.fastq.gz
READS["T5882_Tigre_S30_U"]=${READS_ROOT}/June2019/T5882_Tigre_S30_adtrim_trim_unpair_all.fastq.gz
READS["Vasquez_V10_S9_R1"]=${READS_ROOT}/June2019/Vasquez_V10_S9_adtrim_trim_pair_R1.fastq.gz
READS["Vasquez_V10_S9_R2"]=${READS_ROOT}/June2019/Vasquez_V10_S9_adtrim_trim_pair_R2.fastq.gz
READS["Vasquez_V10_S9_U"]=${READS_ROOT}/June2019/Vasquez_V10_S9_adtrim_trim_unpair_all.fastq.gz
READS["Vasquez_V3_S3_R1"]=${READS_ROOT}/June2019/Vasquez_V3_S3_adtrim_trim_pair_R1.fastq.gz
READS["Vasquez_V3_S3_R2"]=${READS_ROOT}/June2019/Vasquez_V3_S3_adtrim_trim_pair_R2.fastq.gz
READS["Vasquez_V3_S3_U"]=${READS_ROOT}/June2019/Vasquez_V3_S3_adtrim_trim_unpair_all.fastq.gz
READS["Vasquez_V5_S4_R1"]=${READS_ROOT}/June2019/Vasquez_V5_S4_adtrim_trim_pair_R1.fastq.gz
READS["Vasquez_V5_S4_R2"]=${READS_ROOT}/June2019/Vasquez_V5_S4_adtrim_trim_pair_R2.fastq.gz
READS["Vasquez_V5_S4_U"]=${READS_ROOT}/June2019/Vasquez_V5_S4_adtrim_trim_unpair_all.fastq.gz
READS["Vasquez_V6_S5_R1"]=${READS_ROOT}/June2019/Vasquez_V6_S5_adtrim_trim_pair_R1.fastq.gz
READS["Vasquez_V6_S5_R2"]=${READS_ROOT}/June2019/Vasquez_V6_S5_adtrim_trim_pair_R2.fastq.gz
READS["Vasquez_V6_S5_U"]=${READS_ROOT}/June2019/Vasquez_V6_S5_adtrim_trim_unpair_all.fastq.gz
READS["Vasquez_V7_S6_R1"]=${READS_ROOT}/June2019/Vasquez_V7_S6_adtrim_trim_pair_R1.fastq.gz
READS["Vasquez_V7_S6_R2"]=${READS_ROOT}/June2019/Vasquez_V7_S6_adtrim_trim_pair_R2.fastq.gz
READS["Vasquez_V7_S6_U"]=${READS_ROOT}/June2019/Vasquez_V7_S6_adtrim_trim_unpair_all.fastq.gz
READS["Vasquez_V8_S7_R1"]=${READS_ROOT}/June2019/Vasquez_V8_S7_adtrim_trim_pair_R1.fastq.gz
READS["Vasquez_V8_S7_R2"]=${READS_ROOT}/June2019/Vasquez_V8_S7_adtrim_trim_pair_R2.fastq.gz
READS["Vasquez_V8_S7_U"]=${READS_ROOT}/June2019/Vasquez_V8_S7_adtrim_trim_unpair_all.fastq.gz
READS["Vasquez_V9_S8_R1"]=${READS_ROOT}/June2019/Vasquez_V9_S8_adtrim_trim_pair_R1.fastq.gz
READS["Vasquez_V9_S8_R2"]=${READS_ROOT}/June2019/Vasquez_V9_S8_adtrim_trim_pair_R2.fastq.gz
READS["Vasquez_V9_S8_U"]=${READS_ROOT}/June2019/Vasquez_V9_S8_adtrim_trim_unpair_all.fastq.gz
READS["Pachon_ref_R1"]=${READS_ROOT}/Pachon_ref/Pachon_ref_adtrim_trim_pair_R1.fastq.gz
READS["Pachon_ref_R2"]=${READS_ROOT}/Pachon_ref/Pachon_ref_adtrim_trim_pair_R2.fastq.gz
READS["Pachon_ref_U"]=${READS_ROOT}/Pachon_ref/Pachon_ref_adtrim_trim_unpair_all.fastq.gz

# Then, for each sample, print out the BWA command that will make the proper
# directory, and run the read mapping
for s in ${SAMPLES[@]}
do
    # Define output file
    outfile=${OUTDIR}/${s}_raw.bam
    # Get the R1, R2, Un read paths
    r1=${READS["${s}_R1"]}
    r2=${READS["${s}_R2"]}
    un=${READS["${s}_U"]}
    # echo the commands. Note that we merge the R1 and R2 files, then append the
    # unpaired reads
    echo "(${SEQTK} mergepe ${r1} ${r2}; gzip -cd ${un}) | bwa mem -t ${THREADS} -k 12 -M -p ${REFBASE} - | samtools view -hbu - | samtools sort -o ${outfile} -@ ${THREADS} -"
done

# Note - this will give us raw, sorted bam files contaiing mapped and unmapped reads. 

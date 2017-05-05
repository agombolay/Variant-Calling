#!/bin/bash

#Run Abyss

#File paths
path=/projects/home/agombolay3/data/repository/Variant-Calling-Project/Sequencing
output=/projects/home/agombolay3/data/repository/Variant-Calling-Project/Assemblies

#Merge files of Library 1
#zcat $path/YS486-1_S49_L001_R1_001.fastq.gz $path/YS486-1_S49_L002_R1_001.fastq.gz > $path/YS486-1_R1.fastq.gz
#zcat $path/YS486-1_S49_L001_R2_001.fastq.gz $path/YS486-1_S49_L002_R2_001.fastq.gz > $path/YS486-1_R2.fastq.gz

#Merge files of Library 2
#zcat $path/YS486-2_S58_L001_R1_001.fastq.gz $path/YS486-2_S58_L002_R1_001.fastq.gz > $path/YS486-2_R1.fastq.gz
#zcat $path/YS486-2_S58_L001_R2_001.fastq.gz $path/YS486-2_S58_L002_R2_001.fastq.gz > $path/YS486-2_R2.fastq.gz

#Unzip files
#gunzip $path/YS486-1_R1.fastq.gz $path/YS486-1_R2.fastq.gz $path/YS486-2_R1.fastq.gz $path/YS486-2_R2.fastq.gz

#Run Abyss
abyss-pe k=64 name=YS486 lib='pea peb' pea='$path/YS486-1_R1.fastq $path/YS486-1_R2.fastq' peb='$path/YS486-2_R1.fastq $path/YS486-2_R2.fastq'
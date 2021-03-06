#!/usr/bin/env bash

#Author: Alli Gombolay
#This script identifies variants among cases and controls

#Usage statement
function usage () {
        echo "Usage: Variants.sh [options]
		-s Sample names (YS486 CM3 CM6 CM9 CM10 CM11 CM12 CM41)
		-d Local user directory (e.g., /projects/home/agombolay3/data/repository)"
}

#Command-line options
while getopts "s:d:h" opt; do
    case $opt in
	#Allow multiple input arguments
	s ) samples=($OPTARG) ;;
	#Allow only one input argument
	d ) directory=$OPTARG ;;
    	#Print usage statement
    	h ) usage ;;
    esac
done

#Exit program if [-h]
if [ "$1" == "-h" ]; then
        exit
fi

#############################################################################################################################
#Java files
picard=/projects/home/agombolay3/data/bin/picard.jar
gatk=/projects/home/agombolay3/data/bin/GenomeAnalysisTK.jar

#Reference files
ref=$directory/Variant-Calling/References/sacCer3.fa
dictionary=$directory/Variant-Calling/References/sacCer3.dict

#Create output directory
output=$directory/Variant-Calling/Variants; mkdir -p $output

#############################################################################################################################
for sample in ${samples[@]}; do

	#Input files
	VCF=$directory/Variant-Calling/References/sacCer3.vcf
	mapped=$directory/Variant-Calling/Alignment/$sample.bam

	#Add read groups
  	java -jar $picard AddOrReplaceReadGroups I=$mapped O=$output/$sample-1.bam \
	RGLB=$sample-library RGPL=Illumina RGPU=HiSeq RGSM=$sample-sample 
	
	#Index BAM file
	samtools index $output/$sample-1.bam
	
  	#Mark duplicate reads
  	java -jar $picard MarkDuplicates I=$output/$sample-1.bam O=$output/$sample-2.bam M=$output/$sample.txt

	#Index BAM file
	samtools index $output/$sample-2.bam
	
	#Base quality score recalibration
	java -jar $gatk -T BaseRecalibrator -R $ref -I $output/$sample-2.bam -knownSites $VCF -o $output/$sample.recal
   
   	#Create a recalibrated BAM with print reads
   	java -jar $gatk -T PrintReads -R $ref -I $output/$sample-2.bam -BQSR $output/$sample.recal -o $output/$sample-3.bam
   
   	#Index BAM file
	samtools index $output/$sample-3.bam
	
	#Call variants with HaplotypeCaller (ploidy=1)
	java -jar $gatk -T HaplotypeCaller -ploidy 1 -R $ref -I $output/$sample-3.bam -ERC GVCF -o $output/$sample.g.vcf

done
  
#Joint genotyping with GATK's GenotypeGVCFs tool
#java -jar $gatk -T GenotypeGVCFs --variant $output/YS486.g.vcf --variant $output/CM3.g.vcf --variant $output/CM6.g.vcf \
#--variant $output/CM9.g.vcf --variant $output/CM10.g.vcf --variant $output/CM11.g.vcf --variant $output/CM12.g.vcf \
#--variant $output/CM41.g.vcf -R $reference -o $output/Variants.vcf

#Remove temporary files
#rm -f $output/$sample*.bam $output/$sample.recal $output/$sample.txt

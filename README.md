# Variant Calling

**Goal**: Find variants that enhance DSB repair via homologous recombination using transcript RNA as template

### Controls
YS 486-1, YS486-2, CM 281-1, and CM281-2
* YS486-1 and YS486-2 were combined into one FASTQ

### Cases (libraries treated with EMS)
* CM 3, CM 6, CM 9, CM 10, CM 11, CM 12, and CM 41

### Methods
1. Trim reads: Trimmomatic
2. Alignment to reference: Bowtie2
3. Examine unmapped reads with FastQC
4. Determine alignment coverage of genome
5. Add read groups and mark duplicates: Picard Tools
6. Variant calling and joint genotyping (Halotype GVCF): GATK Tools
7. Filter VCF file based on quality, depth, and mutation type: SnpSift

### Reference Genome
* [sacCer3 FASTA from UCSC](http://hgdownload.soe.ucsc.edu/goldenPath/sacCer3/bigZips/)
* [sacCer3 VCF from Ensembl](https://www.ensembl.org/info/data/ftp/index.html)

```
#Change format to match VCF
sed -i -e 's/chr//g' sacCer3.bed
```
```
sed -i -e 's/M/Mito/g' sacCer3.bed
```

### Calculate average coverage
```
#Determine coverage at each position
bedtools genomecov -d -ibam BAM -g BED > Coverage.bed
```
```
#Count average coverage at each position
awk '{ total += $3 } END { print total/NR }' Coverage.bed
```
```
#Count 0's
grep -w 0$
```

### Set-up
```
#Create reference index
samtools faidx reference.fa
cut -f1,2 reference.fa.fai > BED
```
```
#Create reference dictionary file
java -jar picard.jar CreateSequenceDictionary R=reference O=dictionary
```

#!/bin/bash
# Usage: bash MeDIP-seq_run.sh medip.fq


adapter_1="AGATCGGAAGAGCACACGTCTGAAC"
adapter_2="AGATCGGAAGAGCGTCGTGTAGGGA"
notrim="--no-trim"
threads=12
index="/home/Resource/Genome/mm10/bwa_index_mm10/mm10.fa"
chr_size='/home/Resource/Genome/mm10/mm10.chrom.sizes'


medip_file=$1

echo  "processing MeDIP-seq $medip_file"

mkdir Processed_${medip_file}
ln -s `pwd`/${medip_file} ./Processed_${medip_file}
cd Processed_${medip_file}

adapter_1="AGATCGGAAGAGCACACGTCTGAAC"
adapter_2="AGATCGGAAGAGCGTCGTGTAGGGA"
notrim="--no-trim"
threads=12

### cutadapt
echo 'triming files'
cutadapt $notrim -j $threads -a $adapter_1 --quality-cutoff=15,10 -o trimed_${medip_file}  $medip_file > step1_cutadapt.medip.trimlog

### mapping
echo "aligning" $medip_file
bwa mem -t $threads $index trimed_${medip_file} | samtools view  -bS - | samtools sort - -O 'bam' -o step2_${medip_file}.bam -T temp_aln

### methylQA 
methylQA medip  -o step3_methylQA_${medip_file} $chr_size step2_${medip_file}.bam



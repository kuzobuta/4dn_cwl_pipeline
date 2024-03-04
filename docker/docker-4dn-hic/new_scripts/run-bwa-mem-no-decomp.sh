#!/bin/bash
#No tar & unzip bwa-mem
#Original script from "run-bwa-mem.sh"

fastq1=$1
fastq2=$2
index=$3
outdir=$4
prefix=$5
nThreads=$6

if [[ $outdir != '.' ]]
then
  mkdir -p $outdir
  outbam_file=${outdir}/${prefix}.bam
else
  outbam_file=${prefix}.bam
fi

# run bwa
bwa mem -t $nThreads -SP5M $index $fastq1 $fastq2 | samtools view -Shb -o $outbam_file -
#!/bin/sh
#221025 by Hisashi Miura
#Download mm10/GRCm38 reference files from 4DN database

mkdir -p references
mkdir -p references/mm10
mkdir -p references/mm10/bwa_idx
mkdir -p references/mm10/chromsize
mkdir -p references/mm10/sites
mkdir -p references/mm10/sites/MboI
mkdir -p references/mm10/sites/DpnII
mkdir -p references/mm10/sites/HindIII

#mm10 bwa index
cd references/mm10/bwa_idx
wget https://4dn-open-data-public.s3.amazonaws.com/fourfront-webprod/files/4a6d10ee-2edb-4402-a98f-0edb1d58f5e1/4DNFI823LSI8.bwaIndex.tgz
tar -vzxf 4DNFI823LSI8.bwaIndex.tgz

#mm10 fasta#
wget https://4dn-open-data-public.s3.amazonaws.com/fourfront-webprod/files/58be6da0-9d39-484e-9f13-54a699913450/4DNFIC1NWMVJ.fasta.gz 
gzip -dc 4DNFIC1NWMVJ.fasta.gz > mm10_no_alt_analysis_set_ENCODE.fasta

#mm10 chrom.size
cd ../chromsize
wget https://4dn-open-data-public.s3.amazonaws.com/fourfront-webprod/files/bd0784a5-2a3d-42f0-ba9c-d9b3dc0539c6/4DNFI3UBJ3HZ.chrom.sizes

#mm10 MboI sites
cd ../sites/MboI
wget https://4dn-open-data-public.s3.amazonaws.com/fourfront-webprod/files/cb3c293b-b5fe-4f47-9373-a29399ea1edc/4DNFIONK4G14.txt

#mm10 DpnII sites
cd ../sites/DpnII
wget https://4dn-open-data-public.s3.amazonaws.com/fourfront-webprod/files/62da1021-3c96-4aa5-8a06-e5d6cfe9aab1/4DNFI3HVC1SE.txt

#mm10 HindIII sites
cd ../HindIII
wget https://4dn-open-data-public.s3.amazonaws.com/fourfront-webprod/files/8e29e9ae-f13c-4a7b-9236-dba35a69bbff/4DNFI6V32T9J.txt

echo "Download 4DN mm10 reference data "`date`

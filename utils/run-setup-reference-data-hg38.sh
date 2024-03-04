#!/bin/sh
# 221220 by Hisashi Miura
# Download GRCh38 no alt v15 (hg38) reference files from 4DN database

mkdir -p references
mkdir -p references/hg38
mkdir -p references/hg38/bwa_idx
mkdir -p references/hg38/chromsize
mkdir -p references/hg38/sites
mkdir -p references/hg38/sites/MboI
mkdir -p references/hg38/sites/DpnII
mkdir -p references/hg38/sites/HindIII

#hg38 bwa index#
cd references/hg38/bwa_idx
wget https://4dn-open-data-public.s3.amazonaws.com/fourfront-webprod/files/1f53df95-4cf3-41cc-971d-81bb16c486dd/4DNFIZQZ39L9.bwaIndex.tgz
tar -vzxf 4DNFIZQZ39L9.bwaIndex.tgz

#hg38 fasta#
wget https://4dn-open-data-public.s3.amazonaws.com/fourfront-webprod/files/4a6d10ee-2edb-4402-a98f-0edb1d58ddd2/4DNFI823L888.fasta.gz
gzip -dc 4DNFI823L888.fasta.gz > GRCh38_no_alt_analysis_set_GCA_000001405.15.fasta

#hg38 chrom.size#
cd ../chromsize
wget https://4dn-open-data-public.s3.amazonaws.com/fourfront-webprod/files/4a6d10ee-2edb-4402-a98f-0edb1d58f5e9/4DNFI823LSII.chrom.sizes

#hg38 MboI sites#
cd ../sites/MboI
wget https://4dn-open-data-public.s3.amazonaws.com/fourfront-webprod/files/4a6d10ee-2edb-4402-a98f-0edb1d582084/4DNFI823L812.txt

#hg38 DpnII sites#
cd ../sites/DpnII
wget https://4dn-open-data-public.s3.amazonaws.com/fourfront-webprod/files/84db9821-3b82-4c6a-bf4f-5e0b3f43036e/4DNFIBNAPW3O.txt

#hg38 HindIII sites#
cd ../HindIII
wget https://4dn-open-data-public.s3.amazonaws.com/fourfront-webprod/files/595763c6-58d3-4ec4-8f04-3dbb88ed4736/4DNFI823MBKE.txt

echo "Download 4DN hg38 reference data "`date`

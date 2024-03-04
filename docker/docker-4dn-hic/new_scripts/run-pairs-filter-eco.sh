#!/usr/bin/env bash
#Pairs file
#Not to output unmapped pairs file, lossless bam file
if [ $# -le 2 ] ; then
    echo "Usage: bash run-pairs-filter-eco.sh PAIRSAM OUTPUT_PREFIX CHR_SIZES"
    echo ""
    echo "A example run-pairs-filter.sh pipeline for processing sorted reads to get nodup pairs file"
    echo ""
    echo "positional arguments:"
    echo ""
    echo "PAIRSAM             The path to a PAIRSAM/PAIRS file."
    echo "OUTPUT_PREFIX       The prefix to the paths of generated outputs. "
    echo "CHR_SIZES           Chromosomes and their sizes "
    echo ""
    echo ""

    exit 0
fi
set -o errexit
set -o nounset
set -o pipefail

PAIRSAM=$1
OUTPREFIX=$2
CHR_SIZES=$3

DEDUP_PAIRS=${OUTPREFIX}.dedup.pairs.gz
TEMPFILE=temp.gz
TEMPFILE1=temp1.gz

# Split pairs file
pairtools split --output-pairs ${TEMPFILE} ${PAIRSAM}

# Select UU, UR, RU reads
pairtools select '(pair_type == "UU") or (pair_type == "UR") or (pair_type == "RU")' \
    --output ${TEMPFILE1} \
    ${TEMPFILE}

pairtools select 'True' --chrom-subset ${CHR_SIZES} -o ${DEDUP_PAIRS} ${TEMPFILE1}

pairix ${DEDUP_PAIRS}  # sanity check & indexing    

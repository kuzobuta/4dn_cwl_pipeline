#!/bin/bash
shopt -s extglob
#240228 a single pairs file filtering based on dist

##default setting##
input_pairs=''
output_prefix=out
dist=2000
###################

printHelpAndExit() {
    echo "Usage: ${0##*/} [-o out_prefix], -i input_pairs -d dist"
    echo ""
    echo "Arguments:"
    echo "-i input_pairs          Input file in pairs.gz format [XXX.pairs.gz]"
    echo "-d dist                 Set the distance between pos1 and pos2 in same chr for filtering (default 2000)"
    echo "-o out_prefix           default out"
    echo ""
    exit "$1"
}

if [ $# -eq 0 ]; then
    printHelpAndExit 1
fi

while getopts "i:d:o:" opt; do
    case $opt in
        i) input_pairs=$OPTARG;;
        d) dist=$OPTARG;;
        o) output_prefix=$OPTARG;;
        h) printHelpAndExit 0;;
        [?]) printHelpAndExit 1;;
        esac
done

PAIRS=${input_pairs}
DIST_FILTER_PAIRS=${output_prefix}_filter-${dist}.pairs.gz
DIST_PAIRS=tmp_dist.gz

# Dist filtering
pairtools select \
"(chrom1 == chrom2) and (abs(pos1 - pos2) <= $dist)" \
--output-rest ${DIST_FILTER_PAIRS} \
--output ${DIST_PAIRS} \
${PAIRS}

pairix ${DIST_FILTER_PAIRS}

# Check n pairs
ori_n_pairs=`gzip -dc ${PAIRS} | awk '{n += /^#/}END{n_pairs= FNR - n; print n_pairs, "pairs"}'`
filter_n_pairs=`gzip -dc ${DIST_PAIRS} | awk '{n += /^#/}END{n_pairs= FNR - n; print n_pairs, "pairs"}'`
rest_n_pairs=`gzip -dc ${DIST_FILTER_PAIRS} | awk '{n += /^#/}END{n_pairs= FNR - n; print n_pairs, "pairs"}'`

echo "#Original_pairs: $ori_n_pairs
#Dist_filter_pairs: $filter_n_pairs
#Dist_filtered_pairs: $rest_n_pairs" > ${output_prefix}_dist_filter_${dist}_n_pairs.txt


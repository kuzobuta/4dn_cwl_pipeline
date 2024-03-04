#!/bin/bash
shopt -s extglob
#240229 ver.
#Hisashi's way 4DN Hi-C docker pipeline [Filtering]
#If you want to have a same data to the 4DN data base, you can skip this.
#Use the output file from "run-addfrag2pairs.sh"

##default setting##
input_pairs=''
mapq=10 #I typically use 10, but in general 30 may be good?
output_prefix=out
fragment_filter=1
frag_info=1
###################

printHelpAndExit() {
    echo "Usage: ${0##*/} [-o out_prefix, -f, -R] -i input_pairs -q MAPQ"
    echo ""
    echo "Arguments:"
    echo "-i input_pairs          Input file in pairs.gz format [XXX.ff.pairs.gz]"
    echo "-q MAPQ                 Set the Mapping Quality for filtering (default 10)"
    echo "-o out_prefix           default out"
    echo "-f                      Disable filtering the pairs with same fragment id (default on)"
    echo "-R                      No frag file info (MNase, DNaseI Hi-C)"
    echo ""
    exit "$1"
}

if [ $# -eq 0 ]; then
    printHelpAndExit 1
fi

while getopts "i:q:o:fR" opt; do
    case $opt in
        i) input_pairs=$OPTARG;;
        q) mapq=$OPTARG;;
        o) output_prefix=$OPTARG;;
        f) fragment_filter=0;;
        R) frag_info=0;;
        h) printHelpAndExit 0;;
        [?]) printHelpAndExit 1;;
        esac
done

# Make sure that no fragment filtering in no frag file
if [ $frag_info -eq 0 ]; then
fragment_filter=0
fi

echo "# ${input_pairs} fragment-filtering & MAPQ start: "`date`

## Filtering by Hisashi##
# Select the reads is not mapped into same fragment
if [ $fragment_filter -eq 1 ]; then

echo "# ${input_pairs} fragment-filtering start: "`date`

FFPAIR=${input_pairs}
FFPAIR_SAME=${output_prefix}.ff.same.pairs.gz
FFPAIR_NON_SAME=${output_prefix}.ff.filter_same.pairs.gz

pairtools select '(chrom1 == chrom2) and (frag1 == frag2)' \
--output-rest ${FFPAIR_NON_SAME} \
--output ${FFPAIR_SAME} \
${FFPAIR}

pairix ${FFPAIR_NON_SAME}
pairix ${FFPAIR_SAME}

echo "# ${input_pairs} fragment-filtering end: "`date`

else

echo "# ${input_pairs} No fragment-filtering : "`date`
FFPAIR_NON_SAME=${input_pairs}

fi

# MAPQ filter
if [ $fragment_filter -eq 1 ]; then
FFPAIR_NON_SAME_MAPQ=${output_prefix}.ff.filter_same.MAPQ${mapq}.pairs.gz
else
FFPAIR_NON_SAME_MAPQ=${output_prefix}.MAPQ${mapq}.pairs.gz
fi

echo "# ${input_pairs} MAPQ filtering >= $mapq start: "`date`

pairtools select "(mapq1>=${mapq}) and (mapq2>=${mapq})" \
--output ${FFPAIR_NON_SAME_MAPQ} \
${FFPAIR_NON_SAME}

pairix ${FFPAIR_NON_SAME_MAPQ}

echo "# ${input_pairs} MAPQ filtering >= $mapq end: "`date`
echo "# ${input_pairs} fragment-filtering & MAPQ end: "`date`

# Check n pairs
ori_n_pairs=`gzip -dc ${input_pairs} | awk '{n += /^#/}END{n_pairs= FNR - n; print n_pairs, "pairs"}'`

if [ ${#FFPAIR_SAME} -gt 0 ]; then
samefrag_n_pairs=`gzip -dc ${FFPAIR_SAME} | awk '{n += /^#/}END{n_pairs= FNR - n; print n_pairs, "pairs"}'`
non_samefrag_n_pairs=`gzip -dc ${FFPAIR_NON_SAME} | awk '{n += /^#/}END{n_pairs= FNR - n; print n_pairs, "pairs"}'`
fi

frag_mapq_filtered_n_pairs=`gzip -dc ${FFPAIR_NON_SAME_MAPQ} | awk '{n += /^#/}END{n_pairs= FNR - n; print n_pairs, "pairs"}'`

if [ ${#FFPAIR_SAME} -gt 0 ];then

echo "#Original_pairs: $ori_n_pairs
#Samefrag_pairs: $samefrag_n_pairs
#Samefrag_filtered_pairs: $non_samefrag_n_pairs
#Samefrag-mapq_filtered_pairs: $frag_mapq_filtered_n_pairs" > ${output_prefix}_samefrag_mapq${mapq}_filter_n_pairs.txt

else

echo "#Original_pairs: $ori_n_pairs
#Mapq_filtered_pairs: $frag_mapq_filtered_n_pairs" > ${output_prefix}_mapq${mapq}_filter_n_pairs.txt

fi


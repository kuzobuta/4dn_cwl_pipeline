#!/bin/bash
# Test run of cwl hi-c pipeline using using singularity [eco mode]
#
######Before run#######
#$ conda activate singularity_cwltool_env
#
# Set the test_data fastq files under "../data"
#######################

##Load conda env vars & activate conda env####
#source /PATH_TO/miniforge3/etc/profile.d/conda.sh
#conda activate singularity_cwltool_env
##############################################

####Directories####
OUTDIR=../results/   #output directory
TMP_PREFIX=${OUTDIR}/tmp_
CACHE=tmp_cache
LOG=${OUTDIR}/logs
###################

mkdir -p ${OUTDIR}
mkdir -p ${LOG}      #cwl logs

####Cwl run options####
cwl_options="--singularity --non-strict --debug"
cwl_runner="cwltool $cwl_options --tmpdir-prefix $TMP_PREFIX --cachedir $CACHE"
#######################

echo "# Start test run [4dn eco/new mode]:                   "`date`
echo "# Test  run 1~9"

#set run number
i=0

# 1. Mapping multiple fastq files
i=`expr $i + 1`
OUTDIR=../results/4dn_default_bam
mkdir -p ${OUTDIR}

$cwl_runner --outdir $OUTDIR \
cwl/bwa-mem-no-decomp-multi.cwl \
cwl-test-run-eco-yml/bwa-mem-no-decomp-multi-run.yml \
&> ${LOG}/run_bwa-mem-no-decomp-multi.cwl.log
echo "# End   test run $i   mapping:                          "`date`


# 2-1. Bam to valid pairs SRR1658790 4dn [eco mode]
i=`expr $i + 1`
OUTDIR=../results/4dn_eco_validpairs
mkdir -p ${OUTDIR}

$cwl_runner --outdir $OUTDIR \
cwl/hi-c-processing-bam-eco.cwl \
cwl-test-run-eco-yml/hi-c-processing-bam-eco-run-SRR1658790.yml \
&> ${LOG}/run_hi-c-processing-bam-eco.cwl_SRR1658790.log
echo "# End   test run $i-1 bam to validpairs [eco mode]:     "`date`


# 2-2. Bam to valid pairs SRR1658793 4dn [eco mode]
$cwl_runner --outdir $OUTDIR \
cwl/hi-c-processing-bam-eco.cwl \
cwl-test-run-eco-yml/hi-c-processing-bam-eco-run-SRR1658793.yml \
&> ${LOG}/run_hi-c-processing-bam-eco.cwl_SRR1658793.log
echo "# End   test run $i-2 bam to validpairs [eco mode]:     "`date`


# 3. Merge filtered pairs & generate .hic / .mcool 4dn [new mode]
i=`expr $i + 1`
OUTDIR=../results/4dn_new_hic_mcool
mkdir -p ${OUTDIR}

$cwl_runner --outdir $OUTDIR \
cwl/hi-c-processing-pairs-new.cwl \
cwl-test-run-eco-yml/hi-c-processing-pairs-new-run.yml \
&> ${LOG}/run_hi-c-processing-pairs-new.cwl.log
echo "# End   test run $i   validpairs to mat [new mode]:     "`date`


# 4-1. fragment/MAPQ filtering [fragment & MAPQ]
i=`expr $i + 1`
OUTDIR=../results/4dn_new_hic_mcool_filter_pairs
mkdir -p ${OUTDIR}

$cwl_runner --outdir $OUTDIR \
--outdir $OUTDIR \
--tmpdir-prefix $TMP_PREFIX \
--cachedir $CACHE \
cwl/pairs-filter-samefrag-MAPQ.cwl \
cwl-test-run-eco-yml/pairs-filter-samefrag-MAPQ-run.yml \
&> ${LOG}/run_pairs-filter-samefrag-MAPQ.cwl.log
echo "# End   test run $i-1 pairs filter Frag/MAPQ[new mode]: "`date`

# 4-2. fragment/MAPQ filtering [MAPQ only]
$cwl_runner --outdir $OUTDIR \
--outdir $OUTDIR \
--tmpdir-prefix $TMP_PREFIX \
--cachedir $CACHE \
cwl/pairs-filter-samefrag-MAPQ.cwl \
cwl-test-run-eco-yml/pairs-filter-samefrag-MAPQ-run-Nofrag.yml \
&> ${LOG}/run_pairs-filter-samefrag-MAPQ-Nofrag.cwl.log
echo "# End   test run $i-2 pairs filter MAPQ [new mode]:     "`date`

# 5-1. dist filtering
i=`expr $i + 1`
# 2kb
OUTDIR=../results/4dn_new_dist_filter_pairs
mkdir -p ${OUTDIR}

$cwl_runner --outdir $OUTDIR \
cwl/pairs-filter-dist.cwl \
cwl-test-run-eco-yml/pairs-filter-dist-run-2kb.yml \
&> ${LOG}/run_pairs-filter-dist.cwl-2kb.log
echo "# End   test run $i-1 pairs filter dist 2kb [new mode]: "`date`

# 5-2. dist filtering
# 1kb
$cwl_runner --outdir $OUTDIR \
cwl/pairs-filter-dist.cwl \
cwl-test-run-eco-yml/pairs-filter-dist-run-1kb.yml \
&> ${LOG}/run_pairs-filter-dist.cwl-1kb.log
echo "# End   test run $i-2 pairs filter dist 1kb [new mode]: "`date`


# 6. Merge pairs & add fragment info
i=`expr $i + 1`
OUTDIR=../results/4dn_new_add_frag_filter_pairs
mkdir -p $OUTDIR

$cwl_runner --outdir $OUTDIR \
cwl/hi-c-processing-pairs-merge-frag.cwl \
cwl-test-run-eco-yml/hi-c-processing-pairs-merge-frag-run.yml \
&> ${LOG}/run_hi-c-processing-pairs-merge-frag.cwl.log
echo "# End   test run $i merge pairs & add frag [new mode]:  "`date`

# 7. Generate .hic/.mcool using fragment/MAPQ filtered pairs
i=`expr $i + 1`
OUTDIR=../results/4dn_new_hic_mcool_filter_pairs
mkdir -p $OUTDIR

$cwl_runner --outdir $OUTDIR \
cwl/hi-c-processing-single-pairs-to-mat-new.cwl \
cwl-test-run-eco-yml/hi-c-processing-single-pairs-to-mat-new-run.yml \
&> ${LOG}/run_hi-c-processing-single-pairs-to-mat-new.cwl.log
echo "# End   test run $i   pairs to mat [new mode]:          "`date`

# 8. Pairs stats
i=`expr $i + 1`
OUTDIR=../results/4dn_new_pairsstats
mkdir -p ${OUTDIR}

$cwl_runner --outdir $OUTDIR \
cwl/pairs-stats-multi.cwl \
cwl-test-run-eco-yml/pairs-stats-multi-run.yml \
&> ${LOG}/run_pairs-stats-multi.cwl.log
echo "# End   test run $i   pairs stat [new mode]:            "`date`


# 9. Plot scaling
i=`expr $i + 1`
OUTDIR=../results/plot_cis_scaling_pairs
mkdir -p ${OUTDIR}

$cwl_runner --outdir $OUTDIR \
cwl/plot-cis-scaling.cwl \
cwl-test-run-eco-yml/plot-cis-scaling-run.yml \
&> ${LOG}/run_plot-cis-scaling.cwl.log
echo "# End   test run $i   plot cis-scaling from pairs:      "`date`

#
#conda deactivate
#

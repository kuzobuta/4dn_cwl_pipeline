#!/bin/bash
# Test run of cwl 4dn hi-c pipeline using singularity [default mode]
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

echo "# Start test run [4dn default mode]:                   "`date`
echo "# Test  run 1~5 using singularity"

#set run number
i=0

# 1. Mapping multiple fastq files
i=`expr $i + 1`
OUTDIR=../results/4dn_default_bam
mkdir -p ${OUTDIR}

$cwl_runner --outdir $OUTDIR \
cwl/bwa-mem-no-decomp-multi.cwl \
cwl-test-run-default-yml/bwa-mem-no-decomp-multi-run.yml \
&> ${LOG}/run_bwa-mem-no-decomp-multi.cwl.log
echo "# End   test run $i   mapping:                          "`date`


# 2-1. Bam to valid pairs SRR1658790 [4dn default]
i=`expr $i + 1`
OUTDIR=../results/4dn_default_validpairs_SRR1658790
mkdir -p ${OUTDIR}

$cwl_runner --outdir $OUTDIR \
cwl/hi-c-processing-bam.cwl \
cwl-test-run-default-yml/hi-c-processing-bam-run-SRR1658790.yml \
&> ${LOG}/run_hi-c-processing-bam.cwl_SRR1658790.log
echo "# End   test run $i-1 bam to validpairs [default]:      "`date`


# 2-2. Bam to valid pairs SRR1658794 [4dn default]
OUTDIR=../results/4dn_default_validpairs_SRR1658793
mkdir -p ${OUTDIR}

$cwl_runner --outdir $OUTDIR \
cwl/hi-c-processing-bam.cwl \
cwl-test-run-default-yml/hi-c-processing-bam-run-SRR1658793.yml \
&> ${LOG}/run_hi-c-processing-bam.cwl_SRR1658793.log
echo "# End   test run $i-2 bam to validpairs [default]:      "`date`


# 3. Merge filtered pairs & generate .hic / .mcool [4dn default]
i=`expr $i + 1`
OUTDIR=../results/4dn_default_hic_mcool
mkdir -p ${OUTDIR}

$cwl_runner --outdir $OUTDIR \
cwl/hi-c-processing-pairs.cwl \
cwl-test-run-default-yml/hi-c-processing-pairs-run.yml \
&> ${LOG}/run_hi-c-processing-pairs.cwl.log
echo "# End   test run $i   validpairs to hic mat [default]:  "`date`


# 4-1. BamQC SRR1658790 [4dn default]
i=`expr $i + 1`
OUTDIR=../results/4dn_bamqc_SRR1658790
mkdir -p ${OUTDIR}

$cwl_runner --outdir $OUTDIR \
cwl/bamqc.cwl \
cwl-test-run-default-yml/bamqc-run-SRR1658790.yml \
&> ${LOG}/run_bamqc.cwl_SRR1658790.log
echo "# End   test run $i-1 bamqc :                           "`date`


# 4-2. BamQC SRR1658793 [4dn default]
OUTDIR=../results/4dn_bamqc_SRR1658793
mkdir -p ${OUTDIR}

$cwl_runner --outdir $OUTDIR \
cwl/bamqc.cwl \
cwl-test-run-default-yml/bamqc-run-SRR1658793.yml \
&> ${LOG}/run_bamqc.cwl_SRR1658793.log
echo "# End   test run $i-2 bamqc :                           "`date`


# 5-1. RE-check SRR1658790 [4dn default]
i=`expr $i + 1`
OUTDIR=../results/4dn_RE-checker_SRR1658790
mkdir -p ${OUTDIR}

$cwl_runner --outdir $OUTDIR \
cwl/RE-checker.cwl \
cwl-test-run-default-yml/RE-checker-run-SRR1658790.yml \
&> ${LOG}/run_RE-checker_SRR1658790.log
echo "# End   test run $i-1 RE-checker :                      "`date`


# 5-2. RE-check SRR1658793 [4dn default]
OUTDIR=../results/4dn_RE-checker_SRR1658793
mkdir -p ${OUTDIR}

$cwl_runner --outdir $OUTDIR \
cwl/RE-checker.cwl \
cwl-test-run-default-yml/RE-checker-run-SRR1658793.yml \
&> ${LOG}/run_RE-checker_SRR1658793.log
echo "# End   test run $i-2 RE-checker :                      "`date`

# 6. PairsQC [4dn default]
OUTDIR=../results/4dn_pairsqc
mkdir -p ${OUTDIR}

$cwl_runner --outdir $OUTDIR \
cwl/pairsqc-single.cwl \
cwl-test-run-default-yml/pairsqc-single-run.yml \
&> ${LOG}/run_pairsqc-single.cwl.log
echo "# End   test run $i   PairsQC :                         "`date`

#
#conda deactivate
#

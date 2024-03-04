#!/bin/bash
#Plot cis-scaling from pairs file
#v240228, pairtools v1.0.3

PAIRS=$1
OUTPREFIX=$2

if [[ -z "${OUTPREFIX}" ]]; then
    OUTPREFIX='out'
fi

pairtools scaling \
-o ${OUTPREFIX}_cis_scalings-trans_levels.txt \
${PAIRS}

python /usr/local/bin/plot_scaling_from_txt.py ${OUTPREFIX}_cis_scalings-trans_levels.txt ${OUTPREFIX}


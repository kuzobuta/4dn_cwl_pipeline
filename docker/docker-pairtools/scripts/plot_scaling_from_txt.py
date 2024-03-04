#!/usr/bin/local python
'''
This plotting script was imprimented from "Pairtools: restriction workthrough",
using output file from "pairtools scaling".

URL: https://pairtools.readthedocs.io/en/latest/examples/pairtools_restrict_walkthrough.html
v240229, pairtools v1.0.3
'''

import warnings
warnings.filterwarnings("ignore")

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker
import matplotlib.gridspec
import pandas as pd
import pairtools
import bioframe

from pairtools.lib import headerops, fileio
import pairtools.lib.scaling as scaling

import sys

##default##

file = sys.argv[1]
outprefix = ''

if len(sys.argv) > 2:
    outprefix=sys.argv[2]

df = pd.read_csv(file, index_col=0, sep='\t')
chrom1 = df['chrom1']
chrom2 = df['chrom2']
df_cis = df[chrom1 == chrom2]

cis_scalings = df_cis
strand_gb = cis_scalings.groupby(['strand1', 'strand2'])

label='pairs'
xlim=(1e1,1e9)

for strands in ['+-', '-+', '++', '--']:
    sc_strand = strand_gb.get_group(tuple(strands))
    sc_agg = (sc_strand
            .groupby(['min_dist','max_dist'])
            .agg({'n_pairs':'sum', 'n_bp2':'sum'})
            .reset_index())
    
    dist_bin_mids = np.sqrt(sc_agg.min_dist * sc_agg.max_dist)
    pair_frequencies = sc_agg.n_pairs / sc_agg.n_bp2
    pair_frequencies = pair_frequencies/cis_scalings.n_pairs.sum()
    mask = pair_frequencies>0
    label_long = f'{strands[0]}{strands[1]} {label}'
    if np.sum(mask)>0:
        plt.loglog(
    	    dist_bin_mids[mask],
            pair_frequencies[mask],
            label=label_long,
            lw=2
        )

plt.gca().xaxis.set_major_locator(matplotlib.ticker.LogLocator(base=10.0,numticks=20))
plt.gca().yaxis.set_major_locator(matplotlib.ticker.LogLocator(base=10.0,numticks=20))
plt.gca().set_aspect(1.0)
plt.xlim(xlim)
plt.grid(lw=0.5,color='gray')
plt.legend(loc=(1.1,0.4))
plt.ylabel('contact frequency, \nHi-C molecule per bp pair normalized by total cis-pairs')
plt.xlabel('distance, bp')
plt.tight_layout()

plt.savefig(outprefix + "_oriented_scalings.pdf")


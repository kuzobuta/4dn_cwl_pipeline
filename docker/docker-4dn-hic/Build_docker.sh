#!/bin/bash
#240708 New docker images
wget https://repo.anaconda.com/miniconda/Miniconda2-4.6.14-Linux-x86_64.sh
docker build -t kuzobuta/4dn-hic:v43.1 .
rm Miniconda2-4.6.14-Linux-x86_64.sh

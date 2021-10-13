#!/bin/sh

# Author: Billy
# Purpose: Create dlc-windowsGPU environemnt 


# source and activate base environment
source /data/$USER/conda/etc/profile.d/conda.sh
conda activate base
which python
conda update conda
conda clean --all --yes

# create new environment
conda env create -f works.yaml

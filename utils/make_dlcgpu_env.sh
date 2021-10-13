#!/bin/sh

# Author: Billy
# Purpose: Create conda environemnt for DLC

#source config file
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $SCRIPT_DIR/env.config

# source and activate base environment
source /data/$USER/conda/etc/profile.d/conda.sh
conda activate base
which python
conda update conda
conda clean --all --yes

# create new environment
conda env create -f $SCRIPT_DIR/$env_file

#!/bin/sh

# Author: Billy
# Purpose: Install miniconda to /data/$USER

# install miniconda in /data/$USER
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
mkdir -p /scratch/$USER/temp
TMPDIR=/scratch/$USER/temp bash Miniconda3-latest-Linux-x86_64.sh -p /data/$USER/conda -b
rm Miniconda3-latest-Linux-x86_64.sh

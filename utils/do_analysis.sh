#!/bin/sh

# Author: Billy
# Purpose: Run sam_video_analysis

# set working directory
#cd /data/$USER/motorator_analysis_package/

# establish environment for analysis
source /data/$USER/conda/etc/profile.d/conda.sh
conda activate base
conda activate DEEPLABCUT
#module load deeplabcut/2.1.8.2
#module load cuDNN/7.0/CUDA-9.0 CUDA/9.0 python/3.6

video_path="/data/$USER/to_analyze"
printf "This is your video path: $video_path \n" 

## call sam_video_analysis.py and billy helper.py
python sam_video_analysis.py $video_path  
python billy_helper.py $video_path

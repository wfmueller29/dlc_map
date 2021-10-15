#!/bin/sh

# Author: Billy
# Purpose: Run sam_video_analysis

#Source config file 
source $SCRIPT_DIR/env.config

# establish environment for analysis
source /data/$USER/conda/etc/profile.d/conda.sh
conda activate base
conda activate $env_name
#module load deeplabcut/2.1.8.2
#module load cuDNN/7.0/CUDA-9.0 CUDA/9.0 python/3.6

video_path=$vid_path
printf "This is your video path: $video_path \n" 

## call sam_video_analysis.py and billy helper.py
python $pro_path/sam_video_analysis.py $video_path  
python $pro_path/billy_helper.py $video_path

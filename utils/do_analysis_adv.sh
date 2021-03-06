#!/bin/sh

# Author: Billy
# Purpose: Run sam_video_analysis

# source config
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $SCRIPT_DIR/env.config

# establish environment for analysis
source /data/$USER/conda/etc/profile.d/conda.sh
conda activate base
conda activate $env_name
#module load cuDNN/7.0/CUDA-9.0 CUDA/9.0 R/3.5.0 python/3.5
#module load deeplabcut

# determine where videos to analyze are located
printf "
\n##############################\n
	USER INPUT NEEDED
\n##############################\n
Are videos stored in \"$vid_path\"?
(Y/N):"
read y_n
y_n=${y_n,,}
if [ $y_n == n ]
then
printf " 
\n##############################\n
	USER INPUT NEEDED
\n##############################\n
-Enter Video Path (the directory containing 
 the videos needed to be analyzed)
-Enter Video Path using \"/\" to separate directories
-For example \"/data/$USER/testing_folder/to_analyze\"
\n##############################\n
Please Enter Video Path:"
read video_path
else
video_path=$vid_path
fi
printf "This is your video path: $video_path \n" 

## call sam_video_analysis.py and billy helper.py
python sam_video_analysis.py $video_path  
python billy_helper.py $video_path

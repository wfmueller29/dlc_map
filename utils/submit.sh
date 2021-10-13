#!/bin/bash
sbatch --partition=gpu --gres=gpu:p100:1 --time=16:00:00 --mail-type=END --error=/data/$USER/motorator_analysis_package/log/ --output=/data/$USER/motorator_analysis_package/log/ /data/$USER/motorator_analysis_package/utils/do_analysis.sh

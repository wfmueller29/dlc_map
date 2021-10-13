#!/bin/bash

#source env.config
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $SCRIPT_DIR/env.config

#submit batch
sbatch --partition=gpu --gres=gpu:p100:1 --time=16:00:00 --mail-type=END --error=$pro_path/log/ --output=$pro_path/log/ $pro_path/utils/do_analysis.sh

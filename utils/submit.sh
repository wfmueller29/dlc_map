#!/bin/bash

#source env.config
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $SCRIPT_DIR/env.config

## get date
DATE=$(date +"%Y%m%d%H%M")

## make output and error names
OUTPUT=$pro_path/log/"$DATE"_output.out
ERR=$pro_path/log/"$DATE"_err.out

echo "Submitting job now ..."
echo "Output path: $OUTPUT"
echo "Err path: $ERR"
echo "Export script direcotory: $SCRIPT_DIR"

#submit batch
sbatch -p gpu --mem=10G --gres=gpu:p100:1 -t 24:00:00 --mail-type=END -o $OUTPUT -e $ERR --export=SCRIPT_DIR=$SCRIPT_DIR $pro_path/utils/do_analysis.sh

echo "Job sucessfully submitted!"

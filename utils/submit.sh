#!/bin/bash
sbatch --partition=gpu --gres=gpu:p100:1 --time=16:00:00 --mail-type=END

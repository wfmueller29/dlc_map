#!/bin/bash
echo $PWD
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo $SCRIPT_DIR

source $SCRIPT_DIR/env.config

echo $env_name
echo $env_file
echo $pro_path
echo $vid_path
echo $con_path
sed -i '/project_path:/s,.*,project_path: '"$pro_path"',' "$con_path"


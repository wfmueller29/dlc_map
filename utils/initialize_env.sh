#!/bin/sh

# Author: Billy
# Purpose: Set up everything for doing motorator video analysis
# Notes: keep in motorator_analysis_package directory
# Step 1: Install miniconda 
# Step 2: Set up dlc conda environment 
# Step 3: Make sure motorator_analysis package is in /data/$USER/
# Step 4: Create to_analyze and analyzed_csv directories in /data/$USER/
# Step 5: Make sure config.yaml file has correct project path

# source config file
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $SCRIPT_DIR/env.config

# Start initializer
printf "
-----------------------------------
          5 step check
-----------------------------------
# Step 1: Install miniconda 
# Step 2: Set up $env_name 
# Step 3: Make sure motorator_analysis package is in /data/$USER/
# Step 4: Create to_analyze and analyzed_csv directories in /data/$USER/
# Step 5: Make sure config.yaml file has correct project path
-----------------------------------
Running these 5 checks now...........

"
# Step 1
if [[ -d "/data/$USER/conda" ]]
then
	echo "1. miniconda is installed!!"
else
	echo "miniconda is not installed, we are installing now..." 
	bash $SCRIPT_DIR/install_conda.sh
	if [[ -d "/data/$USER/conda" ]]
	then
		echo "1. miniconda is installed!!"
	else
		printf "miniconda installation failed...quitting initializer"
		exit
	fi
fi

# Step 2
source /data/$USER/conda/etc/profile.d/conda.sh
conda activate base
ENVS=$(conda env list | awk '{print $1}')
if [[ $ENVS = *$env_name* ]]
then
	echo "2. The environemnt $env_name exists!!"
else
	echo "The environment $env_name does not exist, installing now..."
	bash $SCRIPT_DIR/make_dlcgpu_env.sh
	ENVS=$(conda env list | awk '{print $1}')
	if [[ $ENVS = *$env_name* ]]
	then
		echo "2. The environement $env_name exists!!"
	else 
		echo "could not establish $env_name environment...quitting initializer"
		exit
	fi
fi

# Step 3 check if motorator_analysis_package is in correct location, 
# if not ask if user would like to move it to proper location
if [[ -d "$pro_path" ]]
then 
	echo "3. motorator_analysis_package is in correct location!"
else
	printf "
#############################################
motorator_analysis_package is in wrong location :(
#############################################
Correct path: $pro_path

Current path(s): 

	"
	mpath1=$(find /data/$USER/ -name "*$pack_name*")
	mpath2=$(find /home/$USER/ -name "*$pack_name*")
	echo $mpath1 
	echo $mpath2
	printf "
(If more than one path listed, there are multiple copies of the package)
(If no paths listed, there are no copies of package)

Please move motorator_analysis_package to the correct location...quitting initializer
"
	exit
fi

# Step 4

if [ -d "$vid_path" ]
then 
	echo "4a. $vid_path exists!"
else
	mkdir -p $vid_path
	echo "4a. $vid_path has been created!!"
fi


if [ -d "$res_path" ]
then 
	echo "4a. $res_path exists!"
else
	mkdir -p $res_path 
	echo "4a. $res_path has been created!!"
fi

# Step 5 
if grep -q "project_path: $pro_path" "$pro_path/config.yaml"
then
  echo "5. config.yaml project path is correct!!"
else
  echo "project path incorrect, changing to correct path now...."
  sed -i '/project_path:/s,.*,project_path: '"$pro_path"',' "$con_path"
  if grep -q "project_path: $pro_path" "$con_path"
  then
    echo "5. config.yaml project path is correct!!"
  else
    printf "
    ERROR: Config project path is incorrect. Please make sure that the project_path in config.yaml is the current path to the config.yaml file
    "
    exit
  fi
fi

printf "
-----------------------------------
Enivronment is initialized!
-----------------------------------
"


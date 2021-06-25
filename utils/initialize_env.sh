#!/bin/sh

# Author: Billy
# Purpose: Set up everything for doing motorator video analysis
# Notes: keep in motorator_analysis_package directory
# Step 1: Install miniconda 
# Step 2: Set up dlc-windowsGPU 
# Step 3: Make sure motorator_analysis package is in /data/$USER/
# Step 4: Create to_analyze and analyzed_csv directories in /data/$USER/
# Step 5: Make sure config.yaml file has correct project path

printf "
-----------------------------------
          5 step check
-----------------------------------
# Step 1: Install miniconda 
# Step 2: Set up dlc-windowsGPU 
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
	bash install_conda.sh
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
if [[ $ENVS = *"dlc-windowsGPU"* ]]
then
	echo "2. The environemnt dlc-windowsGPU exists!!"
else
	echo "The environment dlc-windowsGPU does not exist, installing now..."
	bash make_dlcgpu_env.sh
	ENVS=$(conda env list | awk '{print $1}')
	if [[ $ENVS = *"dlc-windowsGPU"* ]]
	then
		echo "2. The environement dlc-windowsGPU exists!!"
	else 
		echo "could not establish dlc-windowsGPU environment...quitting initializer"
		exit
	fi
fi

# Step 3 check if motorator_analysis_package is in correct location, 
# if not ask if user would like to move it to proper location
if [[ -d "/data/$USER/motorator_analysis_package" ]]
then 
	echo "3. motorator_analysis_package is in correct location!"
else
	printf "
#############################################
motorator_analysis_package is in wrong location :(
#############################################
Correct path: /data/$USER/motorator_analysis_package

Current path(s): 

	"
	mpath1=$(find /data/$USER/ -name "*motorator_analysis_package*")
	mpath2=$(find /home/$USER/ -name "*motorator_analysis_package*")
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

if [ -d "/data/$USER/to_analyze" ]
then 
	echo "4a. /data/$USER/to_analyze exists!"
else
	mkdir -p /data/$USER/to_analyze
	echo "4a. /data/$USER/to_analyze has been created!!"
fi


if [ -d "/data/$USER/analyzed_csv" ]
then 
	echo "4a. /data/$USER/analyzed_csv exists!"
else
	mkdir -p /data/$USER/analyzed_csv
	echo "4a. /data/$USER/analyzed_csv has been created!!"
fi

# Step 5 
if grep -q "project_path: /data/$USER/motorator_analysis_package" "/data/$USER/motorator_analysis_package/config.yaml"
then
  echo "5. config.yaml project path is correct!!"
else
  sed -i "/project_path:/s/.*/project_path: \/data\/$USER\/motorator_analysis_package\//" /data/$USER/motorator_analysis_package/config.yaml 
  if grep -q "project_path: /data/$USER/motorator_analysis_package/" "/data/$USER/motorator_analysis_package/config.yaml"
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
You are ready to use: \"bash utils/do_analysis.sh\"! (Without Quotes)
-----------------------------------
"


#!/bin/bash

# Script used to test command for bash scripts

echo "$PWD"
full_path=$(realpath $0)
echo $full_path

dir_path=$(dirname $full_path)
echo $dir_path

dirdir_path=$(dirname $dir_path)
echo $dirdir_path

video_path="/data/$USER/to_analyze"
echo $video_path

if [[ -d "/data/$USER/motorator_analysis_package" ]]
	then 
	echo "motorator_analysis_package is in correct location!"
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

Please move motorator_analysis_package to the correct location and retry initialize_env.sh
"
exit
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
#######################
Enivronment is initialized!
You are ready to use: \"bash utils/do_analysis.sh\"! (Without Quotes)
#######################
"

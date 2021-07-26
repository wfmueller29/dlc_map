# dlc_gait_pkg
## Purpose: Make deeplabcut gait analysis on biowulf as streamlined and straightforward as possible. 
### Author: Billy Mueller, Sam Lee, John Nam

## Brief Protocol 
1. copy this entire folder into `/data/$USER/` and make sure the name of the folder is `motorator_analysis_package`.
2. type `bash /data/$USER/motorator_analysis_package/utils/initialize_env.sh` into terminal and press `[enter]`.
3. copy videos that we want analyzed into `/data/$USER/to_analyze` folder using globus.
4. tpye `sinteractive --gres=gpu:p100:1,lscratch:10 --mem=40g` <copy-button></copy-button> and press `[enter]`
5. type `bash /data/$USER/motorator_analysis_package/utils/do_analysis.sh` into the terminal and press `[enter]`.
6. you will find results in `/data/$USER/to_analyze` folder


## Extended Protocol 
1. copy this entire folder into `/data/$USER/` and make sure the name of the folder is `motorator_analysis_package`.
    1. This is crucial as all of the directories in the shell scripts work under this assumption. 
    2. `$USER` a variable in linux that will change from user to user 
2. type `bash /data/$USER/motorator_analysis_package/utils/initialize_env.sh` into terminal and press `[enter]`.
    1. This is going to initialize the environment doing 5 steps
        1. install miniconda to `/data/$USER/`
        2. use conda to create an environment dlc-windowsGPU from `dlc_windowsGPU.yaml`
        3. check that the motorator_analysis_package is in correct location. So full path is: `/data/$USER/motorator_analysis_package`
        4. create folders `/data/$USER/to_analyze` and `/data/$USER/analyzed_csv`
        5. make sure that the project_path in config.yaml file is correct
3. copy videos that we want analyzed into `/data/$USER/to_analyze` folder using globus.
     1.  Globus is a file transfer software that 
4. type `bash /data/$USER/motorator_analysis_package/utils/do_analysis.sh` into the terminal and press `[enter]`.
5. you will find results in `/data/$USER/to_analyze` folder



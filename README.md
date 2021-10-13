# dcl_map (DeepLabCut Motorator Analaysis Package)
## Purpose: Make deeplabcut gait analysis on biowulf as streamlined and straightforward as possible. 
### Author: Billy Mueller, Sam Lee, John Nam

## Brief Protocol 
### Step 1: Installation of dlc_map
1. login to Biowulf
2. Copy and paste these commands into terminal
```
cd /data/$USER
```
```
git clone https://github.com/wfmueller29/dlc_map.git
```
```
bash /data/$USER/dlc_map/utils/initialize_env.sh
```
### Step 2: Analysis
1. transfer decoded videos that we want analyzed into `/data/$USER/to_analyze` folder using globus.
2. copy and paste this command into biowulf terminal and press enter
```
bash /data/$USER/dlc_map/utils/submit.sh
```
3. you will find results in `/data/$USER/analyzed_csv` folder


## Extended Protocol 
1. copy this entire folder into `/data/$USER/` and make sure the name of the folder is `dlc_map`.
    1. This is crucial as all of the directories in the shell scripts work under this assumption. 
    2. `$USER` a variable in linux that will change from user to user 
2. type `bash /data/$USER/dlc_map/utils/initialize_env.sh` into terminal and press `[enter]`.
    1. This is going to initialize the environment doing 5 steps
        1. install miniconda to `/data/$USER/`
        2. use conda to create an environment dlc-windowsGPU from `dlc_windowsGPU.yaml`
        3. check that the dlc_map is in correct location. So full path is: `/data/$USER/dlc_map`
        4. create folders `/data/$USER/to_analyze` and `/data/$USER/analyzed_csv`
        5. make sure that the project_path in config.yaml file is correct
3. copy videos that we want analyzed into `/data/$USER/to_analyze` folder using globus.
     1.  Globus is a file transfer software that 
4. type `bash /data/$USER/dlc_map/utils/do_analysis.sh` into the terminal and press `[enter]`.
5. you will find results in `/data/$USER/to_analyze` folder

## Notes
- Make sure that the videos have the proper codec. This is different from their file extension. For example, an .avi video could be code via one codec while another video could be coded via another codec. Make sure to be using the videos from the decoded videos folder when analyzing.

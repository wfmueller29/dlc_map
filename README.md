# dcl_map (DeepLabCut Motorator Analaysis Package)

Purpose: Make deeplabcut gait analysis on biowulf as streamlined and straightforward as possible. \
Authors: Billy Mueller, Sam Lee, John Nam

## Protocol 
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


## Notes
- Make sure that the videos have the proper codec. This is different from their file extension. For example, an .avi video could be code via one codec while another video could be coded via another codec. Make sure to be using the videos from the decoded videos folder when analyzing.

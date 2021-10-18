# dcl_map (DeepLabCut Motorator Analaysis Package)


Authors: Billy Mueller, Sam Lee, John Nam 

## Table of Contents
[Purpose](#purpose) \
[Prerequisites](#prerequisites) \
[Protocol](#protocol) \
[Notes and Troubleshooting](#notes-and-troubleshooting)

## Purpose 
dlc_map was created to make the motorator gait analysis pipeline as accessible and streamlined as possible. The hope was that someone with no expereince using supercomputers, linux, conda, python, and bash would be able to use this package by following the protocols listed and successfully analyze motorator videos. However, in order to troubleshoot issues with this package, knowledge of these tools is essential. I have included a table outlining the softwares that you will need to be familiar with in order to (1) use this package and (2) troubleshoot the package. \
\
In addition, this README has a Brief Protocol and an Extended Protocol. You can use the [Brief Protocol](#brief-protocol) if you have a biowulf account and are familiar with using globus. However, if you are not familiar with biowulf or globus, or would like to learn more about the analysis, use the [Extended Protocol](#extended-protocol).

## Prerequisites 
| Software | To Use | To Troubleshoot | Description | Documentation |
|---|---|---|---|---|
| Biowulf | X | X | NIH's supercomputer. Allows us to analyze the videos remotely and using a GPU, which does the analysis much faster | [Biowulf](https://hpc.nih.gov/systems/) |
| Globus | X | X | This is the file transfer that we will use to transfer the videos from `M:\Gait_Analysis\decoded_MOTORATER` to `/data/$USER/to_analyze` direcotry on biowulf | [Globus Biowulf Docs](https://hpc.nih.gov/storage/globus.html) [Globus Docs](https://docs.globus.org/how-to/) | 
| Linux | | X | This is the operating system of Biowulf. You will have to be familiar with common Linux Commands and using the terminal to troubleshoot the package | [Linux Docs](https://linux.die.net/man/) Note: I usually just google stuff |
| Conda | | X | This is a environment manager for python. In order to run DeepLabCut (the software we use to analyze the videos), we are required to create a stable environment. This means that the verisions of the python packages required for our script to run must not be conflicting. Conda helps create and save environments for this purpose | [Conda Docs](https://docs.conda.io/en/latest/miniconda.html) |
| Python | | X | This is the programming language used to build DeepLabCut. Also it is what the script used to implement DeepLabCut was written in `sam_video_analysis.py` | [Python Docs](https://docs.python.org/3/) these docs may be less helpful, again just google stuff |
| DeepLabCut | | X | This is the python package that is used to analyze the videos. | [DeepLabCut docs](https://github.com/DeepLabCut/DeepLabCut)
| Bash | | X | This is the shell scripting language used to streamline the analysis process. | [Bash docs](https://www.gnu.org/software/bash/manual/bash.html) |

## Protocol
### Step 1: Biowulf Setup and Installation of dlc_map
1. Create Biowulf Account (if you do not already have one). If you do not have a Biowulf Account, heres is the link to the docs: [Biowulf Get An Account](https://hpc.nih.gov/docs/accounts.html)
2. Login to Biowulf. Docs: [Connecting to Biowulf](https://hpc.nih.gov/docs/connect.html)
3. Once logged in, copy and paste these commands into terminal (in order!), to install the dlc_map package.
```
cd /data/$USER
```
```
git clone https://github.com/wfmueller29/dlc_map.git
```
Now dlc_map should be downloaded into the `/data/$USER` folder. Here `$USER` is a linux environment variable that gives the name of the user. So if your username is johnsmith, dlc_map should be in `/data/johnsmith/`
* Note once we have created a biowulf account and installed dlc_map, we will not have to do these steps again. 
* However, we will have to login into Biowulf everytime we want to do analyze videos.
### Step 2: Initialize Analysis Environemnt
1. Copy and paste this command into terminal
```
bash /data/$USER/dlc_map/utils/initialize_env.sh
```
This command will accomplish the following:  
1. Check if miniconda is installed, and if it is not, it will instlal it.
2. Set up the conda environment needed to run DeepLabCut.
3. Make sure that dlc_map is in the /data/$USER directory
4. Create to_analyze and analyzed_csv directories
5. Make sure the config.yaml file has correct path.

### Step 3: Transfer Videos via Globus
1. See [Globus Docs](https://docs.globus.org/how-to/) on how to configure and use globus.
2. Be sure to transfer __decoded__ videos to the `/data/$USER/to_analyze` directory. The decoded videos can be found here: `M:\Gait_Analysis\decoded_MOTORATER`. 

Notes:
* When a globus transfer is in progress, we need to be connected to the Network and your computer must be on. However, we can remove our PIV card.


### Step 4: Do Analysis
1. Copy and paste this commnad into terminal
```
bash /data/$USER/dlc_map/utils/submit.sh
```
the `submit.sh` script will call the `do_analysis.sh` script as an sbatch command (ie. a job to submitted to biowulf). This `do_analysis.sh` script will do the following:
1. source conda
2. activate the deeplabcut conda environment
3. call `sam_video_analysis.py`
4. call `billy_helper.py`
Biowulf will send you an email when the job has been completed. Following this email proceed to step 5.

Notes:
* Once the job is submitted to biowulf, we are free to logout of biowulf and turn off our computer. 
* I would recommmend analyzing 3 TB at one time because of the Wall time limit. The max wall time is 24 hours, and it takes roughloy 14 hours to do 3 TB. 

### Step 5: Transfer Results
1. You can find the results of the Step 4 analysis in the `/data/$USER/analyzed_csv` directory
2. Please Transfer the entire directory structure from `/data/$USER/analyzed_csv` to `M:\Gait_Analysis\analyzed_csv`

### Step 6: Repeat Steps 3-5
1. Now that all the videos in `/data/$USER/to_analyze` have been processed, we need to delete the videos in this directory to make space for more videos.
2. We can now repeat Steps 3-5.


## Notes and Troubleshooting
- Make sure that the videos have the proper codec. This is different from their file extension. For example, an .avi video could be code via one codec while another video could be coded via another codec. Make sure to be using the videos from the decoded videos folder when analyzing.


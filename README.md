# dcl_map (DeepLabCut Motorator Analaysis Package)


Authors: Billy Mueller, Sam Lee, John Nam \
\
Purpose: dlc_map was created to make the motorator gait analysis pipeline as accessible and streamline as possible. The hope was that someone with no expereince using supercomputers, linux, conda, python, and bash would be able to use this package by following the protocols listed and successfully analyze motorator videos. However, in order to troubleshoot issues with this package, knowledge of these tools is essential. I have included a table outlining the softwares that you will need to be familiar with in order to use this package and troubleshoot the package. This README is has a Brief Protocol and an Extended Protocol. \
\
Prerequisites: 
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
### Step 1: Installation of dlc_map
1. login to Biowulf
2. Copy and paste these commands into terminal (in order!)
```
cd /data/$USER
```
```
git clone https://github.com/wfmueller29/dlc_map.git
```
### Step 2: Initialize Environment
1. Copy and paste this command into terminal
```
bash /data/$USER/dlc_map/utils/initialize_env.sh
```
### Step 3: Analysis
1. transfer decoded videos that we want analyzed into `/data/$USER/to_analyze` folder using globus.
2. copy and paste this command into biowulf terminal and press enter
```
bash /data/$USER/dlc_map/utils/submit.sh
```
3. you will find results in `/data/$USER/analyzed_csv` folder


## Notes/Troubleshooting
- Make sure that the videos have the proper codec. This is different from their file extension. For example, an .avi video could be code via one codec while another video could be coded via another codec. Make sure to be using the videos from the decoded videos folder when analyzing.

## Extended Protocol
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
### Step2: Initialize Analysis Environemnt
1. Copy and paste this command into terminal
```
bash /data/$USER/dlc_map/utils/initialize_env.sh
```


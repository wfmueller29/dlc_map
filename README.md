# dlc_gait_pkg
Repository for the motorator_analysis_package so that changes made on biowulf can be transferred to local PC

This is a package that allows for installation and use of sam_video_analysis.py

- THis package should be installed in /data/$USER/ on biowulf
- once that package is there type "bash /data/$USER/motorator_analysis_package/utils/initialize_env.sh" into the terminal on biowulf (do not type quotes)
  - This is going to initialize the environment doing 5 steps
    1. install miniconda to /data/$USER/
    2. use conda to create an environment dlc-windowsGPU
    3. check that the motorator_analysis_package is in correct location 
    4. create folders to_analyze and analyzed_csv
    5. make sure that the project_path in config.yaml file is correct
- next we can use globus to copy videos from M: drive to the to_analyze folder
- once there all we have to do is type "bash /data/$USER/motorator_analysis_package/utils/do_analysis.sh" into the terminal

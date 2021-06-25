# -*- coding: utf-8 -*-
"""
Created on Tue Jun 22 12:24:20 2021

@author: muellerwf
"""
import os
import sys
import shutil


### Functiont that recursively copies all files with suffix in a directory while maintain subdirectory structure
def copybranch(source, dest, suffix):
## Get files that end with suffix
    files = []
    for r, d, f in os.walk(source):
        for file in f:
            if file.endswith(suffix):
                files.append(os.path.join(r, file))

## Create destination directory 
    if not os.path.isdir(dest):
        os.mkdir(dest)

## get separate source path (root) from path after source (branch) and replace root with destination path
    for file in files:
        root = file
        branch = []
        while root != source:
            file_split = (os.path.split(root))
            root = (file_split[0])
            branch.insert(0, file_split[1])
            newpath = None
            for d in branch[:-1]: #loop checks if directories in branch exist, if not, it makes the directory
                if newpath is None:
                    newpath = os.path.join(dest,d)
                else:
                    newpath = os.path.join(newpath, d)
                if not os.path.isdir(newpath):
                    os.mkdir(newpath)
    shutil.copy(file, newpath)
    
#If given argument, use that as directory for mouse videos. Otherwise, look for
#videos in current directory
if(len(sys.argv) > 1):
    video_folder = sys.argv[1]
else:
    print("billy_helper could not run....Valid Video Path is needed")
    quit()

#Call copy branch to move results from to_analyze to analyzed_csv  
output_path = os.path.join(os.path.dirname(video_folder), "analyzed_csv")
copybranch(source = video_folder, dest = output_path, suffix = "analyzed.csv")

print(f"video folder: {video_folder}")
print(f"output path: {output_path}")

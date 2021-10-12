# -*- coding: utf-8 -*-
"""
Created on Mon Oct  7 18:31:12 2019

@author: seung & billy 
"""
######################################################################
#Control variables
analyze_videos = True
######################################################################
import deeplabcut
import os
import sys
import csv
import numpy as np


##Function to retrive videos in a given folder
def retrieve_videos(vid_folder = 'none', debug = True):
    videos = []
    if (vid_folder != 'none') & debug:
        print('Files in current directory : ', os.listdir(vid_folder))
   
## finds all videos within a directory. searches recursively through subdirectories 
# r=root, d=directories, f = files
    for r, d, f in os.walk(vid_folder):
        for file in f:
            if '.avi' in file:
                videos.append(os.path.join(r, file))
    
    return videos



##Function to retrieve data from analyzing videos in list 'videos' with data 
##file endings of h5. Currently does not work properly
def read_data_from_csv(videos, data_ending):
    data = []
    for video in videos:
        filename = data_ending
        with open(filename, 'r') as fp:
            reader = csv.reader(fp, delimiter=',', quotechar='"')
            # next(reader, None)  # skip the headers
            data_read = [row for row in reader]
            data.append(data_read)
    return data

##Class to store data about a single mouse body part from a single video
class MousePart:
    def __init__(self, x, y, likelihood):
        self.x = x
        self.y = y
        self.likelihood = likelihood
    
    ##Removes all but selected indices of values
    def cut(self, start_index, end_index):
        self.x = self.x[start_index:end_index]
        self.y = self.y[start_index:end_index]
        self.likelihood = self.likelihood[start_index:end_index]
        return self
    
    ##Replaces x and y values of the frames with likelihood less than the cutoff
    ##with average x and y around it.
    def fill(self, cutoff = .9):
        counter = 0
        first_over_cutoff = self.likelihood[counter]>cutoff
        while (counter < len(self.x) & (not first_over_cutoff)):
            counter += 1
            if self.likelihood[counter]> cutoff:
                first_over_cutoff = True
        last_over_cutoff = counter
        while counter < len(self.x)-1:
            counter += 1
            if self.likelihood[counter]> cutoff:
                if last_over_cutoff < counter -1:
                    step_x = (self.x[counter]-self.x[last_over_cutoff])/ (counter - last_over_cutoff)
                    step_y = (self.y[counter]-self.y[last_over_cutoff])/ (counter - last_over_cutoff)
                    
                    last_over_cutoff += 1
                    while last_over_cutoff < counter:
                        self.x[last_over_cutoff] =self.x[last_over_cutoff-1] + step_x
                        self.y[last_over_cutoff] =self.y[last_over_cutoff-1] + step_y  
                        last_over_cutoff += 1
                else:
                    last_over_cutoff = counter
    ##Rescales from pixels to meters    
    def rescale(self, pixels = 648, meters = 0.30):
        self.x = meters *self.x/pixels
        self.y = meters *self.y/pixels
        
    
    
##Class to store data from a single mouse video
class MouseData:
    def __init__(self, data):
        self.part_list = list(set(data[1]))
        self.part_list.remove('bodyparts')
        self.part = {}
        self.frames = np.array(data[3:]).astype(float)[:, 0]
        
        data_array = np.array(data[3:]).astype(float)
        for p in self.part_list:
            p_i = data[1].index(p)
            self.part[p] = MousePart(data_array[:, p_i], 
                     data_array[:, p_i + 1], data_array[:, p_i + 2])
            
    def cut(self, start_index, end_index):
        for p in self.part_list:
            self.part[p] = self.part[p].cut(start_index, end_index)
        self.frames = self.frames[start_index: end_index]
        return self
    
    ##Filters start of the video (before the mouse comes on video)
    ##part_to_filter is what part to look at to filter and consecutive_cutoff
    ## is how many over cutoff consecutively is needed to pass the filter
    ##and cutoff is the cutoff for likelihood.
    def filter_start(self, part_to_filter = 'left_hind', cutoff = .9, consecutive_cutoff = 4):
        counter = 0
        c_part = self.part[part_to_filter]
        cons_counter = 0
        
        while counter < len(c_part.x):
            counter += 1
            if c_part.likelihood[counter]>cutoff:
                cons_counter += 1
            else:
                cons_counter = 0
            if cons_counter >= consecutive_cutoff:
                self.cut(counter - cons_counter + 1, len(c_part.x))
                break
        return counter

    ##Filters end of the video (after the mouse leaves)
    ##part_to_filter is what part to look at to filter and consecutive_cutoff
    ## is how many over cutoff consecutively is needed to pass the filter
    ##and cutoff is the cutoff for likelihood.
    def filter_end(self, part_to_filter = 'nose', cutoff = .9, consecutive_cutoff = 4):
        counter = 0
        c_part = self.part[part_to_filter]
        counter = len(c_part.x)
        cons_counter = 0
        
        while counter >= 0 :
            counter -= 1
            if c_part.likelihood[counter]>cutoff:
                cons_counter += 1
            else:
                cons_counter = 0
            if cons_counter >= consecutive_cutoff:
                self.cut(0, counter + cons_counter)
                break
        return counter
    
    def filter_all(self):
        self.filter_start(part_to_filter='left_hind')
        self.filter_start(part_to_filter='right_hind')
        self.filter_end()
        
    def fill(self, cutoff = 0.9):
        for p in self.part_list:
            self.part[p].fill(cutoff= 0.9)
    
    ##pixels = number of pixels per meters = number of meters
    def rescale(self, pixels = 648, meters = 0.30):
        for p in self.part_list:
            self.part[p].rescale(pixels, meters)

    

video_folder = 'none'

#If given argument, use that as directory for mouse videos. Otherwise, look for
#videos in current directory
if(len(sys.argv) > 1):
    video_folder = sys.argv[1]
else:
    print("sam_video_anlysis could not run...Valid Video Path is needed")
    quit()
    


### Commented this out, need to change config directory manually
##Overwriting the config file to match the current project directory
this_path = os.path.realpath(__file__)
config_path = this_path.replace('sam_video_analysis.py', 'config.yaml')
#project_path = this_path.replace('sam_video_analysis.py', '')
#config_file = open(config_path, 'r+')

#config_file.seek(142)
#config_file.write('project_path: ' + project_path + '\n')
#print(project_path)
#config_file.close()



#Getting all the videos in folder
videos = retrieve_videos(video_folder)

    
print("Videos found: ")
print(videos)

if analyze_videos:
    print("Analyzing videos")
    deeplabcut.analyze_videos(config_path, videos, videotype = 'avi', 
                              save_as_csv = True)


##Reading the analyzed data from h5 file
data = []
#data_ending = 'DeepCut_resnet50_motorater_inital_testJul26shuffle1_104000.csv'
data_ending = 'MR-20160405-AA7803-1DLC_resnet50_motorater_inital_testJul26shuffle1_104000.csv'
#data = read_data_from_csv(videos, data_ending)

mouse_data = []
for datum in data:
    mouse_data.append(MouseData(datum))
    
for i in range(len(mouse_data)):
    mouse_data[i].filter_all()
    mouse_data[i].fill()
    mouse_data[i].rescale()

formatted_mouse_data = []
parts_to_format = ['right_fore', 'left_fore', 'right_hind', 'left_hind']

for mouse_datum in mouse_data:
    formatted_mouse_datum = np.concatenate((np.array([['time']]), np.expand_dims(mouse_datum.frames/200, axis = 1)),axis = 0)
    for bodypart in parts_to_format:
        new_c = np.concatenate((np.array([[bodypart.replace('_', ' ') + '-bottom x']]), 
                                np.expand_dims(mouse_datum.part[bodypart].x, axis = 1)), axis = 0)
        formatted_mouse_datum = np.concatenate((formatted_mouse_datum, new_c), axis = 1)
        new_c = np.concatenate((np.array([[bodypart.replace('_', ' ') + '-bottom y']]), 
                                np.expand_dims(mouse_datum.part[bodypart].y, axis = 1)), axis = 0)
        formatted_mouse_datum = np.concatenate((formatted_mouse_datum, new_c), axis = 1)  
        new_c = np.concatenate((np.array([[bodypart.replace('_', ' ') + '-bottom v(x)']]), 
                                np.expand_dims(200*np.gradient(mouse_datum.part[bodypart].x), axis = 1)), axis = 0)
        formatted_mouse_datum = np.concatenate((formatted_mouse_datum, new_c), axis = 1)
        new_c = np.concatenate((np.array([[bodypart.replace('_', ' ') + '-bottom v(y)']]), 
                                np.expand_dims(200*np.gradient(mouse_datum.part[bodypart].y), axis = 1)), axis = 0)
        formatted_mouse_datum = np.concatenate((formatted_mouse_datum, new_c), axis = 1)     
        new_c = np.concatenate((np.array([[bodypart.replace('_', ' ') + '-bottom a(x)']]), 
                                np.expand_dims(200*np.gradient(200*np.gradient(mouse_datum.part[bodypart].x)), axis = 1)), axis = 0)
        formatted_mouse_datum = np.concatenate((formatted_mouse_datum, new_c), axis = 1)
        new_c = np.concatenate((np.array([[bodypart.replace('_', ' ') + '-bottom a(y)']]), 
                                np.expand_dims(200*np.gradient(200*np.gradient(mouse_datum.part[bodypart].y)), axis = 1)), axis = 0)
        formatted_mouse_datum = np.concatenate((formatted_mouse_datum, new_c), axis = 1)
    formatted_mouse_data.append(formatted_mouse_datum)
counter = 0
for video in videos:
    print(video)
    with open(video[:-4] + 'analyzed.csv', mode = 'w', newline= '') as mouse_csv:
        mouse_csv_writer = csv.writer(mouse_csv, delimiter = ',')
        for row in formatted_mouse_data[counter]:
            mouse_csv_writer.writerow(list(row))
    counter += 1




    
        



    
        
    
        
        



#copytree(video_folder, output_path, ignore=include_patterns('*analyzed.csv'))
  
###Move all analyzed csv's into their own folder, with the same path as video but different root directory
# r=root, d=directories, f = files




    



#data_ending = 'DeepCut_resnet50_motorater_inital_testJul26shuffle1_104000.h5'
##data_ending = 'DeepCut_resnet50_motorater_inital_testJul26shuffle1_104000.csv'
#for video in videos:
#    filename = video[:-4] + data_ending
#    print(filename)
#    with h5py.File(filename, 'r') as f:
#        # List all groups
#        print("Keys: %s" % f.keys())
#        a_group_key = list(f.keys())[0]
#
#        # Get the data
#        data.append(list(f[a_group_key]))
#print(config_path)
#print(config_file.readlines())

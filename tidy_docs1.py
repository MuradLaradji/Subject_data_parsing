import os
import sys
import re

import numpy as np
import pandas as pd

# ce is the "collecting E" variable, which either allows or prevents the collection of data at specific points.
ce = 0

# working directory
os.chdir(sys.path[0])  # sys.path[0] returns the location of the script
data_location = "taste_data/"
os.chdir(data_location)  # set working directory to where the data is

# initialize all data containers
uid = []
active_licks = []
inactive_licks = []

# looping program to find and list important data
for filename in os.listdir(os.getcwd()):  # for all files in the current working directory
    file = open(filename, 'rt')

    x = file.readlines()  # x is a list where each element is a line in the file
    for line in x:
        if line.startswith('Box:'):
            re1 = '(\\d+)'  # Integer Number 1

            rg = re.compile(re1, re.IGNORECASE | re.DOTALL)
            m = rg.search(line)
            if m:
                int1 = m.group(1)

            uid.append(int1)
            print(uid, '33')

        if line.startswith('E:'):
            ce = 1
        if line.startswith('F:'):
            ce = 0

        if ce == 1:
            y = line.split()
            assert isinstance(y, object)
            active_licks.append(y[1:])
            print("active", line, '38')

        if ce == 0:
            y = line.split()
            assert isinstance(y, object)
            inactive_licks.append(y[1:])
            print("inactive", line, '44')

        if line.startswith('G:'):
            y = 10

    file.close()

# writes the strings to a new csv document
with open('C:\\Users\\murad\\PycharmProjects\\Subject_data_parsing\\venv\\export_data1.csv', 'w+') as out:
    out.write(str(active_licks))
    out.write(str(inactive_licks))
    out.write(str(uid))
    out.close()

# combine your variables into a pandas data frame
Subject_Data = pd.DataFrame(list(map(list, zip(uid, active_licks, inactive_licks))))
Subject_Data.columns = ['UID', 'active licks', 'inactive licks']

print(Subject_Data)

# export the data into a csv file
Subject_Data.to_csv("C:\\Users\\murad\\PycharmProjects\\Subject_data_parsing\\export_data.csv", index=True)

# write a copy to the R directory (only applicable to this computer! Change the path for your own!)

import os
import sys
import re

# ce is a collecting T/F variable, which either allows or prevents the collection of lick data at specific points.
ce = 0

# working directory
os.chdir(sys.path[0])  # sys.path[0] returns the location of the script
data_location = "taste_data/"
os.chdir(data_location)  # set working directory to where the data is

# initialize all data containers
uid = []  # list to hold unique ids
active_licks = []  # list for active licks
inactive_licks = []  # list for inactive licks

# looping program to find and list important data
for filename in os.listdir(os.getcwd()):  # for all files in the current working directory
    file = open(filename, 'rt')

    box = str()
    subject = str()
    group = str()

    x = file.readlines()  # x is a list where each element is a line in the file
    for line in x:

        # Extract box number from file
        if line.startswith('Box:'):
            re1 = '.*?'  # Non-greedy match on filler
            re2 = '(\\d+)'  # Integer Number 1

            rg = re.compile(re1 + re2, re.IGNORECASE | re.DOTALL)
            m = rg.search(line)
            if m:
                t_box = m.group(1)
                box = str(t_box)

        # Extract group
        if line.startswith('Group:'):
            y = line.split()
            t_group = y[1]
            group = t_group

        # Extract subject number
        if line.startswith('Subject:'):
            re1 = '.*?'  # Non-greedy match on filler
            re2 = '(?:[a-z][a-z0-9_]*)'  # Uninteresting: var
            re3 = '.*?'  # Non-greedy match on filler
            re4 = '((?:[a-z][a-z0-9_]*))'  # Variable Name 1

            rg = re.compile(re1 + re2 + re3 + re4, re.IGNORECASE | re.DOTALL)
            m = rg.search(line)
            if m:
                t_subject = m.group(1)
                subject = t_subject

        if line.startswith('E:'):
            ce = 1

        if line.startswith('F:'):
            ce = 0

        if ce == 1:
            y = line.split()
            active_licks.append(y[1:])
            # print("active", line, '69')

        if ce == 0:
            y = line.split()
            inactive_licks.append(y[1:])
            # print("inactive", line, '74')

        if line.startswith('G:'):
            ce = 1

    # Create UID
    t_uid = box + "_" + subject + "_" + group
    print(t_uid)
    uid.append(t_uid)

    file.close()

print(uid)

with open('export_data1.txt', 'w+') as out:
    out.write(str(active_licks))
    out.write(str(inactive_licks))
    out.write(str(uid))
    out.close()

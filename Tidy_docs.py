import os
import sys
import re
import csv


# ce is a collecting T/F variable, which either allows or prevents the collection of lick data at specific points.
ce = -1

# working directory
os.chdir(sys.path[0])  # sys.path[0] returns the location of the script
data_location = "taste_data/Py_read"
os.chdir(data_location)  # set working directory to where the data is

# looping program to find and list important data
for filename in os.listdir(os.getcwd()):  # for all files in the current working directory
    file = open(filename, "rt", encoding="utf8")

    uid = str()  # string for uid
    active_licks = []  # list for active licks
    inactive_licks = []  # list for inactive licks
    box = str()  # string for box number
    subject = str()  # string for subject number
    group = str()  # string for group number

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
            active_licks.extend(y[1:])
        # print("active",)

        if ce == 0:
            y = line.split()
            inactive_licks.extend(y[1:])
        # print("inactive")

        if line.startswith('G:'):
            ce = -1

    # Create UID and file names
    t_uid = box + "_" + subject + "_" + group
    file_name_inactive = t_uid + '_inactive.csv'  # string for naming tidier data files
    file_name_active = t_uid + '_active.csv'  # string for naming tidier data files

    # uid.append(t_uid)

    with open(file_name_inactive, 'w+', newline='') as file:
        wr = csv.writer(file, quoting=csv.QUOTE_ALL)
        wr.writerow(inactive_licks)
        file.close()

    with open(file_name_active, 'w+', newline='') as file:
        wr = csv.writer(file, quoting=csv.QUOTE_ALL)
        wr.writerow(active_licks)
        file.close()

    file.close()

print(inactive_licks)

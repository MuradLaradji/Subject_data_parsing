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
uid = []
active_licks = []
inactive_licks = []

# looping program to find and list important data
for filename in os.listdir(os.getcwd()):  # for all files in the current working directory
    file = open(filename, 'rt')

    x = file.readlines()  # x is a list where each element is a line in the file
    for line in x:

        box = int()
        subject = str()

        if line.startswith('Box:'):
            re1 = '.*?'  # Non-greedy match on filler
            re2 = '(\\d+)'  # Integer Number 1

            rg = re.compile(re1 + re2, re.IGNORECASE | re.DOTALL)
            m = rg.search(line)
            if m:
                t_box = m.group(1)
                if t_box.isspace() is False:
                    print(t_box)
                    box = str(line)
        if line.startswith('Subject:'):
            re1 = '.*?'  # Non-greedy match on filler
            re2 = '(?:[a-z][a-z0-9_]*)'  # Uninteresting: var
            re3 = '.*?'  # Non-greedy match on filler
            re4 = '((?:[a-z][a-z0-9_]*))'  # Variable Name 1

            rg = re.compile(re1 + re2 + re3 + re4, re.IGNORECASE | re.DOTALL)
            m = rg.search(line)
            if m:
                t_subject = m.group(1)
                if t_subject.isspace() is False:
                    # print(t_subject)
                    subject = str(t_subject)

        t_uid = (box, subject)
        print(t_uid)
        uid.append(t_uid)


print(uid)







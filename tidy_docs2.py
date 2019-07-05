import os
import re
import sys

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

        t_uid = []
        ce = 0

        if line.startswith('Box:'):
            ce = 1

        if line.startswith('Subject:'):
            ce = 0

        if ce == 1:

            re1 = '.*?'  # Non-greedy match on filler
            re2 = '(\\d+)'  # Integer Number 1

            rg = re.compile(re1 + re2, re.IGNORECASE | re.DOTALL)
            m = rg.search(line)
            if m:
                box = m.group(1)
            if len(box) > 0:
                t_uid.append(box)

            re1 = '.*?'  # Non-greedy match on filler
            re2 = '(?:[a-z][a-z0-9_]*)'  # Uninteresting: var
            re3 = '.*?'  # Non-greedy match on filler
            re4 = '((?:[a-z][a-z0-9_]*))'  # Variable Name 1

            rg = re.compile(re1 + re2 + re3 + re4, re.IGNORECASE | re.DOTALL)
            m = rg.search(line)
            if m:
                subject = m.group(1)

            if len(subject) > 0:
                t_uid.append(subject)

        uid.append(t_uid)
        # print(uid, '56')

        # ce is a collecting T/F variable, which either allows or prevents the collection of lick data.
        ce = 0

        if line.startswith('E:'):
            ce = 1
        if line.startswith('F:'):
            ce = 0

        if ce == 1:
            y = line.split()
            assert isinstance(y, object)
            active_licks.append(y[1:])
            print("active", line, '67')

        if ce == 0:
            y = line.split()
            assert isinstance(y, object)
            inactive_licks.append(y[1:])
            print("inactive", line, '73')

        if line.startswith('G:'):
            ce == 1
    file.close()

# writes the strings to a new csv document
with open('C:\\Users\\murad\\PycharmProjects\\Subject_data_parsing\\venv\\export_data1.txt', 'w+') as out:
    out.write(str(active_licks))
    out.write(str(inactive_licks))
    out.write(str(uid))
    out.close()

# combine your variables into a pandas data frame
# Subject_Data = pd.DataFrame(list(map(list, zip(uid, active_licks, inactive_licks))))
# Subject_Data.columns = ['UID', 'active licks', 'inactive licks']

# print(Subject_Data)

# export the data into a csv file


# write a copy to the R directory (only applicable to this computer! Change the path for your own!)

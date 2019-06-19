import os
import re
import pandas as pd

# initialize all data containers
filenames = []
active_licks = []
inactive_licks = []

# looping program to find and list important data
for filename in os.listdir("C:\\Users\\murad\\PycharmProjects\\Subject_data_parsing\\taste_data"):
    filenames.append(filename)
    file = open(filename, 'rt')

    x = file.readlines()
    for line in x:
        if line.startswith("A:"):

            re1 = '.*?'  # Non-greedy match on filler
            re2 = '(\\d+)'  # Integer Number 1

            rg = re.compile(re1 + re2, re.IGNORECASE | re.DOTALL)
            m = rg.search(line)
            if m:
                int1 = m.group(1)

            active_licks.append(int1)

        if line.startswith("B:"):

            re1 = '.*?'  # Non-greedy match on filler
            re2 = '(\\d+)'  # Integer Number 1

            rg = re.compile(re1 + re2, re.IGNORECASE | re.DOTALL)
            m = rg.search(line)
            if m:
                int1 = m.group(1)

            inactive_licks.append(int1)




file.close()

Subject_Data = pd.DataFrame(list(map(list, zip(filenames, inactive_licks, active_licks))))
Subject_Data.columns=['Subject Name', 'Number of Inactive Licks', 'Active Licks']

print(Subject_Data)

print(filenames)
print(active_licks)
print(inactive_licks)


# combine your variables into a pandas data frame
# make sure data is tidy


# write your data frame to a csv

# import your csv into r

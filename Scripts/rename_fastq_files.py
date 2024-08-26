import os
import pandas as pd

# Change directory
#os.chdir('C:\\Users\\Bilal\\OneDrive - Kansas State University\\Documents\\PHD\\Bedtools\\Biocode_ATAC_Seq\\Chipseq_Scripts')

# Check directory
#os.getcwd()

# Read in the file
files_names = pd.read_csv("files_names.txt", sep="\t", header=None, names=["old_name", "new_name"])
Files_extension='.txt'

# Let us iterate through the files and rename them
for index, row in files_names.iterrows():
    old_name = row["old_name"]
    new_name = row["new_name"]
    old_name_with_extension = old_name+Files_extension
    new_name_with_extension = new_name+Files_extension
    
    if os.path.exists(old_name_with_extension):
        os.rename(old_name_with_extension, new_name_with_extension)
        print(f'Renamed: {old_name_with_extension} to {new_name_with_extension}')
    else:
        print(f'{old_name_with_extension} does not exist')

#Find the text files in the directory
[]
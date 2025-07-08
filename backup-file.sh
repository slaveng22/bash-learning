#!/bin/bash
# BASH LEARNING TASKS
# Task 2: Create a script that renames all .txt files to .bak.
# Description: Script accepts 1 argument which is path. 
# We pass this argument to "cd" command to move to the directory we want to execute this script on
# Then we use pattern matching for loop to find all files that have txt extension
# and run mv command to change extension to bak. mv command has -- option which basically tells mv that there
# are no options after it. This is done to avoid issues with filenames that start with a dash (-).
# First you get a original files from for loop, then you use parameter expansion to remove the .txt extension.
# You use % to remove the shortest match from the end of the string. Then you append the new extension .bak.

# Check if the argument is provided
if [[ -z $1 ]]; then
    echo "Usage: $0 <path>"
    exit 1
fi

# Variables
path=$1
file_type=txt
new_file_type=bak

# Check if the directory exists, if not, exit with an error message, if yes cd to it.
if [[! -d $path ]]; then
    echo "Directory $path does not exist."
    exit 1
fi
cd $path

# Search for all files with the specified file type and rename them
for file in *.$file_type; do
    mv -- "$file" "${file%.$file_type}.$new_file_type"
done
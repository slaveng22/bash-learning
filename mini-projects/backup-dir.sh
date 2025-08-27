#!/bin/bash
# BASH LEARNING TASKS
# Task 3:Write a script that backs up all files in a directory with a timestamp.
# Description: Script accepts argument on position 1, and that is path.
# Script uses "tar" command to create a compressed archive of the directory with a timestamp.
# We first pass path argument to select which directory to backup.
# Then we create a timestamp using the date command.
# Then we extract the directory name from the path using basename command.
# Finally, we create a tar.gz archive of the directory with the timestamp in the filename.
# c - create, z - compress with gzip, f - file name, C - change to directory . to compress contend of current directory.

path=$1
timestamp=$(date +%Y-%m-%d_%H%M)
dir_name=$(basename "$path")
tar czf ./backup-"$dir_name"-"$timestamp".tar.gz -C "$path" .
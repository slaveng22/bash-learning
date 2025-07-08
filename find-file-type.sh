#!/bin/bash
# BASH LEARNING TASKS
# Task 1: Write a script that lists all files in a directory with a specific extension.
# Description: Script accepts 2 arguments, position 1 is path, position 2 is file type
# Script uses "find" to which is used for searching files in Linux.
# We first pass path argument to find which is a directory we want to search in.
# Then we pass file_type argumet which is put in wildcard search
# Then we use -exec <command> {} \ to execute basename command on each file that "find" finds
# Basename command will return only filename instead of full path to the file.

path=$1
file_type=$2
find $path -name "*.$file_type" -exec basename {} \;
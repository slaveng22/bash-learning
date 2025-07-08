#!/bin/bash
# BASH LEARNING TASKS
# Task 1: Write a script that lists all files in a directory with a specific extension.
# Description: Script accepts 2 arguments 1. is passed to path variable, 2. is passed to file_type variable 
# Script first cd to the directory we want to search in, which it gets from path vvariable
# Then it uses pattern matching for loop to find each file with wanted extension and print it
path=$1
file_type=$2
cd $path
for file in *.$file_type; do
    echo $file
done
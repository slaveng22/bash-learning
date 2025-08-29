#!/usr/bin/env bash

# Write a Bash script that takes two arguments: a directory path and a file extension.
# The script should: Check that the directory exists (print an error if not).
# Count how many files in that directory (non-recursive) have the given extension.
# Print the names of the files with that extension.
# Handle the case where no matching files exist (print a message).

DIR=$1
FILE_EXTENSION=$2

if ! [[ -d "$DIR" ]]; then
  echo "Directory $DIR doesn't exist" >&2
  exit 1
fi

shopt -s nullglob
file_count=0

for file in "$DIR"/*; do
  if [[ $file == *.$FILE_EXTENSION ]]; then
    ((file_count++))
    echo $(basename "$file")
  fi
done

if [[ $file_count -gt 0 ]]; then
  echo "Found $file_count with $FILE_EXTENSION extension"
else
  echo "No files found with $FILE_EXTENSION extension"
fi

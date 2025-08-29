#!/usr/bin/env bash

# Takes path as argument and count files and subdirectories
# Files: 5
# Directories: 3
# The script should handle the case where no argument is provided (print a usage message).
# The script should handle the case where the argument is not a directory (print an error).
DIR=$1

if [[ -z "$DIR" ]]; then
  echo "Usage $0 /path/to/directory" >&2
  exit 1
fi

if ! [[ -d "$DIR" ]]; then
  echo "$DIR is not a directory" >&2
  exit 1
fi

file=0
directory=0

shopt -s nullglob
for object in "$DIR"/*; do
  if [[ -d $object ]]; then
    ((directory++))
  elif [[ -f $object ]]; then
    ((file++))
  fi
done

echo "Files: $file"
echo "Directories: $directory"

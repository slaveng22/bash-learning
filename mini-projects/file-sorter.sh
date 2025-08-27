#!/bin/bash
# BASH LEARNING TASKS
# Task 10: File sorter 

set -euo pipefail
IFS=$'\n\t'

read -p "Enter the full path to the directory to sort files: " DIRECTORY
if [[ ! -d "$DIRECTORY" ]]; then
    echo "Directory does not exist."
    exit 1
fi

cd "$DIRECTORY" || exit 1

mkdir -p Videos Images Documents Music

for file in *; do
    [[ -f "$file" ]] || continue

    ext="${file##*.}"
    if [[ "$file" == "$ext" ]]; then
        echo "No extension: $file"
        continue
    fi
    ext="${ext,,}"                # Convert to lowercase
    ext="${ext//[[:space:]]/}"    # Remove whitespace

    case "$ext" in
        mp4|mkv|mov|avi|webm)
            echo "Moving to Videos/"
            mv -n "$file" Videos/
            ;;
        jpg|jpeg|png|gif|bmp|svg)
            echo "Moving to Images/"
            mv -n "$file" Images/
            ;;
        txt|pdf|doc|docx|odt)
            echo "Moving to Documents/"
            mv -n "$file" Documents/
            ;;
        mp3|wav|flac|ogg|m4a)
            echo "Moving to Music/"
            mv -n "$file" Music/
            ;;
        *)
            echo "Unknown file type: $file"
            ;;
    esac
done
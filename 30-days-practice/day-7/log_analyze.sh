#!/usr/bin/env bash
# Takes a log file path as input.
# Counts how many lines contain the word "error" (case-insensitive).
# Prints the 5 most recent error lines (from the bottom of the file).
# Handles missing or unreadable file errors cleanly.

LOG_FILE_PATH=$1

if [[ ! -f "$LOG_FILE_PATH" || ! -r "$LOG_FILE_PATH" ]]; then
  echo "'$LOG_FILE_PATH' doesn't exist or this script can't read it "
  exit 1
fi

if ! [[ -s "$LOG_FILE_PATH" ]]; then
  echo "Warning: File '$LOG_FILE_PATH' is empty."
  exit 0
fi

COUNT=$(grep -i "error" "$LOG_FILE_PATH" | wc -l)

if [[ $COUNT -eq 0 ]]; then
  echo "No error lines found in the file."
  exit 0
else
  echo "Errors found: $COUNT"
fi

echo

grep -i "error" "$LOG_FILE_PATH" | tail -n 5 | nl -w2 -s". "

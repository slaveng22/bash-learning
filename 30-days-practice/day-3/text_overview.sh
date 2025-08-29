#!/usr/bin/env bash

# Takes one filename as an argument and:
# Checks that the file exists and is readable.
# Counts the number of lines, words, and characters in the file.
# Prints the top 5 most common words in the file, sorted by frequency (case-insensitive).

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 /path/to/file.txt" >&2
  exit 1
fi

file=$1
if [[ ! -f $file ]]; then
  echo "Error: '$file' does not exist" >&2
  exit 1
elif [[ ! -r $file ]]; then
  echo "Error: '$file' is not readable" >&2
  exit 1
fi

# Count lines, words, chars in one pass
read lines words chars _ < <(wc -lwm "$file")
echo "Lines: $lines"
echo "Words: $words"
echo "Characters: $chars"

echo
echo "Top 5 words:"
tr '[:upper:]' '[:lower:]' <"$file" |
  tr -sc '[:alnum:]' '\n' |
  sort | uniq -c | sort -nr | head -5 |
  awk '{print $2 " (" $1 ")"}'

#!/usr/bin/env bash
# Takes a directory path as an argument.
# If no argument → print usage and exit.
# If the directory does not exist → print an error and exit.
# Prints a list of all files in that directory sorted by size descending.
# For each file, print:
# size (human-readable)
# file name
# At the end, print:
# Total number of files
# Total combined size (human-readable)
#
# Exampe output

# File sizes in /var/log:
# -----------------------------------
# 12M  syslog
# 4.5M kern.log
# 1.1M auth.log
# ...
#
# Total files: 17
# Total size: 18M

DIR=${1:?Usage: $0 <directory>}
[[ -d "$DIR" ]] || {
  echo "Not a directory: $DIR"
  exit 1
}

mapfile -t files < <(find "$DIR" -maxdepth 1 -type f -printf "%s %f\n" | sort -nrk1)

((${#files[@]} == 0)) && {
  echo "No files"
  exit 0
}

total=0
for f in "${files[@]}"; do
  size=${f%% *}
  name=${f#* }
  total=$((total + size))
  printf "%-8s %s\n" "$(numfmt --to=iec "$size")" "$name"
done

echo "Total files: ${#files[@]}"
echo "Total size:  $(numfmt --to=iec "$total")"

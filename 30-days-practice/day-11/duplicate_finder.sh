#!/usr/bin/env bash

# Takes any number of arguments (strings).
# If no arguments, print usage and exit.
# Treats arguments case-insensitively.
# Finds and prints:
#     Duplicate arguments
#     How many times each duplicate appears
# Arguments that appear only once should not be printed.
# Output must be sorted alphabetically.

# Example output:
#     apple: 2
#     banana:2

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 arg1 arg2 ..."
    exit 1
fi

declare -A arg_count

for arg in "$@"; do
    lower_arg=${arg,,}
    ((arg_count["$lower_arg"]++))
done

# Collect duplicates
duplicates=()
for key in "${!arg_count[@]}"; do
    if (( arg_count[$key] > 1 )); then
        duplicates+=("$key: ${arg_count[$key]}")
    fi
done

# Print results
if [[ ${#duplicates[@]} -eq 0 ]]; then
    echo "No duplicates found."
    exit 0
fi

# Sort and print
printf "%s\n" "${duplicates[@]}" | sort
#!/usr/bin/env bash

# Takes any number of arguments (words or numbers).
# If no arguments are given → print usage and exit.
# For each argument:
# Print whether it is:
#     - an integer
#     - or not an integer

# At the end, print:
#     - Total arguments
#     - How many were integers
#     - How many were not integers

# An integer is defined as:
#     - optional leading -
#     - followed by one or more digits
#     (-42, 0, 123 → valid; +3, 3.14, 42a → invalid)

# Use regex

if [ $# -eq 0 ]; then
    echo "Usage: $0 arg1 arg2 ..."
    exit 1
fi
total_args=$#
int_count=0
non_int_count=0

for arg in "$@"; do
    if [[ $arg =~ ^-?[0-9]+$ ]]; then
        echo "'$arg' is an integer."
        ((int_count++))
    else
        echo "'$arg' is not an integer."
        ((non_int_count++))
    fi
done

echo "Total arguments: $total_args"
echo "Integers: $int_count"
echo "Non-integers: $non_int_count"
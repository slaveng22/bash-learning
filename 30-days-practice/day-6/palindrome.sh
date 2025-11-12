#!/usr/bin/env bash

# Check if word or sentance is a palidrome

INPUT_TEXT=$1
INPUT_TEXT=$(echo "$INPUT_TEXT" | tr -d '[:space:]')

echo "$INPUT_TEXT"

#!/usr/bin/env bash

# Check if word or sentance is a palindrome

INPUT_TEXT=$1
INPUT_TEXT=$(echo "$INPUT_TEXT" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')

REVERSE_TEXT=$(echo "$INPUT_TEXT" | rev)

if [[ "$INPUT_TEXT" == "$REVERSE_TEXT" ]]; then
  echo "Text you entered is palindrome"
else
  echo "Text you entered isn't palindrome"
fi

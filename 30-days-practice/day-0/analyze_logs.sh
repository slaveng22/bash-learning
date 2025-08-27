#!/usr/bin/env bash

# Example output
# IP Address      Total Requests       Failed Requests
# -----------------------------------------------------
# 192.168.0.12    1                    0
# 192.168.0.11    2                    2
# 192.168.0.10    2                    0

set -e
FILE=$1

if [[ -z "$FILE" ]]; then
  echo "Usage: ./$0 /path/to/logfile"
  exit 1
fi

awk '

BEGIN { 
  headerOutputFormat = "%-15s %-20s %-15s\n"; #Configure line output
  outputFormat = "%-15s %-20d %-15d\n"; #Configure line output 
  ipNumbers=0 
  printf (headerOutputFormat, "IP Address", "Total Requests", "Failed Requests"); #output headers
  print "-----------------------------------------------------"; 
} 

{ 
  total_requests[$1]++ 
  if ($9 >= 400 && $9 <= 599)
    {
    failed_requests[$1]++; 
    } 
}

END { 
  for (ip in total_requests) 
    { 
      printf (outputFormat, ip, total_requests[ip], failed_requests[ip]); 
    } 
}' "$FILE"

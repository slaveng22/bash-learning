#!/bin/bash

# BASH LEARNING TASKS
# Task 4: Create a menu-driven script that performs system health checks.
# Script: system-monitor.sh
# Description: A simple, real-time monitoring script for Linux
# It displays Hardware info, Network info, Kernel ersion, Uptime, OS info, Inodes, SWAP, Running services, CPU, Memory and Disk Usage

set -euo pipefail

#--- Configuration ---
REFRESH_INTERVAL=2
#--- Colors ---
GREEN='\e[32m'
RED='\e[31m'
YELLOW='\e[33m'
CYAN='\e[36m'
NC='\e[0m' # No Color

#--- Functions ---

# CPU info
get_cpu_info() {

    CPU=$(lscpu | awk -F: '/Model name/ {print $2}')
    # Trim whitespace
    CPU=$(echo $CPU | xargs)
    echo -e "${GREEN}---CPU Model---${NC}: $CPU"
}

get_cpu_info

# Network info
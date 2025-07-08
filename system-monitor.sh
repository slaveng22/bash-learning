#!/bin/bash

# BASH LEARNING TASKS
# Task 4: Create a menu-driven script that performs system health checks.
# Script: system-monitor.sh
# Description: A simple, real-time monitoring script for Linux
# It displays Hardware info, Network info, Kernel version, Uptime, OS info, Inodes, SWAP, Running services, CPU, Memory and Disk Usage

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

  CPU=$(lscpu | awk -F: '$1 ~ /^Model name$/ {print $2; exit}' | xargs)
  echo -e "${GREEN}---CPU Model---${NC}: $CPU"

}

get_ram_model() {

  RAM=$(lshw -class memory | grep -i "product" | head -1 | awk -F: '{print $2}' | xargs)
  echo -e "${GREEN}---RAM Model---${NC}: $RAM"

}

get_wirless_card() {

  WIRELESS=$(lspci | grep -i 'wireless' | cut -d ':' -f3- | xargs)
  echo -e "${GREEN}---Wirless Card Model---${NC}: $WIRELESS"

}

get_ethernet_card() {

  ETHERNET=$(lspci | grep -i 'ethernet' | cut -d ':' -f3- | xargs)
  echo -e "${GREEN}---Ethernet Card Model---${NC}: $ETHERNET"

}

get_os_info() {

  OS=$(lsb_release -a | grep -i Description | awk -F: '{print $2}' | xargs)
  echo -e "${GREEN}---OS info---${NC}: $OS"

}

get_uptime() {
  echo -e "${GREEN}---System Uptime---${NC}: $(uptime -p)"
}

get_kernel_version() {
  echo -e "${GREEN}---Kernel Version---${NC}: $(uname -r)"
}

get_cpu_info
get_ethernet_card
get_wirless_card
get_ram_model
echo ""
get_os_info
get_uptime
get_kernel_version
# Network info

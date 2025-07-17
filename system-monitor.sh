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

# Get the primary network interface (excluding loopback)
INTERFACE=$(ip route | grep '^default' | awk '{print $5}')

# Get the IP address and subnet mask
IP_INFO=$(ip -o -f inet addr show "$INTERFACE")
IP_ADDRESS=$(echo "$IP_INFO" | awk '{print $4}' | cut -d/ -f1)
SUBNET_CIDR=$(echo "$IP_INFO" | awk '{print $4}' | cut -d/ -f2)

# Convert CIDR to subnet mask
CIDR2MASK() {
  local i mask=""
  local full_octets=$((SUBNET_CIDR / 8))
  local remaining_bits=$((SUBNET_CIDR % 8))

  for ((i = 0; i < 4; i++)); do
    if [ $i -lt $full_octets ]; then
      mask+="255"
    elif [ $i -eq $full_octets ]; then
      mask+=$((256 - 2 ** (8 - remaining_bits)))
    else
      mask+="0"
    fi
    [ $i -lt 3 ] && mask+="."
  done
  echo "$mask"
}

SUBNET_MASK=$(CIDR2MASK)

# Get the default gateway
GATEWAY=$(ip route | grep '^default' | awk '{print $3}')

# Print results
echo "Interface     : $INTERFACE"
echo "IP Address    : $IP_ADDRESS"
echo "Subnet Mask   : $SUBNET_MASK"
echo "Default Gateway: $GATEWAY"

# Monitor

INTERVAL=1

# Trap Ctrl+C and restore terminal
trap "tput cnorm; clear; exit" INT

tput civis # Hide cursor

# Get initial byte counts
declare -A RX1 TX1
for IFACE in /sys/class/net/*; do
  IF=$(basename "$IFACE")
  RX1["$IF"]=$(<"$IFACE/statistics/rx_bytes")
  TX1["$IF"]=$(<"$IFACE/statistics/tx_bytes")
done

while true; do
  clear
  echo "===== LIVE SYSTEM MONITOR ====="
  echo "Time: $(date)"
  echo

  echo "--- CPU Load ---"
  uptime | awk -F'load average:' '{ print "Load average (1/5/15 min):" $2 }'

  echo
  echo "--- Memory Usage ---"
  free -h | awk 'NR==1 || /Mem|Swap/'

  echo
  echo "--- Disk Usage (/ only) ---"
  df -h / | awk 'NR==1 || NR==2'

  echo
  echo "--- Network I/O (per interface) ---"
  for IFACE in /sys/class/net/*; do
    IF=$(basename "$IFACE")
    RX2=$(<"$IFACE/statistics/rx_bytes")
    TX2=$(<"$IFACE/statistics/tx_bytes")

    RX_RATE=$(((RX2 - RX1[$IF]) / INTERVAL))
    TX_RATE=$(((TX2 - TX1[$IF]) / INTERVAL))

    RX1[$IF]=$RX2
    TX1[$IF]=$TX2

    # Skip interfaces with no traffic (optional)
    if [[ $RX_RATE -eq 0 && $TX_RATE -eq 0 ]]; then
      continue
    fi

    echo "$IF: ↓ $((RX_RATE / 1024)) KB/s | ↑ $((TX_RATE / 1024)) KB/s"
  done

  echo
  echo "Press Ctrl+C to exit."
  sleep $INTERVAL
done

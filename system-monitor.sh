#!/bin/bash

# BASH LEARNING TASKS
# Task 4: Create a menu-driven script that performs system health checks.
# Script: system-monitor.sh
# Description: A simple, real-time monitoring script for Linux

set -euo pipefail
trap 'error "Script failed on line $LINENO with exit code $?"' ERR

# Logging colors
GREEN='\033[1;32m'
CYAN='\033[1;36m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info() { echo -e "${CYAN}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }
prompt() { echo -ne "${BLUE}[PROMPT]${NC} $1"; }

check_not_root() {
  if [[ $EUID -eq 0 ]]; then
    error "This script should not be run as root. Please run as a regular user with sudo access."
    exit 1
  fi
}

check_sudo_access() {
  if ! sudo -n true 2>/dev/null; then
    warn "Sudo access required. You may be prompted for your password."
    if ! sudo -v; then
      error "Failed to obtain sudo access. Exiting."
      exit 1
    fi
  fi
  success "Sudo access confirmed"
}

sysinfo() {
  clear
  echo -e "${CYAN}=========================================${NC}"
  echo -e "${CYAN}           SYSTEM INFORMATION${NC}"
  echo -e "${CYAN}=========================================${NC}"

  echo -e "${YELLOW}Hostname:${NC} ${GREEN}$(hostname)${NC}"
  source /etc/os-release
  echo -e "${YELLOW}OS:${NC} ${GREEN}$PRETTY_NAME${NC}"
  echo -e "${YELLOW}Kernel:${NC} ${GREEN}$(uname -r)${NC}"
  echo -e "${YELLOW}Architecture:${NC} ${GREEN}$(uname -m)${NC}"
  cpu_model=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | sed 's/^ *//')
  cpu_cores=$(nproc)
  echo -e "${YELLOW}CPU:${NC} ${GREEN}$cpu_model ${BLUE}($cpu_cores cores)${NC}"
  total_mem=$(grep MemTotal /proc/meminfo | awk '{print int($2/1024/1024)" GB"}')
  echo -e "${YELLOW}Total Memory:${NC} ${BLUE}$total_mem${NC}"
  echo -e "${YELLOW}Current User:${NC} ${GREEN}$(whoami)${NC}"
  echo -e "${YELLOW}Shell:${NC} ${GREEN}$SHELL${NC}"
  echo -e "${CYAN}=========================================${NC}"
  echo ""
}

sysmonitor() {
  clear
  echo -e "${CYAN}=========================================${NC}"
  echo -e "${CYAN}           SYSTEM MONITOR${NC}"
  echo -e "${CYAN}=========================================${NC}"

  while true; do
    echo -e "${YELLOW}Time:${NC} $(date '+%Y-%m-%d %H:%M:%S')"
    echo -e "${YELLOW}CPU Usage:${NC} $(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.2f%%", usage}')"
    free -h | awk 'NR==2{printf "\033[1;33mMemory Usage:\033[0m %s/%s (%.2f%%)\n", $3,$2,($3/$2)*100}'
    df -h | awk '$NF=="/"{printf "\033[1;33mDisk Usage:\033[0m %s/%s (%s)\n", $3,$2,$5}'
    echo -e "${YELLOW}Top 5 Processes by CPU:${NC}"
    ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
    echo -e "${CYAN}=========================================${NC}"
    sleep 2
    clear
  done
}

menu() {
  while true; do
    echo -e "${GREEN}System Monitor Menu:${NC}"
    echo "1) Show System Information"
    echo "2) Real-Time Monitoring"
    echo "3) Exit"
    prompt "Choose an option [1-3]: "
    read -r choice

    case $choice in
    1) sysinfo ;;
    2) sysmonitor ;;
    3)
      success "Exiting. Goodbye!"
      exit 0
      ;;
    *) warn "Invalid option. Please try again." ;;
    esac
  done
}

# Main execution
check_not_root
check_sudo_access
menu

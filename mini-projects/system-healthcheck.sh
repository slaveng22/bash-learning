#!/bin/bash 
# BASH LEARNING TASKS
# Task 4: Create a menu-driven script that performs system health checks.

# Colors
GREEN='\e[32m'
RED='\e[31m'
YELLOW='\e[33m'
CYAN='\e[36m'
NC='\e[0m' # No Color

# CHECK CPU
check_cpu() {
    echo -e "${CYAN}--- CPU Load---${NC}"
    uptime
    echo
}

# CHECK MEMORY
check_memory() {
    echo -e "${CYAN}--- Memory Usage ---${NC}"
    free -h
    echo
}

# CHECK DISK USAGE
check_disk() {
    echo -e "${CYAN}--- Disk Usage ---${NC}"
    df -h
    echo
}

# CHECK RUNNING SERVICES
check_services() {
    echo -e "${CYAN}--- Services Status ---${NC}"
    readarray -t services < <(systemctl list-units --type=service)
    for service in "${services[@]}"; do
        if systemctl is-active --quiet "#service"; then
            echo -e "${GREEN}$service is running${NC}"
        else
            echo -e "${RED}$service is not running${NC}"
        fi
    done
    echo
}

# CHECK OPEN PORTS
check_ports() {
    echo -e "${CYAN}--- Open Ports ---${NC}"
    sudo ss -tuln | grep LISTEN
    echo
}

# FAILED LOGINS
check_failed_logins() {
    echo -e "${CYAN}--- Failed Login Attempts ---${NC}"
    sudo journalctl _COMM=sshd | grep "Failed password" | tail -n 10
    echo
}

# UPTIME
check_uptime() {
    echo -e "${CYAN}--- System Uptime ---${NC}"
    uptime -p
    echo
}

while true; do
    echo -e "${YELLOW}"
    cat << "EOF"
  _    _            _ _   _      _____ _               _                
 | |  | |          | | | | |    / ____| |             | |            
 | |__| | ___  __ _| | |_| |__ | |    | |__   ___  ___| | _____ _ __ 
 |  __  |/ _ \/ _` | | __| '_ \| |    | '_ \ / _ \/ __| |/ / _ \ '__|
 | |  | |  __/ (_| | | |_| | | | |____| | | |  __/ (__|   <  __/ |   
 |_|  |_|\___|\__,_|_|\__|_| |_|\_____|_| |_|\___|\___|_|\_\___|_|   
 
EOF
    echo -e "${NC}"

    echo "1. Check CPU Load"
    echo "2. Check Memory Usage"
    echo "3. Check Disk Usage"
    echo "4. Check Running Services"
    echo "5. Check Open Ports"
    echo "6. Check Failed Login Attempts"
    echo "7. Check System Uptime"
    echo "8. Run All Checks"
    echo "9. Exit"

    read -rp "Select an option (1-8): " choice

    case $choice in
        1) check_cpu ;;
        2) check_memory ;;
        3) check_disk ;;
        4) check_services ;;
        5) check_ports ;;
        6) check_failed_logins ;;
        7) check_uptime ;;
        8) 
           check_cpu 
           check_memory 
           check_disk 
           check_services 
           check_ports 
           check_failed_logins 
           check_uptime 
           ;;
        9) echo -e "${GREEN}Exiting...${NC}"; exit 0 ;;
        *) echo -e "${RED}Invalid option, please try again.${NC}" ;;
    esac
    read -rp "Press enter to continue..."
done
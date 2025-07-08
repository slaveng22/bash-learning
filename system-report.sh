#!/bin/bash 
# BASH LEARNING TASKS
# Task 5: Write a script to monitor CPU & RAM usage and send an alert if it exceeds a limit.

# Treshold values
CPU_THRESHOLD=20
RAM_THRESHOLD=50
DISK_THRESHOLD=10

# EMAIL settings
EMAIL="nevalsgugolj@gmail.com"
SUBJECT="High Resource Usage Alert" 


# Install dependencies if not installed
if command -v mpstat &> /dev/null ; then
    sudo apt install sysstat -y > /dev/null 2>&1
fi

if command -v bc &> /dev/null ; then
    sudo apt install bc -y > /dev/null 2>&1
fi

# You still need to configure your system to send emails.
if ! command -v mail &> /dev/null ; then
    sudo apt install mailutils -y > /dev/null 2>&1
fi

# Current CPU, DISK and RAM usage
CURRENT_CPU_USAGE_SYS=$(mpstat | awk '/all/ {print $6}')
CURRENT_CPU_USAGE_USER=$(mpstat | awk '/all/ {print $4}')
TOTAL_CPU_USAGE=$(echo "$CURRENT_CPU_USAGE_SYS + $CURRENT_CPU_USAGE_USER" | bc)

CURRENT_RAM_USAGE=$(free | awk '/Mem/ {printf("%.2f"), $3/$2 * 100}')

CURRENT_DISK_FREE=$(df -BG / | awk '/dev/ {print $4}')
CURRENT_DISK_FREE=${CURRENT_DISK_FREE%G}

if (( $(echo "$TOTAL_CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
        SUBJECT="⚠️ High CPU Usage Alert"
        BODY="Current CPU usage is $TOTAL_CPU_USAGE%. Please check the system."
        echo "$BODY" | mail -s "$SUBJECT" "$EMAIL"
else
    echo "CPU usage is within the threshold: $TOTAL_CPU_USAGE%"
fi

if (( $(echo "$CURRENT_RAM_USAGE > $RAM_THRESHOLD" | bc -l) )); then
        SUBJECT="⚠️ High RAM Usage Alert"
        BODY="Current RAM usage is $CURRENT_RAM_USAGE%. Please check the system."
        echo "$BODY" | mail -s "$SUBJECT" "$EMAIL"
else
    echo "RAM usage is within the threshold: $CURRENT_RAM_USAGE%"
fi

if (( $(echo "$CURRENT_DISK_FREE < $DISK_THRESHOLD" | bc -l) )); then
        SUBJECT="⚠️ Low Storage Alert"
        BODY="Current disk free space is $CURRENT_DISK_FREE GB. Please check the system."
        echo "$BODY" | mail -s "$SUBJECT" "$EMAIL"
else
    echo "Disk free space is within the threshold: $CURRENT_DISK_FREE GB"
fi
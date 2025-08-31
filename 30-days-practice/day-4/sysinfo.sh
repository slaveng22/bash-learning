#!/usr/bin/env bash

# Prints the current system uptime (in minutes).
# Prints the number of logged-in users.
# Prints the top 5 processes by CPU usage (show PID, user, %CPU, and command).

UPTIME=$(uptime -p)
USERSNO=$(users | xargs -n 1 | sort | uniq | wc -w)

echo "System uptime: $UPTIME"
echo
echo "Nuber of currently logged in users is: $USERSNO"
echo
echo "Top 5 processes by CPU usage:"

ps -eo pid,user,pcpu,comm --sort=-pcpu | head -n 6

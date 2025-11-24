#!/usr/bin/env bash
# Takes a username as an argument
# If no username is provided → print usage & exit.
# Checks if that user exists on the system
# If user does not exist → print a clear error & exit.
# Prints:
# - User's home directory
# - User's default shell
# - How many processes they are currently running
# - Their last login time (use last)
#
# If the user has 0 running processes, print Note: User is currently not running any processes.
#
# Example output:
#   User: alice
#   Home directory: /home/alice
#   Shell: /bin/bash
#   Running processes: 3
#   Last login:
#   alice    pts/0    192.168.0.12   Fri Nov 15 10:43   still logged in

USER=$1

if [[ -z "$1" ]]; then
  echo "Usage: $0 user"
  exit 1
fi

if ! getent passwd "$USER" >/dev/null; then
  echo "User "$USER" doesn't exist on this system"
  exit 1
fi

HOME_DIRECTORY=$(getent passwd "$USER" | awk -F: '{print $(NF-1)}')
USER_SHELL=$(getent passwd "$USER" | awk -F: '{print $NF}')
PROCESS_NO=$(ps -U "$USER" --no-headers | wc -l)
LAST_LOGIN=$(who | awk '{print $4,$3}')

echo "User: "$USER""
echo "Home directory: "$HOME_DIRECTORY""
echo "Shell: "$USER_SHELL""
if [[ "$PROCESS_NO" -ge 1 ]]; then
  echo "Running processes: "$PROCESS_NO""
else
  echo "Note: User is currently not running any processes."
fi
echo "Last login: "$LAST_LOGIN""

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
# Example outputL:
#   User: alice
#   Home directory: /home/alice
#   Shell: /bin/bash
#   Running processes: 3
#   Last login:
#   alice    pts/0    192.168.0.12   Fri Nov 15 10:43   still logged in

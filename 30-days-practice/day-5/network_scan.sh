#!/usr/bin/env bash

# Takes a subnet in CIDR notation as input (e.g. 192.168.1.0/24).
# Pings every host in that subnet (only once, quick check).
# Prints a list of the hosts that respond.

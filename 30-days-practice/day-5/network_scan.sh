#!/usr/bin/env bash
# Takes a subnet in CIDR notation as input (e.g. 192.168.1.0/24).
# Pings every host in that subnet (only once, quick check).
# Prints a list of the hosts that respond.
set -euo pipefail

error() {
  echo "Error: $1" >&2
  exit 1
}

trap 'error "Script failed on line $LINENO with exit code $?"' ERR

# Validate IP address format
validate_ip() {
  local ip=$1
  local IFS=.
  local -a octets
  read -ra octets <<<"$ip"

  # Check if we have exactly 4 octets
  if [ ${#octets[@]} -ne 4 ]; then
    return 1
  fi

  # Check each octet
  for octet in "${octets[@]}"; do
    # Check if it's a number
    if ! [[ "$octet" =~ ^[0-9]+$ ]]; then
      return 1
    fi

    # Check if it's in valid range (0-255)
    if [ "$octet" -lt 0 ] || [ "$octet" -gt 255 ]; then
      return 1
    fi
  done

  return 0
}

# Validate CIDR notation
validate_cidr() {
  local cidr=$1

  # Check if CIDR contains exactly one '/'
  if [ "$(echo "$cidr" | grep -o "/" | wc -l)" -ne 1 ]; then
    error "Invalid CIDR format. Expected format: IP/PREFIX (e.g., 192.168.1.0/24)"
  fi

  local ip_part=$(echo "$cidr" | cut -d "/" -f 1)
  local prefix_part=$(echo "$cidr" | cut -d "/" -f 2)

  # Validate IP address
  if ! validate_ip "$ip_part"; then
    error "Invalid IP address: $ip_part"
  fi

  # Validate prefix length
  if ! [[ "$prefix_part" =~ ^[0-9]+$ ]]; then
    error "Invalid prefix length: $prefix_part (must be a number)"
  fi

  if [ "$prefix_part" -lt 0 ] || [ "$prefix_part" -gt 32 ]; then
    error "Invalid prefix length: $prefix_part (must be between 0 and 32)"
  fi

  return 0
}

ip_to_decimal_int() {
  local ip_address="$1"
  local a b c d
  local IFS=.
  read -r a b c d <<<"$ip_address"
  printf '%d\n' "$((a * 256 ** 3 + b * 256 ** 2 + c * 256 + d))"
}

decimal_int_to_ip() {
  local dec_ip="$1"
  local ip=""
  local delim=""
  local octet
  for e in {3..0}; do
    octet=$((dec_ip / (256 ** e)))
    dec_ip=$((dec_ip - octet * 256 ** e))
    ip+="$delim$octet"
    delim="."
  done
  echo "$ip"
}

ping_available_hosts() {
  local start_int=$1
  local end_int=$2
  local current_int
  local current_ip

  echo "Scanning range: $(decimal_int_to_ip "$start_int") to $(decimal_int_to_ip "$end_int")"
  echo "--------------------------------------------------------"
  echo "Active Hosts:"

  if [[ $start_int -gt $end_int ]]; then
    echo "No usable hosts available in this subnet size."
    return 0
  fi

  for ((current_int = start_int; current_int <= end_int; current_int++)); do
    current_ip=$(decimal_int_to_ip "$current_int")
    if ping -c 1 -w 1 "$current_ip" >/dev/null 2>&1; then
      echo "$current_ip is UP"
    fi
  done
}

# Check if argument is provided
if [ $# -eq 0 ]; then
  error "No argument provided. Usage: $0 <IP/CIDR> (e.g., 192.168.1.0/24)"
fi

IP_WITH_CIDR=$1

# Validate the input
validate_cidr "$IP_WITH_CIDR"

CIDR_LENGTH=$(echo "$IP_WITH_CIDR" | cut -d "/" -f 2)
IP_ADDRESS=$(echo "$IP_WITH_CIDR" | cut -d "/" -f 1)

BITS_TO_SET=$((32 - CIDR_LENGTH))

# Calculate netmask correctly using bit shifting
if [ "$BITS_TO_SET" -eq 32 ]; then
  NET_MASK_DEC=0
else
  NET_MASK_DEC=$(((0xFFFFFFFF << BITS_TO_SET) & 0xFFFFFFFF))
fi

INPUT_IP_DEC=$(ip_to_decimal_int "$IP_ADDRESS")
NETWORK_IP_DEC=$((INPUT_IP_DEC & NET_MASK_DEC))
NETWORK_IP=$(decimal_int_to_ip "$NETWORK_IP_DEC")

# Calculate broadcast address
if [ "$BITS_TO_SET" -eq 0 ]; then
  BROADCAST_IP_DEC=$NETWORK_IP_DEC
else
  BROADCAST_IP_DEC=$((NETWORK_IP_DEC | ((1 << BITS_TO_SET) - 1)))
fi
BROADCAST_IP=$(decimal_int_to_ip "$BROADCAST_IP_DEC")

NETWORK_INT=$(ip_to_decimal_int "$NETWORK_IP")
BROADCAST_INT=$(ip_to_decimal_int "$BROADCAST_IP")

# For /31 and /32, use all addresses (RFC 3021 for /31)
if [ "$CIDR_LENGTH" -eq 31 ]; then
  START_HOST_INT=$NETWORK_INT
  END_HOST_INT=$BROADCAST_INT
elif [ "$CIDR_LENGTH" -eq 32 ]; then
  START_HOST_INT=$NETWORK_INT
  END_HOST_INT=$NETWORK_INT
else
  START_HOST_INT=$((NETWORK_INT + 1))
  END_HOST_INT=$((BROADCAST_INT - 1))
fi

ping_available_hosts "$START_HOST_INT" "$END_HOST_INT"

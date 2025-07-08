#!/bin/bash

set -euo pipefail

# Prompt for usernames
read -p "👤 Enter usernames to delete (comma-separated): " USER_INPUT

# Split input
IFS=',' read -ra USERS <<< "$USER_INPUT"

for RAW_NAME in "${USERS[@]}"; do
  # Trim whitespace
  USERNAME="$(echo "$RAW_NAME" | xargs)"

  # Skip empty
  if [ -z "$USERNAME" ]; then
    continue
  fi

  echo "Preparing to delete: $USERNAME"

  # Check if user exists
  if ! id "$USERNAME" &>/dev/null; then
    echo " User '$USERNAME' does not exist. Skipping."
    continue
  fi

  # Confirm deletion
  read -p "Are you sure you want to delete '$USERNAME' and all their data? (y/n): " CONFIRM
  if [[ "$CONFIRM" != "y" ]]; then
    echo "⏭️ Skipping $USERNAME"
    continue
  fi

  # Kill all user processes
  pkill -u "$USERNAME" 2>/dev/null

  # Delete user with home directory
  userdel -r "$USERNAME"
  echo "Deleted user '$USERNAME' and home directory."

  # Remove from groups (should already be done by userdel)
  gpasswd -d "$USERNAME" sudo &>/dev/null

  # Cleanup: crontab, systemd remnants
  crontab -r -u "$USERNAME" 2>/dev/null
  loginctl kill-user "$USERNAME" 2>/dev/null
  loginctl terminate-user "$USERNAME" 2>/dev/null

  echo "Fully removed '$USERNAME'"
  echo "---------------------------------------"
done
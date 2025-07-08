#!/bin/bash

set -euo pipefail

echo "If you want to enter multiple users, separate input with comma (User1, User2, User3...)"
read -rp " 👤 Enter usernames: " USERS_INPUT
IFS=',' read -ra USERS <<< "$USERS_INPUT"

# Prompt for password
read -s -p "🔐 Enter password to assign to all users: " PASSWORD
echo
read -s -p "🔐 Confirm password: " PASSWORD_CONFIRM
echo

if [ "$PASSWORD" != "$PASSWORD_CONFIRM" ]; then
  echo "Passwords do not match."
  exit 1
fi


#Loop
for RAW_NAME in "${USERS[@]}"; do
    # trim whitespace
    USERNAME="$(echo "$RAW_NAME" | xargs)"

    # skip empty names
    if [ -z "$USERNAME" ]; then
        continue
    fi

    echo "Creating user: $USERNAME"

    # check if user exists
    if id "$USERNAME" &>/dev/null; then
        echo "User $USERNAME already exists. Skipping"
        continue
    fi

    useradd -m -s /bin/bash "$USERNAME"
    echo "Created user $USERNAME"

    # Set user password non-interactively
    echo "$USERNAME:$PASSWORD" | chpasswd

    # Prompt for sudo access
    read -rp "Add $USERNAME to sudo group (y/N)" ADD_SUDO
    if [[ "$ADD_SUDO" == 'y' ]]; then
        usermod -aG sudo $USERNAME
        echo "$USERNAME added to sudo group"
    fi

    echo "------------------------------------"
done

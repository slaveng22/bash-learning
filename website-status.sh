#!/bin/bash
# BASH LEARNING TASKS
# Task 9: Website status checker

WEBSITES=(
    "https://www.google.com"
    "https://www.github.com"
    "https://www.stackoverflow.com"
    "https://www.python.org"
)

LOGFILE="website_status.log"
EMAIL="nevalsgugolj@gmail.com"
FAILED_SITES=()

> "$LOGFILE"

# ping check
for SITE in "${WEBSITES[@]}"; do
    if ping -c 1 -W 1 "$SITE" &> /dev/null; then
        TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
        echo "$TIMESTAMP - $SITE is reachable" >> "$LOGFILE"
    else
        TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
        echo "$TIMESTAMP - $SITE is unreachable" >> "$LOGFILE"
        FAILED_SITES+=("$SITE")
    fi
done

# Curl check
for SITE in "${WEBSITES[@]}"; do
    STATUS=$(curl -o /dev/null -s -w "%{http_code}" "$SITE")
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

    if [ "$STATUS" -ne 200 ]; then
        echo "$TIMESTAMP - $SITE is down (HTTP status: $STATUS)" >> "$LOGFILE"
        FAILED_SITES+=("$SITE")
    else
        echo "$TIMESTAMP - $SITE is up (HTTP status: $STATUS)" >> "$LOGFILE"
    fi
done

# Email notification
if [ ${#FAILED_SITES[@]} -ne 0 ]; then
    SUBJECT="Website Status Alert: ${#FAILED_SITES[@]} sites down"
    BODY="The following websites are currently down:\n\n"
    for SITE in "${FAILED_SITES[@]}"; do
        BODY+="$SITE\n"
    done
    BODY+="\nPlease check the log file for more details: $LOGFILE"
    echo "$BODY" | mail -s "$SUBJECT" "$EMAIL"

fi
#!/bin/bash
# BASH LEARNING TASKS
# Task 9: Website status checker

WEBSITES=(
    "www.google.com"
    "www.github.com"
    "www.stackoverflow.com"
    "www.python.org"
)

LOGFILE="website_status.log"
EMAIL="nevalsgugolj@gmail.com"
FAILED_SITES=()

> "$LOGFILE"

# ping check
ping_sites() {
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
}

track_redirects() {
    local SITE=$1
    local TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$TIMESTAMP - Redirect path for $SITE:" >> "$LOGFILE"

    # Capture redirect headers
    curl -s -L -o /dev/null -w "%{url_effective}" -D - "https://$SITE" |
    grep -i "^Location:" >> "$LOGFILE"

    FINAL_URL=$(curl -s -L -o /dev/null -w "%{url_effective}" "https://$SITE")
    echo "$TIMESTAMP - Final destination: $FINAL_URL" >> "$LOGFILE"
    echo "" >> "$LOGFILE"
}

# Curl check
curl_sites() {
    for SITE in "${WEBSITES[@]}"; do
        STATUS=$(curl -L -o /dev/null -s -w "%{http_code}" "https://$SITE")
        TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

        if [[ "$STATUS" -ne 200 ]]; then
            echo "$TIMESTAMP - $SITE is down (HTTP status: $STATUS)" >> "$LOGFILE"
            FAILED_SITES+=("$SITE")
        else
            echo "$TIMESTAMP - $SITE is up (HTTP status: $STATUS)" >> "$LOGFILE"
        fi

        track_redirects "$SITE"
    done
}

# Email notification
email_notification() {
    if [ ${#FAILED_SITES[@]} -ne 0 ]; then
        SUBJECT="Website Status Alert: ${#FAILED_SITES[@]} sites down"
        BODY="The following websites are currently down:\n\n"
        for SITE in "${FAILED_SITES[@]}"; do
            BODY+="$SITE\n"
        done
        BODY+="\nPlease check the log file for more details: $LOGFILE"
        echo "$BODY" | mail -s "$SUBJECT" "$EMAIL"

    fi
}

ping_sites
curl_sites
#email_notification
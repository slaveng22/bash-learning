#!/bin/bash

PATTERNS="error|fail|crit|alert|emerg|panic"

LOGFILES=$(find /var/log -type f \( -name "*.log" -o -name "*.out" -o -name "*.log.1" \) 2>/dev/null | grep -vE "\.gz$|\.xz$")

for LOG in $LOGFILES; do
  MATCHES=$(grep -iE "$PATTERNS" "$LOG" 2>/dev/null)
  if [ -n "$MATCHES" ]; then
    echo -e "\n===== $LOG ====="
    echo "$MATCHES"
  fi
done


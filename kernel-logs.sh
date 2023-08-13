#!/bin/bash

LOGS="$HOME/kernel-logs"
DBX="$HOME/Dropbox"

DATE=$(date +%Y-%m-%dT%H-%M)
LOG_FILE="$LOGS/kernel-logs-$DATE"

mkdir -p "$LOGS"

if ! journalctl --since "1 hour ago" -k > "$LOG_FILE.txt"; then
  echo "Error :( unable to retrieve kernel logs"
  rm -f "$LOG_FILE.txt"
  exit 1
fi

mkdir -p "$LOGS/Kernel-logs"

tar -czf "$LOG_FILE.tar.bz2" -C "$LOGS" "kernel-logs-$DATE.txt"
if ! dbxcli put "$LOG_FILE.tar.bz2" "$DBX/Kernel-logs/kernel-logs-$DATE.tar.bz2"; then
  echo "Error: Unable to upload logs to Dropbox."
  rm -f "$LOG_FILE.txt" "$LOG_FILE.tar.bz2"
  exit 1
fi

# Cleaning up :)
rm -f "$LOG_FILE.txt"


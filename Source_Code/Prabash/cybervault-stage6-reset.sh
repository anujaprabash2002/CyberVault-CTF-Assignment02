#!/bin/bash

set -euo pipefail

BACKUP="/root/cybervault-stage6-backup/final_flag.txt"
TARGET="/var/lib/cybervault/.incident/response/final_flag.txt"

if [[ "$EUID" -ne 0 ]]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

if [[ ! -f "$BACKUP" ]]; then
    echo "ERROR: Backup file not found."
    exit 1
fi

if [[ ! -d "$(dirname "$TARGET")" ]]; then
    echo "ERROR: Challenge directory not found."
    exit 1
fi

install -o root -g root -m 0644 "$BACKUP" "$TARGET"

systemctl restart cv-update.service

if systemctl is-active --quiet cv-update.service; then
    echo "Stage 6 Reset: PASS"
else
    echo "Stage 6 Reset: FAIL"
    exit 1
fi

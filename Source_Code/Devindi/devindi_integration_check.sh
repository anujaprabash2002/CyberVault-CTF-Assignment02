#!/usr/bin/env bash
# CyberVault CTF - integration smoke checks for Devindi's testing component.
# Run inside the CTFd Ubuntu VM. This script does not submit flags or change challenges.
set -u

REPORT="${1:-Devindi_Integration_Test_Results.txt}"
PASS_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0

: > "$REPORT" || { echo "Cannot write report file: $REPORT" >&2; exit 2; }
exec > >(tee -a "$REPORT") 2>&1

pass() { PASS_COUNT=$((PASS_COUNT + 1)); printf 'PASS: %s\n' "$1"; }
fail() { FAIL_COUNT=$((FAIL_COUNT + 1)); printf 'FAIL: %s\n' "$1"; }
skip() { SKIP_COUNT=$((SKIP_COUNT + 1)); printf 'SKIP: %s\n' "$1"; }

printf 'CyberVault CTF - Devindi Integration Smoke Test\n'
printf 'Date: %s\n' "$(date '+%Y-%m-%d %H:%M:%S %Z')"
printf 'Host: %s\n\n' "$(hostname)"

# Test 1: Docker is accessible and running.
if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
    pass "Docker engine is accessible"
else
    fail "Docker engine is not accessible; check Docker service and permissions"
fi

# Test 2: all expected CTFd containers are currently running.
if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
    running_names="$(docker ps --format '{{.Names}}')"
    for required in ctfd-nginx-1 ctfd-ctfd-1 ctfd-db-1 ctfd-cache-1; do
        if printf '%s\n' "$running_names" | grep -Fxq "$required"; then
            pass "Container is running: $required"
        else
            fail "Expected container is not running: $required"
        fi
    done
else
    skip "Container-name checks skipped because Docker is unavailable"
fi

# Test 3: the local CTFd HTTP service responds.
if command -v curl >/dev/null 2>&1; then
    http_code="$(curl --silent --output /dev/null --write-out '%{http_code}' --max-time 8 http://localhost 2>/dev/null || true)"
    case "$http_code" in
        200|301|302) pass "CTFd HTTP endpoint responded with status $http_code" ;;
        *) fail "CTFd HTTP endpoint did not return an expected status (got: ${http_code:-no response})" ;;
    esac
else
    fail "curl is not installed; cannot check CTFd HTTP endpoint"
fi

# Optional Test 4: check SSH port 22 on the Stage 6 VM from this VM.
# Supply the current Host-Only IP as: STAGE6_IP=192.168.56.x ./devindi_integration_check.sh
if [[ -n "${STAGE6_IP:-}" ]]; then
    if command -v python3 >/dev/null 2>&1; then
        if python3 - "$STAGE6_IP" <<'PY'
import socket, sys
host = sys.argv[1]
try:
    with socket.create_connection((host, 22), timeout=3):
        print(f"SSH port 22 is reachable on {host}")
except OSError as exc:
    print(f"SSH port 22 is not reachable on {host}: {exc}")
    sys.exit(1)
PY
        then
            pass "Stage 6 SSH port 22 is reachable at $STAGE6_IP"
        else
            fail "Stage 6 SSH port 22 is not reachable at $STAGE6_IP"
        fi
    else
        skip "Python 3 is unavailable; Stage 6 SSH test was not run"
    fi
else
    skip "Stage 6 SSH check not run; set STAGE6_IP to the current authorized Host-Only IP"
fi

printf '\nSummary: %s PASS, %s FAIL, %s SKIP\n' "$PASS_COUNT" "$FAIL_COUNT" "$SKIP_COUNT"
printf 'Report saved to: %s\n' "$REPORT"

if (( FAIL_COUNT > 0 )); then
    exit 1
fi
exit 0

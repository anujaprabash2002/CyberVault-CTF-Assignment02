#!/bin/bash

echo "======================================"
echo "   CyberVault CTF Health Check"
echo "======================================"

echo
echo "[1] Checking Docker service..."

if systemctl is-active --quiet docker; then
    echo "Docker Service : PASS"
else
    echo "Docker Service : FAIL"
fi

echo
echo "[2] Checking CTFd containers..."

CTFD_CONTAINERS=$(docker ps --format "{{.Names}}" | grep "^ctfd")

if [ -n "$CTFD_CONTAINERS" ]; then
    echo "CTFd Containers : PASS"
    echo "$CTFD_CONTAINERS"
else
    echo "CTFd Containers : FAIL"
fi

echo
echo "[3] Checking CTFd web service..."

if curl -fsS --max-time 5 http://localhost > /dev/null; then
    echo "CTFd Web Service : PASS"
else
    echo "CTFd Web Service : FAIL"
fi

echo
echo "======================================"
echo "CyberVault Platform Health Check Done"
echo "======================================"
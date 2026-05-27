#!/bin/bash

# Test script: simulate pacman lock being held
# Usage: run this in one terminal, then run wait_for_pacman.sh in another

echo "Simulating pacman lock being held..."
echo "Lock will be released after 10 seconds"

PACMAN_LOCK="/var/lib/pacman/db.lck"

if [ "$EUID" -ne 0 ]; then
  echo "This script requires root privileges"
  echo "Please run with sudo"
  exit 1
fi

function lock_pacman() {
  echo "Acquiring pacman lock..."

  {
    exec 9> "$PACMAN_LOCK" 2>/dev/null

    echo "Lock acquired:"
    [ -e "$PACMAN_LOCK" ] && echo "- $PACMAN_LOCK"

    echo "Simulating a process holding the pacman lock..."
    echo "In another terminal run: sudo bash scripts/wait_for_pacman.sh"

    sleep 10

    echo "Releasing lock..."
    exec 9>&-

    echo "Lock released"
  } &

  LOCK_PID=$!
  echo "Lock holder PID: $LOCK_PID"
  echo "Press Ctrl+C to release early"
}

trap cleanup SIGINT SIGTERM

function cleanup() {
  echo "\nCleaning up..."
  if [ -n "$LOCK_PID" ] && ps -p "$LOCK_PID" > /dev/null; then
    kill "$LOCK_PID" > /dev/null 2>&1
    wait "$LOCK_PID" 2>/dev/null
  fi
  rm -f "$PACMAN_LOCK"
  echo "Test finished"
  exit 0
}

lock_pacman

wait $LOCK_PID

echo "Test complete"
exit 0

#!/bin/bash

shopt -s checkwinsize

SCRIPT_PID=$$
LOCK_FILE="/var/lib/pacman/db.lck"

clear_line() {
    printf "\r%*s\r" "${COLUMNS:-80}" ""
}

is_pacman_locked() {
    if [ -f "$LOCK_FILE" ]; then
        local pid=$(fuser "$LOCK_FILE" 2>/dev/null)
        if [ -n "$pid" ] && [ "$pid" != "$SCRIPT_PID" ]; then
            local proc_info=$(ps -o cmd= -p "$pid" 2>/dev/null)
            if [ -n "$proc_info" ]; then
                local proc_name=$(basename "$(echo "$proc_info" | awk '{print $1}')")
                printf "Lock: %s (PID: %s, Process: %s)" "$LOCK_FILE" "$pid" "$proc_name"
            else
                printf "Lock: %s (PID: %s)" "$LOCK_FILE" "$pid"
            fi
            return 0  # locked
        fi
    fi
    return 1  # not locked
}

WAIT_INTERVAL=1
MAX_WAIT=3600
start_time=$(date +%s)

if ! is_pacman_locked; then
    exit 0
fi

while true; do
    lock_info=$(is_pacman_locked)
    is_locked=$?

    if [ $is_locked -ne 0 ]; then
        break
    fi

    current_time=$(date +%s)
    elapsed=$((current_time - start_time))
    minutes=$((elapsed / 60))
    seconds=$((elapsed % 60))

    if [ $elapsed -ge $MAX_WAIT ]; then
        clear_line
        echo "Error: Timeout waiting for pacman to become available!"
        echo "Lock details: $lock_info"
        exit 1
    fi

    clear_line
    app_name="unknown"
    pid="-"

    if [ -n "$lock_info" ]; then
        if echo "$lock_info" | grep -q "Process: [^)]*" && echo "$lock_info" | grep -q "(PID: [0-9]\+"; then
            app_name=$(echo "$lock_info" | head -n 1 | grep -o "Process: [^)]*" | cut -d' ' -f2)
            pid=$(echo "$lock_info" | head -n 1 | grep -o "PID: [0-9]\+" | cut -d' ' -f2)
        elif echo "$lock_info" | grep -q "(PID: [0-9]\+"; then
            pid=$(echo "$lock_info" | head -n 1 | grep -o "PID: [0-9]\+" | cut -d' ' -f2)
        fi
    fi

    printf "pacman currently locked by \"%s\"(%s), waiting... (%d minutes %02d seconds elapsed)" "$app_name" "$pid" "$minutes" "$seconds"
    sleep $WAIT_INTERVAL
done

clear_line
echo "pacman is now available, proceeding with operations."

exit 0

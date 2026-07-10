#!/bin/bash

# ==========================================================
# Process Monitoring and Alert System
# Checks whether selected processes are running.
# If a process is stopped, the script logs the issue and
# optionally attempts to restart it using a command from
# services.conf.
# ==========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/services.conf"
LOG_DIR="$SCRIPT_DIR/logs"
LOG_FILE="$LOG_DIR/process_monitor.log"

TOTAL_CHECKED=0
RUNNING_COUNT=0
STOPPED_COUNT=0
RESTART_SUCCESS_COUNT=0
RESTART_FAILED_COUNT=0

mkdir -p "$LOG_DIR"

log_event() {
    local level="$1"
    local message="$2"
    local timestamp

    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
}

send_alert() {
    local title="$1"
    local message="$2"

    if command -v osascript >/dev/null 2>&1; then
        osascript -e "display notification \"$message\" with title \"$title\"" >/dev/null 2>&1
    elif command -v notify-send >/dev/null 2>&1; then
        notify-send "$title" "$message" >/dev/null 2>&1
    fi
}

print_header() {
    echo "=================================================="
    echo "        PROCESS MONITORING AND ALERT SYSTEM        "
    echo "=================================================="
    echo "Config file: $CONFIG_FILE"
    echo "Log file:    $LOG_FILE"
    echo "Run time:    $(date '+%Y-%m-%d %H:%M:%S')"
    echo "=================================================="
    echo
}

check_config_file() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Error: services.conf file not found."
        echo "Please create services.conf in the same folder as this script."
        log_event "ERROR" "services.conf file not found."
        exit 1
    fi
}

trim() {
    echo "$1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

is_process_running() {
    local process_pattern="$1"

    if pgrep -f "$process_pattern" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

attempt_restart() {
    local service_name="$1"
    local restart_command="$2"
    local restart_output
    local exit_code

    if [ -z "$restart_command" ]; then
        echo "  Restart command: Not provided"
        log_event "WARNING" "$service_name is stopped. No restart command provided."
        return 2
    fi

    echo "  Restart command: $restart_command"
    log_event "ACTION" "Attempting to restart $service_name using command: $restart_command"

    restart_output="$(bash -c "$restart_command" 2>&1)"
    exit_code=$?

    if [ "$exit_code" -eq 0 ]; then
        echo "  Restart status: Success"
        log_event "SUCCESS" "$service_name restarted successfully."
        return 0
    else
        echo "  Restart status: Failed"
        log_event "ERROR" "$service_name restart failed. Output: $restart_output"
        return 1
    fi
}

monitor_services() {
    while IFS='|' read -r service_name process_pattern restart_command || [ -n "$service_name" ]; do

        service_name="$(trim "$service_name")"
        process_pattern="$(trim "$process_pattern")"
        restart_command="$(trim "$restart_command")"

        if [ -z "$service_name" ] || [[ "$service_name" == \#* ]]; then
            continue
        fi

        if [ -z "$process_pattern" ]; then
            echo "Skipping $service_name because process pattern is missing."
            log_event "WARNING" "Skipping $service_name because process pattern is missing."
            continue
        fi

        TOTAL_CHECKED=$((TOTAL_CHECKED + 1))

        echo "Checking: $service_name"
        echo "  Process pattern: $process_pattern"

        if is_process_running "$process_pattern"; then
            echo "  Status: Running"
            RUNNING_COUNT=$((RUNNING_COUNT + 1))
            log_event "INFO" "$service_name is running."
        else
            echo "  Status: Stopped"
            STOPPED_COUNT=$((STOPPED_COUNT + 1))
            log_event "ALERT" "$service_name is stopped."

            send_alert "Process Alert" "$service_name is stopped."

            attempt_restart "$service_name" "$restart_command"
            restart_result=$?

            if [ "$restart_result" -eq 0 ]; then
                RESTART_SUCCESS_COUNT=$((RESTART_SUCCESS_COUNT + 1))
            elif [ "$restart_result" -eq 1 ]; then
                RESTART_FAILED_COUNT=$((RESTART_FAILED_COUNT + 1))
            fi
        fi

        echo "--------------------------------------------------"

    done < "$CONFIG_FILE"
}

print_summary() {
    echo
    echo "==================== SUMMARY ===================="
    echo "Total services checked:   $TOTAL_CHECKED"
    echo "Running services:         $RUNNING_COUNT"
    echo "Stopped services:         $STOPPED_COUNT"
    echo "Restart successes:        $RESTART_SUCCESS_COUNT"
    echo "Restart failures:         $RESTART_FAILED_COUNT"
    echo "Log file saved at:        $LOG_FILE"
    echo "================================================="
}

run_monitor_once() {
    print_header
    check_config_file
    log_event "INFO" "Process monitoring started."
    monitor_services
    print_summary
    log_event "INFO" "Process monitoring completed."
}

show_help() {
    echo "Process Monitoring and Alert System"
    echo
    echo "Usage:"
    echo "  ./process_monitor.sh                 Run one monitoring check"
    echo "  ./process_monitor.sh --monitor-once  Run one monitoring check explicitly"
    echo "  ./process_monitor.sh --help          Show this help message"
}

case "$1" in
    --monitor-once|"")
        run_monitor_once
        ;;
    --help|-h)
        show_help
        ;;
    *)
        echo "Unknown option: $1"
        echo
        show_help
        exit 1
        ;;
esac

#!/bin/bash

# ==========================================================
# Disk Usage Email Alert System
# Checks disk usage for selected mount points.
# If usage crosses the configured threshold, it logs an alert
# and optionally sends an email notification.
# ==========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/config/disk_alert.conf"
LOG_DIR="$SCRIPT_DIR/logs"
REPORT_DIR="$SCRIPT_DIR/reports"
LOG_FILE="$LOG_DIR/disk_alert.log"
LATEST_REPORT="$REPORT_DIR/latest_disk_report.txt"

mkdir -p "$LOG_DIR" "$REPORT_DIR"

THRESHOLD=90
MOUNT_POINTS="/"
EMAIL_ENABLED="no"
EMAIL_TO=""
EMAIL_SUBJECT="Disk Usage Alert"
SEND_DESKTOP_NOTIFICATION="yes"

log_event() {
    local level="$1"
    local message="$2"
    local timestamp

    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
}

pause_screen() {
    echo
    read -r -p "Press Enter to continue..."
}

print_line() {
    echo "------------------------------------------------------------"
}

show_header() {
    clear
    echo "============================================================"
    echo "              DISK USAGE EMAIL ALERT SYSTEM                 "
    echo "============================================================"
}

load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        # shellcheck source=/dev/null
        source "$CONFIG_FILE"
    else
        log_event "WARNING" "Config file not found. Using default values."
    fi
}

send_desktop_notification() {
    local title="$1"
    local message="$2"

    if [ "$SEND_DESKTOP_NOTIFICATION" != "yes" ]; then
        return
    fi

    if command -v osascript >/dev/null 2>&1; then
        osascript -e "display notification \"$message\" with title \"$title\"" >/dev/null 2>&1
    elif command -v notify-send >/dev/null 2>&1; then
        notify-send "$title" "$message" >/dev/null 2>&1
    fi
}

send_email_alert() {
    local message="$1"

    if [ "$EMAIL_ENABLED" != "yes" ]; then
        log_event "INFO" "Email alert skipped because EMAIL_ENABLED is set to no."
        return
    fi

    if [ -z "$EMAIL_TO" ]; then
        log_event "WARNING" "Email alert skipped because EMAIL_TO is empty."
        return
    fi

    if command -v mail >/dev/null 2>&1; then
        echo "$message" | mail -s "$EMAIL_SUBJECT" "$EMAIL_TO"

        if [ "$?" -eq 0 ]; then
            log_event "INFO" "Email alert sent to $EMAIL_TO."
        else
            log_event "ERROR" "Failed to send email alert using mail command."
        fi
    else
        log_event "ERROR" "mail command not found. Email alert could not be sent."
    fi
}

get_disk_usage_percent() {
    local mount_point="$1"

    df -P "$mount_point" 2>/dev/null | awk 'NR==2 {gsub("%","",$5); print $5}'
}

get_disk_usage_line() {
    local mount_point="$1"

    df -h "$mount_point" 2>/dev/null | awk 'NR==2 {print}'
}

check_single_mount() {
    local mount_point="$1"
    local usage_percent
    local usage_line
    local alert_message

    usage_percent="$(get_disk_usage_percent "$mount_point")"
    usage_line="$(get_disk_usage_line "$mount_point")"

    if [ -z "$usage_percent" ]; then
        echo "Mount point not found or unreadable: $mount_point"
        log_event "ERROR" "Mount point not found or unreadable: $mount_point"
        return
    fi

    echo "Mount Point: $mount_point"
    echo "Usage: ${usage_percent}%"
    echo "Details: $usage_line"

    if [ "$usage_percent" -ge "$THRESHOLD" ]; then
        echo "Status: ALERT - Usage is above threshold (${THRESHOLD}%)"

        alert_message="Disk usage alert: $mount_point is at ${usage_percent}% usage. Threshold is ${THRESHOLD}%."

        log_event "ALERT" "$alert_message"
        send_desktop_notification "Disk Usage Alert" "$alert_message"
        send_email_alert "$alert_message"
    else
        echo "Status: OK - Usage is below threshold (${THRESHOLD}%)"
        log_event "INFO" "$mount_point usage is ${usage_percent}%, below threshold ${THRESHOLD}%."
    fi

    print_line
}

run_disk_check() {
    load_config

    show_header
    echo "Checking disk usage..."
    echo "Threshold: ${THRESHOLD}%"
    echo "Mount points: $MOUNT_POINTS"
    echo "Run time: $(date '+%Y-%m-%d %H:%M:%S')"
    print_line

    {
        echo "============================================================"
        echo "                 DISK USAGE REPORT"
        echo "============================================================"
        echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Threshold: ${THRESHOLD}%"
        echo
    } > "$LATEST_REPORT"

    IFS=',' read -r -a mount_array <<< "$MOUNT_POINTS"

    for mount_point in "${mount_array[@]}"; do
        mount_point="$(echo "$mount_point" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

        if [ -n "$mount_point" ]; then
            check_single_mount "$mount_point" | tee -a "$LATEST_REPORT"
        fi
    done

    log_event "INFO" "Disk usage check completed."
    echo "Report saved to: $LATEST_REPORT"
}

view_latest_report() {
    show_header
    echo "Latest Disk Report"
    print_line

    if [ -f "$LATEST_REPORT" ]; then
        cat "$LATEST_REPORT"
    else
        echo "No report found yet. Run a disk check first."
    fi

    pause_screen
}

view_log_file() {
    show_header
    echo "Disk Alert Log"
    print_line

    if [ -f "$LOG_FILE" ]; then
        cat "$LOG_FILE"
    else
        echo "No log file found yet."
    fi

    pause_screen
}

change_threshold_session() {
    show_header
    echo "Change Threshold for Current Session"
    print_line

    read -r -p "Enter new threshold percentage [example: 90]: " new_threshold

    if [[ "$new_threshold" =~ ^[0-9]+$ ]] && [ "$new_threshold" -ge 1 ] && [ "$new_threshold" -le 100 ]; then
        THRESHOLD="$new_threshold"
        echo "Threshold changed to ${THRESHOLD}% for this session."
        log_event "INFO" "Threshold changed to ${THRESHOLD}% for current session."
    else
        echo "Invalid threshold. Please enter a number between 1 and 100."
    fi

    pause_screen
}

test_email_command() {
    load_config

    show_header
    echo "Test Email Command"
    print_line

    if [ "$EMAIL_ENABLED" != "yes" ]; then
        echo "EMAIL_ENABLED is set to no in config/disk_alert.conf."
        echo "Set EMAIL_ENABLED=\"yes\" and configure EMAIL_TO to test email sending."
        pause_screen
        return
    fi

    if [ -z "$EMAIL_TO" ]; then
        echo "EMAIL_TO is empty. Please configure it in config/disk_alert.conf."
        pause_screen
        return
    fi

    if ! command -v mail >/dev/null 2>&1; then
        echo "mail command is not available on this system."
        echo "On macOS, mail may need additional configuration before sending works."
        pause_screen
        return
    fi

    echo "Sending test email to: $EMAIL_TO"
    echo "This is a test email from the Disk Usage Email Alert System." | mail -s "Disk Alert Test Email" "$EMAIL_TO"

    if [ "$?" -eq 0 ]; then
        echo "Test email command completed."
        log_event "INFO" "Test email command sent to $EMAIL_TO."
    else
        echo "Test email failed."
        log_event "ERROR" "Test email failed."
    fi

    pause_screen
}

show_config() {
    load_config

    show_header
    echo "Current Configuration"
    print_line
    echo "THRESHOLD=$THRESHOLD"
    echo "MOUNT_POINTS=$MOUNT_POINTS"
    echo "EMAIL_ENABLED=$EMAIL_ENABLED"
    echo "EMAIL_TO=$EMAIL_TO"
    echo "EMAIL_SUBJECT=$EMAIL_SUBJECT"
    echo "SEND_DESKTOP_NOTIFICATION=$SEND_DESKTOP_NOTIFICATION"
    print_line
    echo "Config file: $CONFIG_FILE"

    pause_screen
}

main_menu() {
    load_config

    while true; do
        show_header
        echo "1. Run disk usage check now"
        echo "2. View latest disk report"
        echo "3. View alert log"
        echo "4. Change threshold for this session"
        echo "5. Test email command"
        echo "6. Show current configuration"
        echo "7. Exit"
        print_line

        read -r -p "Enter your choice: " choice

        case "$choice" in
            1)
                run_disk_check
                pause_screen
                ;;
            2)
                view_latest_report
                ;;
            3)
                view_log_file
                ;;
            4)
                change_threshold_session
                ;;
            5)
                test_email_command
                ;;
            6)
                show_config
                ;;
            7)
                clear
                echo "Thank you for using Disk Usage Email Alert System."
                echo "Goodbye!"
                exit 0
                ;;
            *)
                echo "Invalid choice. Please enter a number from 1 to 7."
                sleep 1
                ;;
        esac
    done
}

main_menu

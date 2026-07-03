#!/bin/bash

# ==========================================================
# System Information Module
# Displays system, user, OS, and environment details
# ==========================================================

system_basic_info() {
    show_title "SYSTEM INFO - BASIC SYSTEM DETAILS"

    echo "Operating System: $(uname -s)"
    echo "Kernel Version:   $(uname -r)"
    echo "Machine Type:     $(uname -m)"
    echo "Hostname:         $(hostname)"
    echo "Current Date:     $(date)"

    print_line

    if command_exists sw_vers; then
        sw_vers
    elif [ -f /etc/os-release ]; then
        cat /etc/os-release
    fi

    pause_screen
}

system_user_info() {
    show_title "SYSTEM INFO - USER DETAILS"

    echo "Current User:      $(whoami)"
    echo "User ID:           $(id -u)"
    echo "Group ID:          $(id -g)"
    echo "Home Directory:    $HOME"
    echo "Current Shell:     $SHELL"
    echo "Current Directory: $(pwd)"

    print_line
    echo "Logged-in users:"
    who

    pause_screen
}

system_environment_info() {
    show_title "SYSTEM INFO - ENVIRONMENT VARIABLES"

    echo "PATH:"
    echo "$PATH" | tr ':' '\n'

    print_line
    echo "Selected environment variables:"
    echo "HOME=$HOME"
    echo "SHELL=$SHELL"
    echo "USER=$USER"
    echo "PWD=$PWD"
    echo "LANG=$LANG"

    pause_screen
}

system_uptime_info() {
    show_title "SYSTEM INFO - UPTIME AND LOAD"

    uptime

    print_line

    if command_exists sysctl; then
        echo "CPU Information:"
        sysctl -n machdep.cpu.brand_string 2>/dev/null
    elif [ -f /proc/cpuinfo ]; then
        grep "model name" /proc/cpuinfo | head -1
    fi

    pause_screen
}

system_date_calendar() {
    show_title "SYSTEM INFO - DATE AND CALENDAR"

    echo "Current date and time:"
    date

    print_line
    echo "Calendar:"
    cal

    pause_screen
}

system_generate_report() {
    show_title "SYSTEM INFO - GENERATE SYSTEM REPORT"

    local script_dir
    local report_dir
    local report_file

    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    report_dir="$script_dir/reports"
    mkdir -p "$report_dir"

    report_file="$report_dir/system_info_report_$(date '+%Y%m%d_%H%M%S').txt"

    {
        echo "SYSTEM INFORMATION REPORT"
        echo "Generated: $(date)"
        echo "=================================================="
        echo
        echo "Operating System: $(uname -s)"
        echo "Kernel Version:   $(uname -r)"
        echo "Machine Type:     $(uname -m)"
        echo "Hostname:         $(hostname)"
        echo "Current User:     $(whoami)"
        echo "Home Directory:   $HOME"
        echo "Shell:            $SHELL"
        echo
        echo "Uptime:"
        uptime
        echo
        echo "Disk Usage:"
        df -h
        echo
        echo "Top Processes:"
        ps aux | sort -nrk 3 | head -10
    } > "$report_file"

    echo "Report generated:"
    echo "$report_file"

    pause_screen
}

system_info_menu() {
    while true; do
        show_title "SYSTEM INFORMATION MENU"
        echo "1. Basic system details"
        echo "2. Current user details"
        echo "3. Environment variables"
        echo "4. Uptime and CPU information"
        echo "5. Date and calendar"
        echo "6. Generate system information report"
        echo "7. Back to main menu"
        print_line

        choice="$(read_choice "Enter your choice: ")"

        case "$choice" in
            1) system_basic_info ;;
            2) system_user_info ;;
            3) system_environment_info ;;
            4) system_uptime_info ;;
            5) system_date_calendar ;;
            6) system_generate_report ;;
            7) break ;;
            *) echo "Invalid choice."; sleep 1 ;;
        esac
    done
}
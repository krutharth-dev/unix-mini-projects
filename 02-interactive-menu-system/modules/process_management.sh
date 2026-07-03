#!/bin/bash

# ==========================================================
# Process Management Module
# Provides tools to inspect and manage running processes
# ==========================================================

process_top_cpu() {
    show_title "PROCESS MANAGEMENT - TOP CPU PROCESSES"

    ps aux | sort -nrk 3 | head -15

    pause_screen
}

process_top_memory() {
    show_title "PROCESS MANAGEMENT - TOP MEMORY PROCESSES"

    ps aux | sort -nrk 4 | head -15

    pause_screen
}

process_find_by_name() {
    show_title "PROCESS MANAGEMENT - FIND PROCESS BY NAME"

    local keyword
    keyword="$(safe_path_input "Enter process name/keyword: ")"

    if [ -z "$keyword" ]; then
        echo "Keyword cannot be empty."
        pause_screen
        return
    fi

    print_line
    ps aux | grep -i "$keyword" | grep -v grep

    pause_screen
}

process_details_by_pid() {
    show_title "PROCESS MANAGEMENT - PROCESS DETAILS BY PID"

    local pid
    pid="$(safe_path_input "Enter PID: ")"

    if [ -z "$pid" ]; then
        echo "PID cannot be empty."
        pause_screen
        return
    fi

    print_line
    ps -p "$pid" -o pid,ppid,user,%cpu,%mem,etime,comm,args

    pause_screen
}

process_kill_by_pid() {
    show_title "PROCESS MANAGEMENT - KILL PROCESS BY PID"

    local pid
    pid="$(safe_path_input "Enter PID to terminate: ")"

    if [ -z "$pid" ]; then
        echo "PID cannot be empty."
        pause_screen
        return
    fi

    echo "Process details:"
    ps -p "$pid" -o pid,user,%cpu,%mem,comm,args

    print_line

    if confirm_action "Are you sure you want to terminate PID $pid?"; then
        if kill "$pid" 2>/dev/null; then
            echo "Process terminated successfully."
        else
            echo "Failed to terminate process. You may need permission or the PID may not exist."
        fi
    else
        echo "Kill cancelled."
    fi

    pause_screen
}

process_count_summary() {
    show_title "PROCESS MANAGEMENT - PROCESS COUNT SUMMARY"

    echo "Total running processes:"
    ps aux | wc -l

    print_line
    echo "Processes by current user:"
    ps -u "$(whoami)" | wc -l

    print_line
    echo "Current user's active processes:"
    ps -u "$(whoami)" | head -20

    pause_screen
}

process_menu() {
    while true; do
        show_title "PROCESS MANAGEMENT MENU"
        echo "1. Show top CPU processes"
        echo "2. Show top memory processes"
        echo "3. Find process by name"
        echo "4. Show process details by PID"
        echo "5. Kill process by PID"
        echo "6. Process count summary"
        echo "7. Back to main menu"
        print_line

        choice="$(read_choice "Enter your choice: ")"

        case "$choice" in
            1) process_top_cpu ;;
            2) process_top_memory ;;
            3) process_find_by_name ;;
            4) process_details_by_pid ;;
            5) process_kill_by_pid ;;
            6) process_count_summary ;;
            7) break ;;
            *) echo "Invalid choice."; sleep 1 ;;
        esac
    done
}
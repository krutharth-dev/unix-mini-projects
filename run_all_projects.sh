#!/bin/bash

# Unix Mini Projects - Master Launcher
# This script provides one menu to open all mini projects in this repository.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_header() {
    clear
    echo "============================================"
    echo "        UNIX MINI PROJECTS LAUNCHER"
    echo "============================================"
    echo "1. Process Monitoring and Alert System"
    echo "2. Interactive Menu-Driven Unix System"
    echo "3. Simple Backup and Restore Manager"
    echo "4. Disk Usage Email Alert System"
    echo "5. ASCII Art File Converter"
    echo "6. Exit"
    echo "============================================"
}

run_project() {
    local project_dir="$1"
    local script_name="$2"
    local full_path="$ROOT_DIR/$project_dir/$script_name"

    if [[ ! -f "$full_path" ]]; then
        echo "Error: Script not found at $full_path"
        echo "Press Enter to return to the launcher."
        read -r
        return
    fi

    echo
    echo "Launching: $project_dir/$script_name"
    echo "--------------------------------------------"
    bash "$full_path"
    echo "--------------------------------------------"
    echo "Returned to master launcher. Press Enter to continue."
    read -r
}

while true; do
    show_header
    read -rp "Enter your choice: " choice

    case "$choice" in
        1)
            run_project "01-process-monitoring-alert" "process_monitor.sh"
            ;;
        2)
            run_project "02-interactive-menu-system" "main_menu.sh"
            ;;
        3)
            run_project "03-simple-backup-restore" "backup_manager.sh"
            ;;
        4)
            run_project "04-disk-usage-email-alert" "disk_alert.sh"
            ;;
        5)
            run_project "05-ascii-art-file-converter" "ascii_converter.sh"
            ;;
        6)
            echo "Exiting Unix Mini Projects Launcher. Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select a number from 1 to 6."
            echo "Press Enter to continue."
            read -r
            ;;
    esac
done

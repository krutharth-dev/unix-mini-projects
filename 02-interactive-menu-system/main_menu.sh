#!/bin/bash

# ==========================================================
# Interactive Menu-Driven System Script
# Main menu file that loads all sub-menu modules.
# ==========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/utils/common.sh"
source "$SCRIPT_DIR/modules/file_management.sh"
source "$SCRIPT_DIR/modules/network_tools.sh"
source "$SCRIPT_DIR/modules/system_info.sh"
source "$SCRIPT_DIR/modules/process_management.sh"
source "$SCRIPT_DIR/modules/disk_memory_tools.sh"

main_menu() {
    while true; do
        show_title "MAIN MENU"
        echo "1. File Management"
        echo "2. Network Tools"
        echo "3. System Information"
        echo "4. Process Management"
        echo "5. Disk and Memory Tools"
        echo "6. Exit"
        print_line

        choice="$(read_choice "Enter your choice: ")"

        case "$choice" in
            1) file_management_menu ;;
            2) network_menu ;;
            3) system_info_menu ;;
            4) process_menu ;;
            5) disk_memory_menu ;;
            6)
                clear
                echo "Thank you for using the Interactive Unix Menu System."
                echo "Goodbye!"
                exit 0
                ;;
            *)
                echo "Invalid choice. Please enter a number from 1 to 6."
                sleep 1
                ;;
        esac
    done
}

main_menu
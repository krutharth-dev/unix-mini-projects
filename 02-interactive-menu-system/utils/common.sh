#!/bin/bash

# ==========================================================
# Common Utility Functions
# Shared helper functions for the Interactive Menu System
# ==========================================================

pause_screen() {
    echo
    read -r -p "Press Enter to continue..."
}

print_line() {
    echo "------------------------------------------------------------"
}

clear_screen() {
    clear
}

show_title() {
    clear_screen
    echo "============================================================"
    echo "                 INTERACTIVE UNIX MENU SYSTEM                "
    echo "============================================================"
    echo "$1"
    echo "============================================================"
}

read_choice() {
    local prompt="$1"
    local choice

    read -r -p "$prompt" choice
    echo "$choice"
}

confirm_action() {
    local message="$1"
    local answer

    read -r -p "$message [y/N]: " answer

    case "$answer" in
        y|Y|yes|YES)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

safe_path_input() {
    local prompt="$1"
    local path_value

    read -r -p "$prompt" path_value

    if [ -z "$path_value" ]; then
        echo ""
        return
    fi

    echo "$path_value"
}
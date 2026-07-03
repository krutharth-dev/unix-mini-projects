#!/bin/bash

# ==========================================================
# Disk and Memory Tools Module
# Provides disk usage, memory usage, and cleanup-related tools
# ==========================================================

disk_show_usage() {
    show_title "DISK AND MEMORY - DISK USAGE"

    df -h

    pause_screen
}

disk_largest_items() {
    show_title "DISK AND MEMORY - LARGEST ITEMS"

    local target_dir
    target_dir="$(safe_path_input "Enter directory path [default: current directory]: ")"

    if [ -z "$target_dir" ]; then
        target_dir="."
    fi

    if [ ! -d "$target_dir" ]; then
        echo "Directory does not exist."
        pause_screen
        return
    fi

    echo "Largest files/folders in: $target_dir"
    print_line
    du -sh "$target_dir"/* 2>/dev/null | sort -h | tail -15

    pause_screen
}

disk_memory_usage() {
    show_title "DISK AND MEMORY - MEMORY USAGE"

    if command_exists vm_stat; then
        echo "macOS Memory Statistics:"
        vm_stat
    elif command_exists free; then
        echo "Linux Memory Statistics:"
        free -h
    else
        echo "No supported memory command found."
    fi

    pause_screen
}

disk_check_folder_size() {
    show_title "DISK AND MEMORY - CHECK FOLDER SIZE"

    local target_dir
    target_dir="$(safe_path_input "Enter folder path: ")"

    if [ -z "$target_dir" ]; then
        echo "Folder path cannot be empty."
        pause_screen
        return
    fi

    if [ ! -d "$target_dir" ]; then
        echo "Folder does not exist."
        pause_screen
        return
    fi

    du -sh "$target_dir"

    pause_screen
}

disk_find_large_files() {
    show_title "DISK AND MEMORY - FIND LARGE FILES"

    local target_dir
    local size_limit

    target_dir="$(safe_path_input "Enter directory path [default: current directory]: ")"

    if [ -z "$target_dir" ]; then
        target_dir="."
    fi

    if [ ! -d "$target_dir" ]; then
        echo "Directory does not exist."
        pause_screen
        return
    fi

    size_limit="$(safe_path_input "Find files larger than how many MB? [default: 100]: ")"

    if [ -z "$size_limit" ]; then
        size_limit="100"
    fi

    echo "Files larger than ${size_limit}MB:"
    print_line
    find "$target_dir" -type f -size +"${size_limit}"M -print 2>/dev/null

    pause_screen
}

disk_cleanup_empty_files() {
    show_title "DISK AND MEMORY - FIND EMPTY FILES"

    local target_dir
    target_dir="$(safe_path_input "Enter directory path [default: current directory]: ")"

    if [ -z "$target_dir" ]; then
        target_dir="."
    fi

    if [ ! -d "$target_dir" ]; then
        echo "Directory does not exist."
        pause_screen
        return
    fi

    echo "Empty files found:"
    print_line
    find "$target_dir" -type f -empty -print 2>/dev/null

    echo
    echo "This option only lists empty files. It does not delete them."

    pause_screen
}

disk_memory_menu() {
    while true; do
        show_title "DISK AND MEMORY TOOLS MENU"
        echo "1. Show disk usage"
        echo "2. Show largest files/folders"
        echo "3. Show memory usage"
        echo "4. Check folder size"
        echo "5. Find large files"
        echo "6. Find empty files"
        echo "7. Back to main menu"
        print_line

        choice="$(read_choice "Enter your choice: ")"

        case "$choice" in
            1) disk_show_usage ;;
            2) disk_largest_items ;;
            3) disk_memory_usage ;;
            4) disk_check_folder_size ;;
            5) disk_find_large_files ;;
            6) disk_cleanup_empty_files ;;
            7) break ;;
            *) echo "Invalid choice."; sleep 1 ;;
        esac
    done
}
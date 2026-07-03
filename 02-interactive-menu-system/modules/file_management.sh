#!/bin/bash

# ==========================================================
# File Management Module
# Provides file and directory management tasks
# ==========================================================

file_list_directory() {
    show_title "FILE MANAGEMENT - LIST FILES"

    local target_dir
    target_dir="$(safe_path_input "Enter directory path [default: current directory]: ")"

    if [ -z "$target_dir" ]; then
        target_dir="."
    fi

    if [ ! -d "$target_dir" ]; then
        echo "Error: Directory does not exist."
        pause_screen
        return
    fi

    echo
    echo "Listing files in: $target_dir"
    print_line
    ls -lah "$target_dir"

    pause_screen
}

file_create_directory() {
    show_title "FILE MANAGEMENT - CREATE DIRECTORY"

    local dir_name
    dir_name="$(safe_path_input "Enter new directory name/path: ")"

    if [ -z "$dir_name" ]; then
        echo "Error: Directory name cannot be empty."
        pause_screen
        return
    fi

    if mkdir -p "$dir_name"; then
        echo "Directory created successfully: $dir_name"
    else
        echo "Failed to create directory."
    fi

    pause_screen
}

file_create_file() {
    show_title "FILE MANAGEMENT - CREATE FILE"

    local file_name
    file_name="$(safe_path_input "Enter new file name/path: ")"

    if [ -z "$file_name" ]; then
        echo "Error: File name cannot be empty."
        pause_screen
        return
    fi

    if [ -e "$file_name" ]; then
        echo "File already exists: $file_name"
    else
        if touch "$file_name"; then
            echo "File created successfully: $file_name"
        else
            echo "Failed to create file."
        fi
    fi

    pause_screen
}

file_copy_item() {
    show_title "FILE MANAGEMENT - COPY FILE/DIRECTORY"

    local source_path
    local destination_path

    source_path="$(safe_path_input "Enter source file/directory path: ")"
    destination_path="$(safe_path_input "Enter destination path: ")"

    if [ -z "$source_path" ] || [ -z "$destination_path" ]; then
        echo "Error: Source and destination cannot be empty."
        pause_screen
        return
    fi

    if [ ! -e "$source_path" ]; then
        echo "Error: Source does not exist."
        pause_screen
        return
    fi

    if cp -R "$source_path" "$destination_path"; then
        echo "Copied successfully."
    else
        echo "Copy failed."
    fi

    pause_screen
}

file_move_or_rename() {
    show_title "FILE MANAGEMENT - MOVE / RENAME"

    local source_path
    local destination_path

    source_path="$(safe_path_input "Enter current file/directory path: ")"
    destination_path="$(safe_path_input "Enter new path/name: ")"

    if [ -z "$source_path" ] || [ -z "$destination_path" ]; then
        echo "Error: Source and destination cannot be empty."
        pause_screen
        return
    fi

    if [ ! -e "$source_path" ]; then
        echo "Error: Source does not exist."
        pause_screen
        return
    fi

    if mv "$source_path" "$destination_path"; then
        echo "Moved/Renamed successfully."
    else
        echo "Move/Rename failed."
    fi

    pause_screen
}

file_delete_item() {
    show_title "FILE MANAGEMENT - DELETE FILE/DIRECTORY"

    local target_path
    target_path="$(safe_path_input "Enter file/directory path to delete: ")"

    if [ -z "$target_path" ]; then
        echo "Error: Path cannot be empty."
        pause_screen
        return
    fi

    if [ ! -e "$target_path" ]; then
        echo "Error: File or directory does not exist."
        pause_screen
        return
    fi

    echo "Target: $target_path"

    if confirm_action "Are you sure you want to delete this?"; then
        if rm -ri "$target_path"; then
            echo "Delete operation completed."
        else
            echo "Delete failed or cancelled."
        fi
    else
        echo "Delete cancelled."
    fi

    pause_screen
}

file_search_by_name() {
    show_title "FILE MANAGEMENT - SEARCH FILE BY NAME"

    local search_dir
    local search_name

    search_dir="$(safe_path_input "Enter directory to search [default: current directory]: ")"

    if [ -z "$search_dir" ]; then
        search_dir="."
    fi

    if [ ! -d "$search_dir" ]; then
        echo "Error: Directory does not exist."
        pause_screen
        return
    fi

    search_name="$(safe_path_input "Enter file name or keyword: ")"

    if [ -z "$search_name" ]; then
        echo "Error: Search keyword cannot be empty."
        pause_screen
        return
    fi

    echo
    echo "Search results:"
    print_line
    find "$search_dir" -iname "*$search_name*" 2>/dev/null

    pause_screen
}

file_management_menu() {
    while true; do
        show_title "FILE MANAGEMENT MENU"
        echo "1. List files and folders"
        echo "2. Create directory"
        echo "3. Create file"
        echo "4. Copy file or directory"
        echo "5. Move or rename file/directory"
        echo "6. Delete file or directory"
        echo "7. Search file by name"
        echo "8. Back to main menu"
        print_line

        choice="$(read_choice "Enter your choice: ")"

        case "$choice" in
            1) file_list_directory ;;
            2) file_create_directory ;;
            3) file_create_file ;;
            4) file_copy_item ;;
            5) file_move_or_rename ;;
            6) file_delete_item ;;
            7) file_search_by_name ;;
            8) break ;;
            *) echo "Invalid choice."; sleep 1 ;;
        esac
    done
}
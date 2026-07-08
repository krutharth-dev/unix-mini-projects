#!/bin/bash

# ==========================================================
# Simple Backup and Restore Manager
# A menu-driven Unix shell script for creating, listing,
# restoring, and deleting compressed backups.
# ==========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/config/backup.conf"

# Default settings. These can be overwritten in config/backup.conf.
SOURCE_DIR="$SCRIPT_DIR/sample_data"
BACKUP_DIR="$SCRIPT_DIR/backups"
RESTORE_DIR="$SCRIPT_DIR/restored_files"
LOG_DIR="$SCRIPT_DIR/logs"
MAX_BACKUPS=5

LOG_FILE="$LOG_DIR/backup_manager.log"

if [ -f "$CONFIG_FILE" ]; then
    # shellcheck source=/dev/null
    source "$CONFIG_FILE"
fi

mkdir -p "$BACKUP_DIR" "$RESTORE_DIR" "$LOG_DIR"

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

show_title() {
    clear
    echo "============================================================"
    echo "             SIMPLE BACKUP AND RESTORE MANAGER              "
    echo "============================================================"
    echo "$1"
    echo "============================================================"
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

read_non_empty() {
    local prompt="$1"
    local value

    while true; do
        read -r -p "$prompt" value
        value="$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

        if [ -n "$value" ]; then
            echo "$value"
            return
        fi

        echo "Input cannot be empty."
    done
}

validate_source_directory() {
    if [ ! -d "$SOURCE_DIR" ]; then
        echo "Configured source directory does not exist:"
        echo "$SOURCE_DIR"
        echo
        echo "Edit config/backup.conf or create the directory before running a backup."
        log_event "ERROR" "Source directory does not exist: $SOURCE_DIR"
        return 1
    fi

    return 0
}

create_backup() {
    show_title "CREATE BACKUP"

    if ! validate_source_directory; then
        pause_screen
        return
    fi

    local timestamp
    local source_name
    local backup_file

    timestamp="$(date '+%Y%m%d_%H%M%S')"
    source_name="$(basename "$SOURCE_DIR")"
    backup_file="$BACKUP_DIR/${source_name}_backup_${timestamp}.tar.gz"

    echo "Source directory: $SOURCE_DIR"
    echo "Backup location:  $backup_file"
    print_line

    if tar -czf "$backup_file" -C "$(dirname "$SOURCE_DIR")" "$source_name"; then
        echo "Backup created successfully."
        log_event "SUCCESS" "Backup created: $backup_file"
        rotate_old_backups
    else
        echo "Backup failed."
        log_event "ERROR" "Backup failed for source: $SOURCE_DIR"
    fi

    pause_screen
}

list_backups() {
    show_title "LIST BACKUPS"

    local count
    count=0

    echo "Backup directory: $BACKUP_DIR"
    print_line

    shopt -s nullglob
    local backups=("$BACKUP_DIR"/*.tar.gz)
    shopt -u nullglob

    if [ "${#backups[@]}" -eq 0 ]; then
        echo "No backups found."
        pause_screen
        return
    fi

    for backup in "${backups[@]}"; do
        count=$((count + 1))
        printf "%2d. %-45s %10s\n" "$count" "$(basename "$backup")" "$(du -h "$backup" | awk '{print $1}')"
    done

    pause_screen
}

select_backup_file() {
    shopt -s nullglob
    local backups=("$BACKUP_DIR"/*.tar.gz)
    shopt -u nullglob

    if [ "${#backups[@]}" -eq 0 ]; then
        echo "No backups available."
        return 1
    fi

    echo "Available backups:"
    print_line

    local index
    for index in "${!backups[@]}"; do
        printf "%2d. %s\n" "$((index + 1))" "$(basename "${backups[$index]}")"
    done

    echo

    local choice
    read -r -p "Select backup number: " choice

    if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
        echo "Invalid selection."
        return 1
    fi

    if [ "$choice" -lt 1 ] || [ "$choice" -gt "${#backups[@]}" ]; then
        echo "Selection out of range."
        return 1
    fi

    SELECTED_BACKUP="${backups[$((choice - 1))]}"
    return 0
}

restore_backup() {
    show_title "RESTORE BACKUP"

    local restore_target
    restore_target="$RESTORE_DIR/restore_$(date '+%Y%m%d_%H%M%S')"

    if ! select_backup_file; then
        pause_screen
        return
    fi

    mkdir -p "$restore_target"

    echo
    echo "Selected backup: $(basename "$SELECTED_BACKUP")"
    echo "Restore target:   $restore_target"
    print_line

    if confirm_action "Restore this backup?"; then
        if tar -xzf "$SELECTED_BACKUP" -C "$restore_target"; then
            echo "Backup restored successfully."
            echo "Restored files are available at:"
            echo "$restore_target"
            log_event "SUCCESS" "Backup restored: $SELECTED_BACKUP to $restore_target"
        else
            echo "Restore failed."
            log_event "ERROR" "Restore failed for: $SELECTED_BACKUP"
        fi
    else
        echo "Restore cancelled."
        log_event "INFO" "Restore cancelled for: $SELECTED_BACKUP"
    fi

    pause_screen
}

delete_backup() {
    show_title "DELETE BACKUP"

    if ! select_backup_file; then
        pause_screen
        return
    fi

    echo
    echo "Selected backup: $SELECTED_BACKUP"

    if confirm_action "Are you sure you want to delete this backup?"; then
        if rm -f "$SELECTED_BACKUP"; then
            echo "Backup deleted successfully."
            log_event "SUCCESS" "Backup deleted: $SELECTED_BACKUP"
        else
            echo "Failed to delete backup."
            log_event "ERROR" "Failed to delete backup: $SELECTED_BACKUP"
        fi
    else
        echo "Delete cancelled."
    fi

    pause_screen
}

view_log() {
    show_title "VIEW BACKUP LOG"

    if [ ! -f "$LOG_FILE" ]; then
        echo "No log file found yet."
        pause_screen
        return
    fi

    tail -50 "$LOG_FILE"
    pause_screen
}

show_configuration() {
    show_title "CURRENT CONFIGURATION"

    echo "Source directory:  $SOURCE_DIR"
    echo "Backup directory:  $BACKUP_DIR"
    echo "Restore directory: $RESTORE_DIR"
    echo "Log file:          $LOG_FILE"
    echo "Max backups kept:  $MAX_BACKUPS"
    print_line

    if [ -d "$SOURCE_DIR" ]; then
        echo "Source status:     Exists"
    else
        echo "Source status:     Missing"
    fi

    if [ -f "$CONFIG_FILE" ]; then
        echo "Config file:       $CONFIG_FILE"
    else
        echo "Config file:       Missing"
    fi

    pause_screen
}

change_source_directory() {
    show_title "CHANGE SOURCE DIRECTORY"

    local new_source
    new_source="$(read_non_empty "Enter new source directory path: ")"

    if [ ! -d "$new_source" ]; then
        echo "Directory does not exist. Source directory was not changed."
        pause_screen
        return
    fi

    SOURCE_DIR="$new_source"
    echo "Source directory changed for this session:"
    echo "$SOURCE_DIR"
    echo
    echo "To make this permanent, update config/backup.conf."
    log_event "INFO" "Source directory changed for session: $SOURCE_DIR"

    pause_screen
}

rotate_old_backups() {
    if ! [[ "$MAX_BACKUPS" =~ ^[0-9]+$ ]]; then
        return
    fi

    if [ "$MAX_BACKUPS" -le 0 ]; then
        return
    fi

    shopt -s nullglob
    local backups=("$BACKUP_DIR"/*.tar.gz)
    shopt -u nullglob

    local total
    total="${#backups[@]}"

    if [ "$total" -le "$MAX_BACKUPS" ]; then
        return
    fi

    local remove_count
    remove_count=$((total - MAX_BACKUPS))

    ls -1t "$BACKUP_DIR"/*.tar.gz 2>/dev/null | tail -n "$remove_count" | while read -r old_backup; do
        rm -f "$old_backup"
        log_event "INFO" "Old backup removed due to rotation: $old_backup"
    done
}

main_menu() {
    while true; do
        show_title "MAIN MENU"
        echo "1. Create backup"
        echo "2. List backups"
        echo "3. Restore backup"
        echo "4. Delete backup"
        echo "5. View backup log"
        echo "6. Show current configuration"
        echo "7. Change source directory for this session"
        echo "8. Exit"
        print_line

        read -r -p "Enter your choice: " choice

        case "$choice" in
            1) create_backup ;;
            2) list_backups ;;
            3) restore_backup ;;
            4) delete_backup ;;
            5) view_log ;;
            6) show_configuration ;;
            7) change_source_directory ;;
            8)
                clear
                echo "Thank you for using the Backup and Restore Manager."
                echo "Goodbye!"
                exit 0
                ;;
            *)
                echo "Invalid choice. Please enter a number from 1 to 8."
                sleep 1
                ;;
        esac
    done
}

log_event "INFO" "Backup manager started."
main_menu

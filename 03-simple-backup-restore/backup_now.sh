#!/bin/bash

# Non-interactive backup runner for cron or scheduled automation.
# This script reads the same config as backup_manager.sh and creates one backup without menu prompts.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/config/backup.conf"

SOURCE_DIR="$SCRIPT_DIR/sample_data"
BACKUP_DIR="$SCRIPT_DIR/backups"
RESTORE_DIR="$SCRIPT_DIR/restored_files"
LOG_DIR="$SCRIPT_DIR/logs"
MAX_BACKUPS=5

if [ -f "$CONFIG_FILE" ]; then
    # shellcheck source=/dev/null
    source "$CONFIG_FILE"
fi

LOG_FILE="$LOG_DIR/backup_manager.log"
mkdir -p "$BACKUP_DIR" "$RESTORE_DIR" "$LOG_DIR"

log_event() {
    local level="$1"
    local message="$2"
    local timestamp

    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
}

rotate_old_backups() {
    if ! [[ "$MAX_BACKUPS" =~ ^[0-9]+$ ]] || [ "$MAX_BACKUPS" -le 0 ]; then
        return
    fi

    shopt -s nullglob
    local backups=("$BACKUP_DIR"/*.tar.gz)
    shopt -u nullglob

    local total="${#backups[@]}"

    if [ "$total" -le "$MAX_BACKUPS" ]; then
        return
    fi

    local remove_count=$((total - MAX_BACKUPS))

    ls -1t "$BACKUP_DIR"/*.tar.gz 2>/dev/null | tail -n "$remove_count" | while read -r old_backup; do
        rm -f "$old_backup"
        log_event "INFO" "Old backup removed due to rotation: $old_backup"
    done
}

create_backup_now() {
    if [ ! -d "$SOURCE_DIR" ]; then
        echo "Error: Source directory does not exist: $SOURCE_DIR"
        log_event "ERROR" "Source directory does not exist: $SOURCE_DIR"
        exit 1
    fi

    local timestamp
    local source_name
    local backup_file

    timestamp="$(date '+%Y%m%d_%H%M%S')"
    source_name="$(basename "$SOURCE_DIR")"
    backup_file="$BACKUP_DIR/${source_name}_backup_${timestamp}.tar.gz"

    echo "Creating backup..."
    echo "Source: $SOURCE_DIR"
    echo "Output: $backup_file"

    if tar -czf "$backup_file" -C "$(dirname "$SOURCE_DIR")" "$source_name"; then
        echo "Backup created successfully."
        log_event "SUCCESS" "Non-interactive backup created: $backup_file"
        rotate_old_backups
    else
        echo "Backup failed."
        log_event "ERROR" "Non-interactive backup failed for source: $SOURCE_DIR"
        exit 1
    fi
}

show_help() {
    echo "Simple Backup Non-Interactive Runner"
    echo
    echo "Usage:"
    echo "  ./backup_now.sh          Create one backup immediately"
    echo "  ./backup_now.sh --help   Show this help message"
}

case "$1" in
    --help|-h)
        show_help
        ;;
    "")
        create_backup_now
        ;;
    *)
        echo "Unknown option: $1"
        echo
        show_help
        exit 1
        ;;
esac

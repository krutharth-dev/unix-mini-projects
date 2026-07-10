#!/bin/bash

# Unix Mini Projects - Setup Script
# This script prepares all mini project scripts for execution and checks optional tools.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

make_executable() {
    local script_path="$1"

    if [[ -f "$script_path" ]]; then
        chmod +x "$script_path"
        echo "Executable: $script_path"
    else
        echo "Missing: $script_path"
    fi
}

check_command() {
    local command_name="$1"
    local purpose="$2"

    if command -v "$command_name" >/dev/null 2>&1; then
        echo "Found: $command_name - $purpose"
    else
        echo "Optional missing: $command_name - $purpose"
    fi
}

echo "============================================"
echo "        UNIX MINI PROJECTS SETUP"
echo "============================================"
echo

echo "Setting script permissions..."
make_executable "$ROOT_DIR/run_all_projects.sh"
make_executable "$ROOT_DIR/setup_all.sh"
make_executable "$ROOT_DIR/01-process-monitoring-alert/process_monitor.sh"
make_executable "$ROOT_DIR/02-interactive-menu-system/main_menu.sh"
make_executable "$ROOT_DIR/03-simple-backup-restore/backup_manager.sh"
make_executable "$ROOT_DIR/03-simple-backup-restore/backup_now.sh"
make_executable "$ROOT_DIR/04-disk-usage-email-alert/disk_alert.sh"
make_executable "$ROOT_DIR/05-ascii-art-file-converter/ascii_converter.sh"

echo
echo "Checking optional tools..."
check_command "mail" "email alerts for disk usage monitoring"
check_command "figlet" "ASCII banner generation"
check_command "cowsay" "cowsay-style terminal messages"
check_command "shellcheck" "shell script linting"

echo
echo "Setup complete."
echo

echo "Run the master launcher with:"
echo "  ./run_all_projects.sh"
echo

echo "Cron-friendly examples:"
echo "  ./01-process-monitoring-alert/process_monitor.sh --monitor-once"
echo "  ./03-simple-backup-restore/backup_now.sh"
echo "  ./04-disk-usage-email-alert/disk_alert.sh --check-now"
echo

echo "Optional macOS installs using Homebrew:"
echo "  brew install figlet cowsay shellcheck"
echo

echo "Optional Ubuntu/Debian installs:"
echo "  sudo apt install figlet cowsay shellcheck mailutils"
echo

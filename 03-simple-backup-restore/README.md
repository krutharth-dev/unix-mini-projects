# Simple Backup and Restore Manager

A Unix shell scripting mini project that provides a menu-driven backup and restore system using compressed `.tar.gz` archives.

## Features

- Create compressed backups of a configured source directory
- List available backup archives
- Restore a selected backup into a separate restore folder
- Delete old backup archives with confirmation
- View backup logs
- Show current backup configuration
- Change the source directory for the current session
- Automatically rotate old backups using a maximum backup limit

## Project Structure

```text
03-simple-backup-restore/
├── backup_manager.sh
├── config/
│   └── backup.conf
├── backups/
│   └── .gitkeep
├── logs/
│   └── .gitkeep
├── restored_files/
│   └── .gitkeep
├── sample_data/
│   ├── notes.txt
│   └── tasks.txt
├── README.md
└── .gitignore
```

## How It Works

The script reads settings from:

```text
config/backup.conf
```

By default, it backs up the included `sample_data/` folder. Backup files are stored in:

```text
backups/
```

Restored files are extracted into:

```text
restored_files/
```

Logs are written to:

```text
logs/backup_manager.log
```

## How to Run

Give the script execution permission:

```bash
chmod +x backup_manager.sh
```

Run the program:

```bash
./backup_manager.sh
```

## Main Menu

```text
1. Create backup
2. List backups
3. Restore backup
4. Delete backup
5. View backup log
6. Show current configuration
7. Change source directory for this session
8. Exit
```

## Configuration Example

```bash
SOURCE_DIR="$SCRIPT_DIR/sample_data"
BACKUP_DIR="$SCRIPT_DIR/backups"
RESTORE_DIR="$SCRIPT_DIR/restored_files"
LOG_DIR="$SCRIPT_DIR/logs"
MAX_BACKUPS=5
```

## Purpose

This project demonstrates Unix shell scripting concepts including:

- File and directory handling
- Compression using `tar`
- Menu-driven scripting
- Backup and restore logic
- Log file management
- Configuration files
- Safe confirmation before delete/restore actions

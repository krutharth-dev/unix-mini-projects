# Unix Mini Projects

A collection of practical Unix/Linux shell scripting mini projects focused on automation, monitoring, file handling, system administration, and terminal-based utilities.

This repository is designed to demonstrate Bash scripting fundamentals through multiple small but useful command-line projects. Each mini project is placed in its own folder with its own script, configuration files, logs, sample data, and README where applicable.

---

## Repository Overview

This repository currently contains five Unix shell scripting projects and one master launcher script:

| No. | Project | Main Purpose |
|---|---|---|
| 1 | Process Monitoring and Alert System | Monitor selected processes/services and log their status |
| 2 | Interactive Menu-Driven Unix System | Provide a terminal dashboard for common system tasks |
| 3 | Simple Backup and Restore Manager | Create, list, restore, and delete compressed backups |
| 4 | Disk Usage Email Alert System | Check disk usage and generate alerts when limits are crossed |
| 5 | ASCII Art File Converter | Generate and save terminal ASCII banners/messages |
| 6 | Master Launcher | Open all mini projects from one top-level menu |

---

## Master Launcher

The repository includes a top-level launcher script:

```text
run_all_projects.sh
```

This script allows users to open any mini project from one menu.

### How to Run the Master Launcher

```bash
chmod +x run_all_projects.sh
./run_all_projects.sh
```

### Launcher Menu

```text
UNIX MINI PROJECTS LAUNCHER
1. Process Monitoring and Alert System
2. Interactive Menu-Driven Unix System
3. Simple Backup and Restore Manager
4. Disk Usage Email Alert System
5. ASCII Art File Converter
6. Exit
```

---

## Project 1: Process Monitoring and Alert System

A shell script that checks whether selected processes are running, logs their status, and optionally alerts or restarts stopped services.

### Features

- Checks whether selected processes are running
- Uses a configuration file for service/process definitions
- Logs process status with timestamps
- Alerts when a selected process is stopped
- Supports optional restart commands
- Works with macOS/Linux-style terminal commands

### Concepts Demonstrated

- Process monitoring
- Configuration-file usage
- Conditional logic
- Logging
- Basic service health checks

---

## Project 2: Interactive Menu-Driven Unix System

A modular menu-driven shell scripting project that provides a terminal-based interface for common Unix/Linux administration tasks.

### Features

- File management tools
- Network tools
- System information tools
- Process management tools
- Disk and memory tools
- Modular script structure
- Shared utility functions

### Concepts Demonstrated

- Modular Bash scripting
- Menu-driven programming
- File operations
- Process inspection
- Network commands
- System reporting

---

## Project 3: Simple Backup and Restore Manager

A Unix shell scripting project that provides a backup and restore workflow using compressed `.tar.gz` archives.

### Features

- Create compressed backups of a configured source directory
- List available backup archives
- Restore selected backups
- Delete old backups with confirmation
- View backup logs
- Change source directory for the current session
- Automatically rotate old backups based on a maximum backup limit

### Concepts Demonstrated

- File and directory handling
- Compression using `tar`
- Backup and restore logic
- Log file management
- Configuration files
- Safe confirmation before destructive actions

---

## Project 4: Disk Usage Email Alert System

A shell script that monitors disk usage and generates an alert when usage crosses a configured threshold.

### Features

- Check disk usage for selected mount points
- Custom threshold configuration
- Save timestamped log messages
- Generate disk usage reports
- Optional desktop notifications
- Optional email alerts using the `mail` command
- Menu-driven interface

### Concepts Demonstrated

- Disk monitoring with `df`
- Alert logic
- Report generation
- Logging
- Config-file driven scripting
- Optional email notification workflow

---

## Project 5: ASCII Art File Converter

A terminal utility that generates ASCII art banners and fun command-line messages using tools such as `figlet` and `cowsay`, with fallback formatting when those tools are not installed.

### Features

- Generate ASCII banners from user input
- Generate cowsay-style terminal messages
- Convert a text file into multiple ASCII banners
- Save generated banners into output files
- Preview output files from the terminal
- Check whether optional tools are installed
- Fallback formatting if optional tools are missing

### Concepts Demonstrated

- File input/output
- External command usage
- Tool availability checks
- Fallback logic
- Menu-driven scripting
- Terminal-based creativity

---

## Technologies Used

- Bash scripting
- Unix/Linux terminal commands
- Process monitoring commands
- File and directory operations
- Logging
- Configuration files
- `tar` compression
- `df` disk usage monitoring
- Optional `mail`, `figlet`, and `cowsay` commands

---

## Repository Structure

```text
Unix Mini Projects/
├── 01-process-monitoring-alert/
│   ├── process_monitor.sh
│   ├── services.conf
│   ├── README.md
│   └── logs/
├── 02-interactive-menu-system/
│   ├── main_menu.sh
│   ├── modules/
│   ├── utils/
│   ├── reports/
│   └── README.md
├── 03-simple-backup-restore/
│   ├── backup_manager.sh
│   ├── config/
│   ├── backups/
│   ├── logs/
│   ├── restored_files/
│   ├── sample_data/
│   └── README.md
├── 04-disk-usage-email-alert/
│   ├── disk_alert.sh
│   ├── config/
│   ├── logs/
│   ├── reports/
│   └── README.md
├── 05-ascii-art-file-converter/
│   ├── ascii_converter.sh
│   ├── config/
│   ├── outputs/
│   ├── sample_inputs/
│   └── README.md
├── run_all_projects.sh
├── README.md
├── UPGRADE_PLAN.md
└── .gitignore
```

---

## How to Run a Specific Project

Navigate into the required project folder:

```bash
cd 03-simple-backup-restore
```

Give execution permission to the main script:

```bash
chmod +x backup_manager.sh
```

Run the script:

```bash
./backup_manager.sh
```

The exact script name differs for each mini project. Check the project-specific README inside each folder.

---

## Suggested Demo Order

For a portfolio or viva demonstration, the best order is:

1. Run `run_all_projects.sh` to show the master launcher.
2. Run the Interactive Menu-Driven Unix System to demonstrate breadth.
3. Run the Backup and Restore Manager to show practical automation.
4. Run the Disk Usage Alert System to show monitoring and alerts.
5. Show Process Monitoring to demonstrate system administration logic.
6. End with ASCII Art Converter as a lighter utility project.

---

## Why This Repository Is Useful

This repository demonstrates practical Unix/Linux scripting ability through multiple focused mini projects rather than a single isolated script. It shows how Bash can be used for real tasks such as monitoring, backup automation, disk usage checks, system reports, and terminal utilities.

It is useful for demonstrating:

- Unix/Linux command-line skills
- Bash scripting fundamentals
- Automation workflows
- System monitoring
- File processing
- Modular scripting
- Practical problem-solving

---

## Limitations

- Projects are terminal-based and do not include graphical interfaces.
- Some commands may behave differently between macOS and Linux.
- Email alert functionality may require system mail configuration.
- The scripts are educational and should be tested carefully before being used on important production systems.

---

## Future Enhancements

- Add screenshots or terminal demo GIFs for every project.
- Add automated test scripts.
- Add installation/setup script for all projects.
- Add cross-platform compatibility notes for macOS and Linux.
- Add cron-job setup examples for monitoring and backup scripts.
- Add logging level support such as INFO, WARNING, and ERROR.
- Add CSV/HTML report export for monitoring tools.

---

## Resume Summary

Created a collection of Unix shell scripting projects including process monitoring, menu-driven system administration, backup and restore automation, disk usage alerts, ASCII art file conversion, and a master launcher using Bash, configuration files, logging, terminal commands, and practical automation workflows.

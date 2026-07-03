# Interactive Menu-Driven Unix System

A modular Unix shell scripting project that provides a user-friendly terminal menu for performing common system administration tasks.

This project is divided into multiple shell script files. Each main menu category has its own module file, making the project cleaner, more organised, and easier to maintain.

## Features

### 1. File Management

- List files and folders
- Create directories
- Create files
- Copy files or directories
- Move or rename files/directories
- Delete files/directories with confirmation
- Search files by name

### 2. Network Tools

- Ping a host
- Show IP/network information
- DNS lookup
- Trace route
- Check open ports
- Check website response headers

### 3. System Information

- View basic system details
- View current user details
- View environment variables
- View uptime and CPU information
- Show date and calendar
- Generate a system information report

### 4. Process Management

- Show top CPU processes
- Show top memory processes
- Find process by name
- Show process details by PID
- Kill process by PID with confirmation
- Show process count summary

### 5. Disk and Memory Tools

- Show disk usage
- Show largest files/folders
- Show memory usage
- Check folder size
- Find large files
- Find empty files

## Project Structure

```text
02-interactive-menu-system/
├── main_menu.sh
├── modules/
│   ├── file_management.sh
│   ├── network_tools.sh
│   ├── system_info.sh
│   ├── process_management.sh
│   └── disk_memory_tools.sh
├── utils/
│   └── common.sh
├── reports/
│   └── .gitkeep
└── README.md
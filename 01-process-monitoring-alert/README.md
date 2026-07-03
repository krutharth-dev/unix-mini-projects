# Process Monitoring and Alert System

A Unix shell script that monitors selected processes or services, logs their status, and optionally attempts to restart stopped services.

## Features

- Checks whether selected processes are running
- Logs process status with timestamps
- Alerts when a process is stopped
- Supports optional restart commands
- Works with macOS and Linux-style service commands
- Uses a simple configuration file

## Project Structure

```text
01-process-monitoring-alert/
├── process_monitor.sh
├── services.conf
├── README.md
└── logs/
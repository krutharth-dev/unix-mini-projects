# Disk Usage Email Alert System

A Unix shell scripting project that monitors disk usage and sends an alert when disk usage crosses a configured threshold.

This project is useful for basic system administration and monitoring tasks. It checks selected mount points, logs disk usage status, generates reports, and optionally sends email alerts.

## Features

- Check disk usage for selected mount points
- Custom threshold configuration
- Alert when usage exceeds the threshold
- Save timestamped log messages
- Generate latest disk usage report
- Optional desktop notification
- Optional email alert using the `mail` command
- Menu-driven interface

## Project Structure

```text
04-disk-usage-email-alert/
├── disk_alert.sh
├── config/
│   └── disk_alert.conf
├── logs/
│   └── .gitkeep
├── reports/
│   └── .gitkeep
├── README.md
└── .gitignore
```

## Configuration

Edit the file:

```bash
config/disk_alert.conf
```

Example configuration:

```bash
THRESHOLD=90
MOUNT_POINTS="/"
EMAIL_ENABLED="no"
EMAIL_TO="your_email@example.com"
EMAIL_SUBJECT="Disk Usage Alert"
SEND_DESKTOP_NOTIFICATION="yes"
```

## How to Run

Give permission to the script:

```bash
chmod +x disk_alert.sh
```

Run the script:

```bash
./disk_alert.sh
```

## Menu Options

```text
1. Run disk usage check now
2. View latest disk report
3. View alert log
4. Change threshold for this session
5. Test email command
6. Show current configuration
7. Exit
```

## Email Alert Note

The script can send emails using the `mail` command. On many systems, email sending requires extra configuration.

For easy testing, keep:

```bash
EMAIL_ENABLED="no"
```

The script will still log alerts and show desktop notifications.

## Example Output

```text
Mount Point: /
Usage: 62%
Details: /dev/disk3s1s1  460Gi   12Gi  120Gi    10%    /
Status: OK - Usage is below threshold (90%)
```

## Purpose

This project demonstrates:

- Unix shell scripting
- Disk monitoring with `df`
- Config-file usage
- Conditional alert logic
- Logging
- Report generation
- Optional email notifications

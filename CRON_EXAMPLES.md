# Cron Automation Examples

This document shows how some of the Unix mini projects can be scheduled automatically using cron.

Cron is useful for running scripts at fixed intervals, such as every day, every hour, or every week.

---

## Before Using Cron

Run the setup script first:

```bash
chmod +x setup_all.sh
./setup_all.sh
```

Use the full absolute path to scripts when adding cron jobs.

To find the absolute path of the repository, run:

```bash
pwd
```

To edit cron jobs:

```bash
crontab -e
```

To list existing cron jobs:

```bash
crontab -l
```

---

## Cron-Friendly Commands

The repository now includes non-interactive commands that are better for cron:

```bash
./01-process-monitoring-alert/process_monitor.sh --monitor-once
./03-simple-backup-restore/backup_now.sh
./04-disk-usage-email-alert/disk_alert.sh --check-now
```

---

## Example 1: Run Disk Usage Check Every Hour

```cron
0 * * * * /absolute/path/to/unix-mini-projects/04-disk-usage-email-alert/disk_alert.sh --check-now
```

This checks disk usage once every hour without opening the interactive menu.

---

## Example 2: Run Disk Usage Check Every Day at 9 AM

```cron
0 9 * * * /absolute/path/to/unix-mini-projects/04-disk-usage-email-alert/disk_alert.sh --check-now
```

---

## Example 3: Run Backup Every Day at 10 PM

```cron
0 22 * * * /absolute/path/to/unix-mini-projects/03-simple-backup-restore/backup_now.sh
```

This creates a backup without opening the interactive backup manager menu.

---

## Example 4: Run Process Monitoring Every 15 Minutes

```cron
*/15 * * * * /absolute/path/to/unix-mini-projects/01-process-monitoring-alert/process_monitor.sh --monitor-once
```

---

## Example 5: Save Cron Output to a Log File

```cron
0 * * * * /absolute/path/to/unix-mini-projects/04-disk-usage-email-alert/disk_alert.sh --check-now >> /absolute/path/to/unix-mini-projects/cron.log 2>&1
```

This saves both normal output and error output to `cron.log`.

---

## Example 6: View Latest Disk Report from Terminal

```bash
./04-disk-usage-email-alert/disk_alert.sh --view-report
```

This prints the latest generated disk report without opening the menu.

---

## macOS Note

On macOS, cron may require extra permissions depending on the folders being accessed. If a script does not run through cron but works manually, check:

- Full disk access permissions
- Absolute file paths
- Script execute permissions
- Environment variables

---

## Linux Note

On Linux, make sure the required packages are installed. For email alerts, install and configure a mail utility such as:

```bash
sudo apt install mailutils
```

---

## Future Improvement

The next upgrade would be to add more command-line options, for example:

```bash
./backup_now.sh --source /path/to/source --output /path/to/backups
./disk_alert.sh --check-now --threshold 85
./process_monitor.sh --monitor-once --no-restart
```

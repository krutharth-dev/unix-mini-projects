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

## Example 1: Run Disk Usage Check Every Hour

```cron
0 * * * * /absolute/path/to/unix-mini-projects/04-disk-usage-email-alert/disk_alert.sh
```

This checks disk usage once every hour.

---

## Example 2: Run Disk Usage Check Every Day at 9 AM

```cron
0 9 * * * /absolute/path/to/unix-mini-projects/04-disk-usage-email-alert/disk_alert.sh
```

---

## Example 3: Run Backup Every Day at 10 PM

```cron
0 22 * * * /absolute/path/to/unix-mini-projects/03-simple-backup-restore/backup_manager.sh
```

Note: The backup manager is menu-driven. For fully automated backups, a future version can add a non-interactive mode such as:

```bash
./backup_manager.sh --backup-now
```

---

## Example 4: Run Process Monitoring Every 15 Minutes

```cron
*/15 * * * * /absolute/path/to/unix-mini-projects/01-process-monitoring-alert/process_monitor.sh
```

---

## Example 5: Save Cron Output to a Log File

```cron
0 * * * * /absolute/path/to/unix-mini-projects/04-disk-usage-email-alert/disk_alert.sh >> /absolute/path/to/unix-mini-projects/cron.log 2>&1
```

This saves both normal output and error output to `cron.log`.

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

The best next upgrade is to add non-interactive command-line modes to scripts, for example:

```bash
./disk_alert.sh --check-now
./backup_manager.sh --backup-now
./process_monitor.sh --monitor-once
```

This would make the scripts more cron-friendly and closer to real automation tooling.

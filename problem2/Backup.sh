#!/bin/bash

# Configuration
SOURCE_DIR="/path/to/local/directory" #local loctaion
REMOTE_USER="remote_user"
REMOTE_HOST="172.31.33.59" #server ip
REMOTE_DIR="/path/to/remote/directory" #remote loaction
LOG_FILE="/var/log/backup.log" #log file to be copied
REPORT_FILE="/var/log/backup_report.txt"
DATE=$(date +'%Y-%m-%d %H:%M:%S')

# Function to log messages
log_message() {
    local message="$1"
    echo "$DATE - $message" | tee -a "$LOG_FILE"
}

# Function to perform the backup
perform_backup() {
    # Perform the rsync operation
    rsync -avz --delete "$SOURCE_DIR" "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}" >> "$LOG_FILE" 2>&1
}

# Main backup function
backup() {
    log_message "Starting backup operation..."

    if perform_backup; then
        log_message "Backup completed successfully."
        echo "Backup Report: SUCCESS" > "$REPORT_FILE"
        echo "Backup completed successfully at $DATE" >> "$REPORT_FILE"
    else
        log_message "Backup failed."
        echo "Backup Report: FAILURE" > "$REPORT_FILE"
        echo "Backup failed at $DATE" >> "$REPORT_FILE"
    fi

    log_message "Backup operation completed."
}

# Run the backup
backup

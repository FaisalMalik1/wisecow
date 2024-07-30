#!/bin/bash

# Definning thresholds for alert
CPU_THRESHOLD=80   # 80% CPU usage
MEM_THRESHOLD=80   # 80% Memory usage
DISK_THRESHOLD=80  # 80% Disk usage
PROC_THRESHOLD=300 # 300 running processes

# Log file path
LOG_FILE="/var/log/system_health.log"

# Function to log messages
log_message() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" | tee -a "$LOG_FILE"
}

# Check CPU usage
check_cpu_usage() {
    local cpu_usage=$(top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    local cpu_int=${cpu_usage%.*} # Convert to integer for comparison
    if (( cpu_int > CPU_THRESHOLD )); then
        log_message "ALERT: CPU usage is at ${cpu_usage}%"
    else
        log_message "CPU usage is at ${cpu_usage}%"
    fi
}

# Check Memory usage
check_memory_usage() {
    local mem_usage=$(free | awk '/Mem/ {printf("%.0f"), $3/$2 * 100.0}')
    if (( mem_usage > MEM_THRESHOLD )); then
        log_message "ALERT: Memory usage is at ${mem_usage}%"
    else
        log_message "Memory usage is at ${mem_usage}%"
    fi
}

# Check Disk usage
check_disk_usage() {
    while IFS= read -r line; do
        local disk_usage=$(echo "$line" | awk '{print $5}' | sed 's/%//')
        local mount_point=$(echo "$line" | awk '{print $6}')
        if (( disk_usage > DISK_THRESHOLD )); then
            log_message "ALERT: Disk usage on $mount_point is at ${disk_usage}%"
        else
            log_message "Disk usage on $mount_point is at ${disk_usage}%"
        fi
    done < <(df -h | grep -vE '^Filesystem|tmpfs|cdrom')
}

# Check running processes
check_running_processes() {
    local proc_count=$(ps aux --no-heading | wc -l)
    if (( proc_count > PROC_THRESHOLD )); then
        log_message "ALERT: Running processes count is ${proc_count}"
    else
        log_message "Running processes count is ${proc_count}"
    fi
}

# Main function to run all checks
main() {
    log_message "Starting system health check..."
    check_cpu_usage
    check_memory_usage
    check_disk_usage
    check_running_processes
    log_message "System health check completed."
}

# Run the main function
main

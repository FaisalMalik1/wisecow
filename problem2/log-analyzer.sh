#!/bin/bash

# Path to the web server log file
LOG_FILE="/var/log/apache2/access.log"

# Check the log file exists
if [[ ! -f "$LOG_FILE" ]]; then
    echo "Log file not found: $LOG_FILE"
    exit 1
fi

# Define the output report file
REPORT_FILE="/var/log/log_analysis_report.txt"
DATE=$(date +'%Y-%m-%d %H:%M:%S')

# Function to calculate the number of 404 errors
calculate_404_errors() {
    local count=$(grep "404" "$LOG_FILE" | wc -l)
    echo "Number of 404 errors: $count"
}

# Function to find the most requested pages
most_requested_pages() {
    local pages=$(awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -10)
    echo "Most requested pages:"
    echo "$pages"
}

# Function to find IP addresses with the most requests
top_ip_addresses() {
    local ips=$(awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -10)
    echo "IP addresses with the most requests:"
    echo "$ips"
}

# Function to generate a summarized report
generate_report() {
    {
        echo "Log Analysis Report"
        echo "Date: $DATE"
        echo "=============================="
        calculate_404_errors
        echo
        most_requested_pages
        echo
        top_ip_addresses
        echo
    } > "$REPORT_FILE"
}

# Run the analysis and generate the report
generate_report

echo "Log analysis complete. Report saved to $REPORT_FILE"

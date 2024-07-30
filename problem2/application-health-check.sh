#!/bin/bash

# Configuration
URL="http://your-application-url.com"  # Replace with your application's URL
EXPECTED_STATUS_CODE=200               # Expected HTTP status code for a healthy application
CHECK_INTERVAL=60                      # Interval between checks in seconds
LOG_FILE="application_health.log"      # Log file for recording application status

# Variables for uptime calculation
last_up_time=$(date +%s)               # Timestamp of the last successful check
up_time_duration=0                     # Duration in seconds the app has been up

# Function to convert seconds to human-readable format
convert_seconds_to_human_readable() {
    local seconds=$1
    printf '%02dh:%02dm:%02ds\n' $(($seconds/3600)) $(($seconds%3600/60)) $(($seconds%60))
}

# Function to check application status
check_application() {
    # Perform an HTTP request using curl
    HTTP_RESPONSE=$(curl --write-out "%{http_code}" --silent --output /dev/null "$URL")

    # Check if the HTTP response matches the expected status code
    if [[ "$HTTP_RESPONSE" -eq "$EXPECTED_STATUS_CODE" ]]; then
        current_time=$(date +%s)
        up_time_duration=$(($current_time - $last_up_time))
        human_readable_uptime=$(convert_seconds_to_human_readable $up_time_duration)

        echo "$(date): Application is UP. HTTP Status Code: $HTTP_RESPONSE. Uptime: $human_readable_uptime" | tee -a "$LOG_FILE"
    else
        last_up_time=$(date +%s)  # Reset last up time
        up_time_duration=0        # Reset uptime duration

        echo "$(date): Application is DOWN. HTTP Status Code: $HTTP_RESPONSE" | tee -a "$LOG_FILE"
    fi
}

# Main loop for continuous monitoring
while true; do
    check_application
    sleep "$CHECK_INTERVAL"
done

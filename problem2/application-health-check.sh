#!/bin/bash

# Configuration
URL="http://your-application-url.com"  # Replace with your application's URL
EXPECTED_STATUS_CODE=200               # Expected HTTP status code for a healthy application
CHECK_INTERVAL=60                      # Interval between checks in seconds
LOG_FILE="application_health.log"      # Log file for recording application status

# Function to check application status
check_application() {
    # Perform an HTTP request using curl
    HTTP_RESPONSE=$(curl --write-out "%{http_code}" --silent --output /dev/null "$URL")

    # Check if the HTTP response matches the expected status code
    if [[ "$HTTP_RESPONSE" -eq "$EXPECTED_STATUS_CODE" ]]; then
        echo "$(date): Application is UP. HTTP Status Code: $HTTP_RESPONSE" | tee -a "$LOG_FILE"
    else
        echo "$(date): Application is DOWN. HTTP Status Code: $HTTP_RESPONSE" | tee -a "$LOG_FILE"
    fi
}

# Main loop for continuous monitoring
while true; do
    check_application
    sleep "$CHECK_INTERVAL"
done

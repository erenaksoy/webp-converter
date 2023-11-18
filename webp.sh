#!/bin/bash

# WebP Converter Bash Script
# Author: Eren Aksoy
# GitHub Repository: https://github.com/erenaksoy/webp-converter

# Read settings from the configuration file
source "config.txt"

# Check if re-generating all WebP files
if [ "$generateall" -eq 1 ]; then
    echo "Re-generating all WebP files..."
else
    echo "Generating missing WebP files..."
fi

# Initialize counters
processed=0
skipped=0

# Function to create a new debug file
create_debug_file() {
    timestamp=$(date +"%Y%m%d_%s")
    debug_file="${log_dir}/debug_${timestamp}_${$}.log"
    echo "Creating new debug file: ${debug_file}"
    touch "${debug_file}"
    echo "Script started." >> "${debug_file}"
}

# Function to get the last debug timestamp or 0 if the file doesn't exist or is empty
get_last_debug_timestamp() {
    local last_timestamp
    last_timestamp=$(date -d "$(stat -c %y "${debug_file}" 2>/dev/null)" +"%s" 2>/dev/null)
    if [ -z "${last_timestamp}" ]; then
        last_timestamp=0
    fi
    echo "${last_timestamp}"
}

# Function to delete old debug files
delete_old_debug_files() {
    find "${log_dir}" -name 'debug_*.log' -mtime +${debug_interval_hours} -exec rm {} \;
}

# Function to log messages
log() {
    local message="$1"
    echo "$(date +"%Y-%m-%d %T") $message" >> "${debug_file}"
}

# Function to calculate time elapsed
calculate_time_elapsed() {
    end_time=$(date +"%s")
    elapsed_seconds=$((end_time - start_time))
    elapsed_formatted=$(date -u -d @"$elapsed_seconds" +"%T")
}

# Function to calculate speed
calculate_speed() {
    total_files=$((processed + skipped))
    if [ "$total_files" -eq 0 ]; then
        speed="N/A (total files is 0)"
    else
        speed=$(bc <<< "scale=2; $total_files / $elapsed_seconds")
    fi
}

# Set the interval in seconds
interval_seconds=$((debug_interval_hours * 3600))

# Create a new debug file or use the existing one if it's within the interval
current_timestamp=$(date +"%s")
last_debug_timestamp=$(get_last_debug_timestamp)

if [ $((current_timestamp - last_debug_timestamp)) -ge $interval_seconds ]; then
    create_debug_file
else
    debug_file="${log_dir}/debug_$(date -d "@${last_debug_timestamp}" +"%Y%m%d_%s")_${$}.log"
fi

# Log the script start
log "Script started."

# Process files
start_time=$(date +"%s")
while IFS= read -r -d $'\0' file; do
    webp_file="${file%.*}.webp"
    if [ "$generateall" -eq 1 ] || [ ! -f "$webp_file" ]; then
        log "Converting \"$file\" to \"$webp_file\""
        cwebp -q "${quality}" "$file" -o "$webp_file"
        ((processed++))
    else
        log "Skipping \"$file\" (WebP version already exists)"
        ((skipped++))
    fi
done < <(find "${directory}" -type f \( -name "*.jpg" -o -name "*.png" \) -print0)

# Calculate final time elapsed and speed
calculate_time_elapsed
calculate_speed

# Log the script completion
log "Script completed."
log "Total processed: $processed files"
log "Total skipped: $skipped files"
log "Time Elapsed: $elapsed_seconds seconds"
log "Speed: $speed seconds/file"

# Delete old debug files
delete_old_debug_files

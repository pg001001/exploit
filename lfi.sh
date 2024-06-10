#!/bin/bash

# Function to perform LFI testing for given URLs
lfi_testing() {
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


    # Perform Directory transversal testing and save the results

    echo "Performing LFI testing on ${input_file}..."
    cd /root/tool/dotdotpwn

    while read -r url; do
        dotdotpwn -m http -h "$url" -o "${exploit_dir}/directory_transversal_exploit.txt"
    done 

    cd /root/web-recon

    echo ".........................................................................................................................."

    # Perform LFI testing and save the results
    cd /root/tool/liffy
    python3 -m venv liffy
    source liffy/bin/activate

    echo "Performing LFI testing on ${input_file}..."
    while read -r url; do
        python3 liffy.py -u "$target_url" -o "${exploit_dir}/lfi_exploit.txt"
    done 

    deactivate
    
    cd /root/web-recon

    echo "Script execution completed"
}

# Check if input file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Run the LFI testing function with the provided input file
lfi_testing "$1"

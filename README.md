# Bug Bounty Automation Scripts

## Overview

This repository contains a set of automated scripts designed to perform various penetration testing tasks on a given domain. The tasks include subdomain enumeration, URL enumeration, JavaScript file analysis, and port scanning.

## Tools Used

- **Subdomain Enumeration**:
  - Subfinder
  - Sublist3r
  - Amass
  - Crt.sh
  - Findomain
  - Assetfinder
  - Gobuster

- **URL Enumeration**:
  - gau 
  - katana
  - waymore
  - httpx
  - gf
  - paramspider

- **JavaScript File Analysis**:
  - Katana
  - httpx
  - Nuclei (for scanning JavaScript files for sensitive information)

- **Port Scanning**:
  - Naabu
  - Nmap
 
- **xss**:
  - freq
  - qrsreplace

 **Test**: Run it on debian linux os (tested) (after running installation script restart the os for all tools to run properly)
 
## Installation

To set up the environment and install all the required tools, run the `install.sh` script:

```bash
git clone https://github.com/pg001001/main.git
cd main
chmod +x install.sh
./install.sh

## Usage 
Then, you can use the main.sh script to run all tasks sequentially for a given domain:

chmod +x main.sh
./main.sh <domain>


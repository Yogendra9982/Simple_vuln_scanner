# 🛡️ Mini Vulnerability Scanner

A lightweight Bash-based vulnerability scanner that performs basic security checks on a target IP address or domain and generates a report of the findings.

## Features

* Common port scanning
* Server header detection
* Security header analysis
* HTTPS availability check
* Automatic report generation

## Requirements

* Linux, Unix, or macOS
* Bash Shell
* curl

## Installation

```bash
git clone https://github.com/yourusername/Simple_vuln_scanner.git
cd Simple_vuln_scanner
chmod +x simple_vuln_scanner.sh
```

## Usage

```bash
./simple_vuln_scanner.sh
```

Enter the target IP address or domain when prompted.

## Example Output

```text
[OPEN] Port 80
[OPEN] Port 443

Server: nginx

[OK] X-Frame-Options Found
[WARNING] Missing Content-Security-Policy

[OK] HTTPS Enabled
```

## Disclaimer

This tool is intended for educational purposes and authorized security testing only.

## Author

**Yogendra Samriya**

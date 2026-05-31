#!/bin/bash

# ==========================================
# MINI VULNERABILITY SCANNER
# ==========================================

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"

report="vulnerability_report.txt"

echo -e "${CYAN}"
echo "=================================="
echo "   MINI VULNERABILITY SCANNER"
echo "=================================="
echo -e "${RESET}"

read -p "Enter Target IP or Domain: " target

echo "Generating report..." > "$report"
echo "Target: $target" >> "$report"
echo "Date: $(date)" >> "$report"
echo "--------------------------------" >> "$report"

# ==========================================
# OPEN PORT SCAN
# ==========================================

echo
echo -e "${CYAN}[+] Checking Common Ports${RESET}"

ports=(21 22 23 25 53 80 110 143 443 445 3306 3389)

for port in "${ports[@]}"
do
    timeout 1 bash -c "echo >/dev/tcp/$target/$port" 2>/dev/null

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[OPEN] Port $port${RESET}"
        echo "[OPEN] Port $port" >> "$report"
    fi
done

# ==========================================
# SERVER HEADER CHECK
# ==========================================

echo
echo -e "${CYAN}[+] Checking Server Information${RESET}"

server=$(curl -sI http://$target | grep -i Server)

if [ -n "$server" ]; then
    echo "$server"
    echo "$server" >> "$report"
else
    echo "Server information not found"
fi

# ==========================================
# SECURITY HEADERS CHECK
# ==========================================

echo
echo -e "${CYAN}[+] Checking Security Headers${RESET}"

headers=$(curl -sI http://$target)

security_headers=(
"X-Frame-Options"
"Content-Security-Policy"
"Strict-Transport-Security"
"X-Content-Type-Options"
)

for header in "${security_headers[@]}"
do
    echo "$headers" | grep -iq "$header"

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[OK] $header Found${RESET}"
    else
        echo -e "${YELLOW}[WARNING] Missing $header${RESET}"
        echo "[WARNING] Missing $header" >> "$report"
    fi
done

# ==========================================
# HTTPS CHECK
# ==========================================

echo
echo -e "${CYAN}[+] Checking HTTPS${RESET}"

curl -sI https://$target >/dev/null 2>&1

if [ $? -eq 0 ]; then
    echo -e "${GREEN}[OK] HTTPS Enabled${RESET}"
else
    echo -e "${YELLOW}[WARNING] HTTPS Not Enabled${RESET}"
    echo "[WARNING] HTTPS Not Enabled" >> "$report"
fi

# ==========================================
# REPORT COMPLETE
# ==========================================

echo
echo -e "${GREEN}[+] Scan Completed${RESET}"
echo -e "${GREEN}[+] Report Saved: $report${RESET}"

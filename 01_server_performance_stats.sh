#!/bin/bash

echo "================ Server Performance Stats ================"
echo "Hostname: $(hostname)"
echo "OS Version: $(lsb_release -d 2>/dev/null || cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d \")"
echo "Uptime: $(uptime -p)"
echo "---------------------------------------------------------"

# CPU Usage
echo "🔹 Total CPU Usage:"
top -bn1 | grep "Cpu(s)" | awk '{print "User: " $2 "%, System: " $4 "%, Idle: " $8 "%"}'

# Memory Usage
echo "🔹 Memory Usage:"
free -m | awk 'NR==2{printf "Total: %s MB | Used: %s MB | Free: %s MB | Usage: %.2f%%\n", $2, $3, $4, $3*100/$2 }'

# Disk Usage
echo "🔹 Disk Usage:"
df -h --output=source,size,used,avail,pcent / | awk 'NR==2{printf "Total: %s | Used: %s | Free: %s | Usage: %s\n", $2, $3, $4, $5}'

# Top 5 processes by CPU usage
echo "🔹 Top 5 Processes by CPU Usage:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -6

# Top 5 processes by Memory usage
echo "🔹 Top 5 Processes by Memory Usage:"
ps -eo pid,comm,%mem --sort=-%mem | head -6

# Stretch Goal: Additional Metrics
echo "---------------------------------------------------------"
echo "🔹 Load Average: $(cat /proc/loadavg | awk '{print $1, $2, $3}')"
echo "🔹 Logged in Users: $(who | wc -l)"
echo "🔹 Failed Login Attempts (last 24h): $(journalctl _SYSTEMD_UNIT=sshd.service --since "24 hours ago" 2>/dev/null | grep -i "Failed password" | wc -l)"

echo "========================================================="

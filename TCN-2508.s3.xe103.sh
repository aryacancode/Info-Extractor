#!/bin/bash
echo -e "WELCOME TO INFO EXTRACTOR\n"

# Menu 
echo "Enter the option for the information you would like displayed:"
echo "1. Public IP Address"
echo "2. Private IP Address"
echo "3. MAC Address"
echo "4. CPU usage (top 10 processes)"
echo "5. Mem usage statistics"
echo "6. Active services and status"
echo "7. Top 10 largest files in /home directory"
echo


# Identifying systems public IP address 
function public_ip() {
    local ip=$(curl -s ifconfig.me)
    echo "Public IP address: " $ip
}



# Identifying private IP assigned to system's NIC
function private_ip() {
    local ip=$(ifconfig | grep -w "inet" | grep -v "127.0.0.1" | awk '{print $2}')
    echo "Private IP address: " $ip
}


# Displaying MAC address while masking sensitive info 
function mac() {
    local mac=$(ip a | grep "ether" | awk '{print $2}')
    masked_mac="${mac:0:5}:xx:xx:xx:xx"
    echo "MAC address: " $masked_mac
}


# Displaying the percentage of CPU usage for the top 5 processes
function cpu_usage() {
    local usage=$(ps aux --sort=-%cpu | head -n 6)
    echo -e "CPU usage of top 5 processes\n"
    printf "%s\n" "$usage"
}


# Displaying memory usage statistics: total and available memory
function mem_usage() {
    local usage=$(free -h)
    echo -e "Memory Usage Statistics\n"
    printf "%s\n" "$usage"
}


# Listing active services and their status
function services() {
    local services=$(systemctl list-units --type=service --state=active)
    echo -e "Active services and status\n"
    printf "%s\n" "$services"
}



# Listing top ten largest file in /home directory
function largest() {
    local files=$(sudo find /home -type f -exec du -sh {} \; | sort -h | tail -n 10)
    echo -e "Top ten largest files in /home\n"
    printf "%s\n" "$files"
}



# Case statement for selection 
read -p "Option: " option

case $option in 
    1) 
        public_ip ;;
    2) 
        private_ip ;;
    3)
        mac ;;
    4) 
        cpu_usage ;;
    5) 
        mem_usage ;;
    6)
        services ;;
    7)
        largest ;;
    *)
        echo "Invalid choice!. Choose a number between 1 and 7."
esac
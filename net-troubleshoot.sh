#!/bin/bash


echo "=======NetWork Torubleshooting========"
read -rp "Server: [1] Ubuntu  [2] CentOS: " choice

# Save results in a separate text file
file="netreport.txt"

{
    ip -brief address
    ip route
    ping -c 2 -W 2 google.com
    cat /etc/resolv.conf
    nslookup google.com
    timeout 30 tracepath google.com

    echo "DNS check: If an IP address works but the website name does not, DNS may be the problem."
    echo "Tracepath: Shows the route to a destination. Use it to investigate where a connection may be failing."

    echo "============================================================================================="

    case "$choice" in

        1)
            echo "Ubuntu: Edit your file in /etc/netplan/"
            echo "Set IP, gateway and DNS. Run: sudo netplan try"

            echo
            echo "======= Ubuntu Networking Defaults ======="
            echo "Ubuntu Server usually uses Netplan to set up networking."
            echo "DHCP automatically gives the server an IP address."
            echo "Configuration files are stored in /etc/netplan/"
            echo "Netplan settings are commonly applied by systemd-networkd."
            echo "NetworkManager may also be used."
            echo
            echo "Network configuration files:"
            ls /etc/netplan/

            echo
            echo "Current Netplan configuration:"
            if command -v netplan >/dev/null 2>&1; then
                sudo netplan get
            else
                echo "Netplan is not installed."
            fi
            ;;

        2)
            echo "CentOS: Run sudo nmtui"
            echo "Choose Manual IPv4. Set IP, gateway and DNS."

            echo
            echo "======= CentOS Networking Defaults ======="
            echo "CentOS commonly uses NetworkManager."
            echo "DHCP automatically gives the server an IP address."
            echo "NetworkManager manages IP, gateway and DNS settings."
            echo "Saved connections are commonly stored in:"
            echo "/etc/NetworkManager/system-connections/"
            echo
         esac

    echo
    echo "======= Troubleshooting Complete ======="

} 2>&1 | tee "$file"

echo "Report saved to: $file"
echo "Compare old and new reports using: diff old.txt new.txt"

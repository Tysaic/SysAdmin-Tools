#!/bin/bash
# Author: Isaac Mendez
# Date: 16/06/2023
# Topic: Program providers a provisional single access point "Wi-fi Point"
# from terminal Linux using dnsmasq, hostapd and iptables

###################################################################################################
#                                                                                                 #
#   Input Interfaces                                                                              #
#                                                                                                 #
###################################################################################################


# First Check if root activated
if [ "$EUID" -ne 0 ]; then 
    echo "[!] Must be root to execute this script."
    echo "[!] Please execute the program as";
    echo "sudo ./provisional_access_point.sh wireless_interface ethernet_interface";
    exit 1;
fi
echo -e " ################################################################################################### \n";
echo "[+] Welcome to single point access";
echo "[!] Program who could set a WI-FI control depending the interface that you put";
echo -e "[!] It so important to get wire connection to the correspondent device to software works. \n";
echo -e " ################################################################################################### \n";


wireless_interface=$1;
ethernet_interface=$2;

if [ -z "$wireless_interface" ];  then
    #The Wireless variable is empty
    echo "[-] Provide the interfaces name before continue";
    read -p "[*] Set Wireless interface:" wireless_interface;

fi

if [ -z "$ethernet_interface" ]; then
    #The Ethernet variable is empty
    echo "[-] Provide the interfaces name before continue";
    read -p "[*] Set Ethernet interface:" ethernet_interface;
fi

checking_wireless_interface="/sys/class/net/$wireless_interface";
checking_ethernet_interface="/sys/class/net/$ethernet_interface";

if [ ! -L "$checking_wireless_interface" ]; then 
    echo "[-] Please provides correct interfaces ";
    echo "[!] Error in Wireless Interface:" $wireless_interface;
    exit 1;
fi

if [ ! -L "$checking_ethernet_interface" ]; then 
    echo "[-] Please provides correct interfaces ";
    echo "[!] Error in Ethernet Interface:" $ethernet_interface;
    exit 1;
fi

###################################################################################################
#                                                                                                 #
#   Setting monitor mode to the access point interface                                            #
#                                                                                                 #
###################################################################################################

echo -e " ################################################################################################### \n";
echo -e "[!] Setting Wireless interface as mode monitor \n";
echo -e " ################################################################################################### \n";
ip link set $wireless_interface down;
ip iw $wireless_interface set monitor mode;
ip link set $wireless_interface up;

if iwconfig "$wireless_interface" | grep -q "Mode:Monitor"; then
    echo "[!] $wireless_interface: There is as monitor mode"
else
    echo "[!] $wireless_interface: There is not as monitor mode";
    echo "[!] Please check your interface if support this mode";
    exit 1;
fi
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

# Command to use 


#sudo ./provisional_access_point.sh wireless_interface ethernet_interface



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

###################################################################################################
#                                                                                                 #
#   Functions	                                                                                  #
#                                                                                                 #
###################################################################################################
function checking_existing_file(){
	FILE=$1;
	if [ -f "$FILE" ]; then
		echo -e "[-] File $FILE existing before will be remove";
		rm $FILE;
	else
		echo -e "[+] File doesn't exists, will be created again.";
	fi
	touch $FILE;
}

function kill_all_processes(){
	echo -e "[!] Closing ip forwarding \n";
	echo 0 > /proc/sys/net/ipv4/ip_forward
	echo -e "[!] Killing all processes \n";
	killall hostapd dnsmasq;
	echo -e "[!] Cleaning IPTABLES \n";
	iptables -F;
	echo -e "[!] Set manage mode the interface \n";
	ip link set $wireless_interface down;
	iwconfig $wireless_interface mode managed;
	ip link set $wireless_interface up;
}
# When push ctrl - C kill all the processes

trap kill_all_processes SIGINT
###################################################################################################
#                                                                                                 #
#   Functions	                                                                                  #
#                                                                                                 #
###################################################################################################

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
#ip iw $wireless_interface set monitor mode;

if iwconfig "$wireless_interface" | grep "Mode:Monitor"; then
    echo "[!] $wireless_interface: There is as monitor mode"
else
    echo "[!] $wireless_interface: There is not as monitor mode";
    ip link set $wireless_interface down;
    iwconfig $wireless_interface mode monitor;
    ip link set $wireless_interface up;
fi
	# CHECK IF SUPPORT MONITOR MODE
    #echo "[!] Please check your interface if support this mode";
    #exit 1;

###################################################################################################
#                                                                                                 #
#   Setting up the hostapd to enable de access point                                              #
#                                                                                                 #
###################################################################################################


echo -e " ################################################################################################### \n";
echo -e "[+] Open the Wifi point in Hostapd \n";
echo -e " ################################################################################################### \n";
HOSTAPD_FILE=/tmp/hostapd.conf
echo -e "[+] Making the hostadp config in $HOSTAPD_FILE"

checking_existing_file $HOSTAPD_FILE;
cat <<EOT > $HOSTAPD_FILE
interface=wlan1
driver=nl80211
ssid=SecureAP
hw_mode=g
channel=6
macaddr_acl=0
ignore_broadcast_ssid=0
wpa=3
wpa_passphrase=xcj4r58c
EOT
echo -e "[=] File created \n";
echo -e "[!] Executing AP [!]";
hostapd $HOSTAPD_FILE &
echo -e "[+] AP Name: Secure AP ---- AP Password:xcj4r58c ";

###################################################################################################
#                                                                                                 #
#   Setting up dnsmasq to the Accees Point		                                          #
#                                                                                                 #
###################################################################################################


echo -e " ################################################################################################### \n";
echo -e "[+]  Setting dnsmasq to dist the dhcp \n";
echo -e " ################################################################################################### \n";
DNSMASQ_FILE=/tmp/dnsmasq.conf
echo -e "[+] Making the dnsmasq config in $DNSMASQ_FILE"

checking_existing_file $DNSMASQ_FILE;

cat <<EOT > $DNSMASQ_FILE
interface=wlan1
dhcp-range=192.168.1.2,192.168.1.30,255.255.255.0,12h
dhcp-option=3,192.168.1.1
dhcp-option=6,192.168.1.1
server=8.8.8.8
log-queries
log-dhcp
listen-address=127.0.0.1
EOT

echo -e "[=] File created \n";
echo -e "[!] Executing DNSMASQ [!]";
sudo systemctl stop dnsmasq;
sudo dnsmasq -C $DNSMASQ_FILE -d &

echo -e " ################################################################################################### \n";
echo -e "[+]  Enabling IP Forwarding \n";
echo -e " ################################################################################################### \n";
echo 1 > /proc/sys/net/ipv4/ip_forward


echo -e " ################################################################################################### \n";
echo -e "[+]  Setting IP tables as firewall to forwarding the internet packages\n";
echo -e " ################################################################################################### \n";

ifconfig $wireless_interface up 192.168.1.1 netmask 255.255.255.0
route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.1.1
iptables -t nat -A POSTROUTING -o $ethernet_interface -j MASQUERADE
iptables -A FORWARD -i $ethernet_interface -o $wireless_interface -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $wireless_interface -o $ethernet_interface -j ACCEPT


sleep infinity;

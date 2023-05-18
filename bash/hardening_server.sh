#!/bin/bash

# Hardening debians servers securing from physical to software site.

#Updating and upgrading system.

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root";
   exit 1;
fi

function installing_tools(){
    echo "***********************";
    echo "[+] Installing tools ...";
    echo "***********************";
    apt install gedit -y;
    echo "***********************";
    echo "[+] Installs done ...";
    echo "***********************";
}

function updating_system (){
    echo "***********************";
    echo "[+] Updating system ...";
    echo "***********************";
    apt autoremove && apt update -y && apt upgrade -y;
    echo "***********************";
    echo "[+] System was updated";
    echo "***********************";
}

function protecting_grub(){
    echo "***********************";
    echo "[!] We protecting the Grub with a password";
    echo "[+] Please be sure to remember everything ";
    echo "[+] The superuser grub will be call ** admin **";
    sleep 1;

    #touch /tmp/password-file;
    #tmp=/tmp/password-file;
    echo "[!] executing Password Grub ...";
    sleep 1;
    echo "[-] Creating Password to grub";
    sleep 1;
    echo "[-] Setting password ";
    #hash=$(grub-mkpasswd-pbkdf2 << "$password");
    grub-mkpasswd-pbkdf2;
    echo "[=] Copy the hash before continuing, from PBKDF2 until last CHARACTER";
    echo "[+] OPEN FILE /etc/grub.d/40_custom and including the file like this:"
    echo 'set superusers="admin"'
    echo "password_pbkdf2 admin grub.pbkdf2.sha512.10000.####HASH####"
    gedit /etc/grub.d/40_custom;
    echo "[!] Press Enter key to continue"
    read
    echo "[!] Continuing..."
    sleep 1;
    echo "[!] Updating Grub "
    update-grub;
    #echo "HASH" $hash;
    #echo 'Password:' $tmp;
}

#installing_tools;
protecting_grub;
#updating_system;
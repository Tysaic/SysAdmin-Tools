#!/bin/bash
# Author: Isaac Mendez
# Date: 27/12/2023
# Topic: Make directories to hackthebox machines enviroments

###################################################################################################
#                                                                                                 #
#   Input Interfaces                                                                              #
#                                                                                                 #
###################################################################################################

# Command to use 


#sudo /security_folder_enumeration.sh Folder_Name| 


function mkdir_creator(){
	if [ ! -d ~/Documents/HackTheBox ]; then
		mkdir ~/Documents/HackTheBox
	fi
	if [ ! -d ~/Documents/HackTheBox/$1 ]; then 
		mkdir ~/Documents/HackTheBox/$1;
		mkdir ~/Documents/HackTheBox/$1/{enumeration,scripts,exploit,guide,tools}
		touch ~/Documents/HackTheBox/$1/guide/how_to_do.md
		echo "[+] -----Whole directory was complete created succesfully! -----"
	else
		echo "[-] ----- Those folders and files existing ----"

	fi
	
}

mkdir_creator $1

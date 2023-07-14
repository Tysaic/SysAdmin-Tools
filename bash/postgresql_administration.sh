# !/bin/bash
# Author: Isaac Mendez
# Date: 06-25-2023
# Program to make administration postgresql 

#if [ "$EUID" -ne 0 ]; then 
#    echo "[!] Must be root to execute this script."
#    echo "[!] Please execute the program as";
#    echo "sudo ./postgresql_administratio.sh";
#    exit 1;
#fi


verify_installation_postgre () {
	#Verify if postgresql is installed into debian
	#if [ $? -e 0 ]; then 
	#if [ ! -z "$(/etc/postgresql)" ]; then
	if [ -d "/etc/postgresql" ]; then
		#Is installed
		echo true;
	else
		#Not installed
		echo false;
	fi
	#Return

}

echo '**************************';
echo 'Postgresql Administration';
echo '**************************';

opcion=0;
while true 
do
	echo "_________________________________________"
	echo "PGUTIL - Programa de Utilidad de Postgres"
	echo "_________________________________________"
	echo "                MAIN MENU	               "
	echo "_________________________________________"
	echo -e "1. Install Postgresql \n";
	echo -e "2. Uninstall Postgresql \n";
	echo -e "3. Get Backup \n";
	echo -e "4. Restore Backup \n";

	read -p "Set an option [1-5]:" option;
	echo -e "\n";
	case $option in 
		1) 
			echo -e "Installing postgresql\n";
			echo -e "verify installation... \n";
			#local verify_sql=$(verify_installation_postgre)
			verify=$(verify_installation_postgre);

			echo $verify;
			if [ ! $verify ]; then
				echo "Postgresql was installed here before...";
			else
				read -s -p "Set sudo password : " password;
				echo -e "\n";
				read -s -p "Set postgresql password : " postgresPassword;
				echo "$password" | sudo -S apt update;
				echo "$password" | sudo -S apt -y install postgresql postgresql-contrib
				sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '{$postgresPassword}';"
				echo "$password" | sudo -S systemctl enable postgresql.service;
				echo "$password" | sudo -S systemctl start postgresql.service;
			fi
			read -n 1 -s -r -p "Press [Enter] to continue;";;
		2) 
			echo -e "Uninstalling postgresql\n";
			read -s -p "Set sudo password :" password;
			echo "$password" | sudo -S systemctl disable postgresql.service;
			echo "$password" | sudo -S systemctl stop postgresql.service;
			echo "$password " | sudo apt purge -y postgresql postgresql-contrib; 
			echo "$password" | sudo -S rm -r /usr/bin/psql;
			echo "$password" | sudo -S rm -r /etc/postgresql;
			echo "$password" | sudo -S rm -r /etc/postgresql-common;
			echo "$password" | sudo -S rm -r /var/lib/postgresql;
			echo "$password" | sudo -S userdel -r postgres;
			echo "$password" | sudo -S groupdel postgresql;
			read -n 1 -s -r -p "Press [Enter] to continue;";;
		3) 
			echo -e "Getting a backup postgresql\n";
			sleep 3;;
		4) 
			echo -e "Restoring a backup postgresql\n";
			sleep 3;;
		5)
			echo -e "Exit... \n";
			exit 0;;
	esac
done

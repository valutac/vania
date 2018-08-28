#!/bin/bash
# change directory to edx-platform
cd /edx/app/edxapp/edx-platform

# prompt user, and read command line argument
read -p 'Enter course ID: ' idcourse
read -p "edXius, Are you sure you want to generate the certificate (Y/N)? " answer

# handle the command line argument we were given
while true
do
	case $answer in
	[yY]* ) echo "Okay Darth edXius, Start generating $idcourse "
		sudo -u www-data /edx/bin/python.edxapp ./manage.py lms --settings aws ungenerated_certs -c $idcourse --insecure
       		break;;
       	

	[nN]* ) exit;;
	
	* ) 	echo "edXius, just enter Y or N, please."; break ;;
  esac
done
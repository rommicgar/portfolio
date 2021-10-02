#!/bin/bash
# 
# Automates network backup of local files from shared user account

local_hostname=$(scutil --get LocalHostName)
mnt_user="AFP_USER"
mnt_passwd="AFP_PASS"
mnt_point="/Volumes/mount_point"
local_home="/Users/LOCAL_HOME"
remote_home="$mnt_point/$local_hostname"
log_file="$HOME/Library/Logs/backup_pubdata.log"

exec >> $log_file 2>&1

directories=(
	'Desktop'
	'Documents'
	'Downloads'
	'Movies'
	'Music'
	'Pictures'
	'Public'
	)

# Check if running as root
if [[ $(id -u) != 0 ]]; then
	echo "Error: this script must be run as the root user."
	exit 1
fi

mkdir "$mnt_point"

mount_afp -o nobrowse afp://"$mnt_user":"$mnt_passwd"@SERVER_ADDRESS.COM/USER_DATA_STORE "$mnt_point"

if [ ! -d "$remote_home" ]; then
	mkdir "$remote_home"
	echo "Remote home directory did not exist. Created and proceeding..."
else
	echo "Remote home directory already exists. Proceeding..."
fi

# Begin copying data across
for i in "${directories[@]}"; do
	if [ "$i" == "Desktop" ]; then
		mkdir "$remote_home"/Desktop
		cp -Rv "$local_home/$i"/* "$remote_home"/Desktop
	elif [ "$i" == "Documents" ]; then
		mkdir "$remote_home"/Documents
		cp -Rv "$local_home/$i"/* "$remote_home"/Documents
	elif [ "$i" == "Downloads" ]; then
		mkdir "$remote_home"/Downloads
		cp -Rv "$local_home/$i"/* "$remote_home"/Downloads
	elif [ "$i" == "Movies" ]; then
		mkdir "$remote_home"/Movies
		cp -Rv "$local_home/$i"/* "$remote_home"/Movies
	elif [ "$i" == "Music" ]; then
		mkdir "$remote_home"/Music
		cp -Rv "$local_home/$i"/* "$remote_home"/Music
	elif [ "$i" == "Pictures" ]; then
		mkdir "$remote_home"/Pictures
		cp -Rv "$local_home/$i"/* "$remote_home"/Pictures
	elif [ "$i" == "Public" ]; then
		mkdir "$remote_home"/Public
		cp -Rv "$local_home/$i"/* "$remote_home"/Public
	fi
	
done

exit 0

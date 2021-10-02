#!/bin/bash
#
# Name:          Roman Garcia
# Date:          20.03.2017
# 

#VARIABLES
user_id=`id -u`
user_name=`id -un $user_id`
log_file="$HOME/Library/Logs/mso_setup.log"

exec >> $log_file 2>&1

#EXCEPTION
if [ `pgrep -l Microsoft` ]; then
	echo "Microsoft Office is running. Aborting..."
	exit 0
fi

if [ "$user_name" != "Guest" ]; then
	echo "Guest account check failed. Aborting..."
	exit 0
fi

#VERSION CHECK
if [ -e /Applications/Microsoft\ Office\ 2011/Microsoft\ Word.app ]; then
    office_vers="2011"
elif [ -e /Applications/Microsoft\ Word.app ]; then
    office_vers="2016"
fi

#FUNCTIONS
office_2011(){
	echo "Preparing Microsoft Office 2011 user environment for first use..."
	exit 1
}

office_2016(){
	echo "Preparing Microsoft Office 2016 user environment for first use..."
    defaults write com.microsoft.Word kSubUIAppCompletedFirstRunSetup1507 -bool true         #WORD
    defaults write com.microsoft.Excel kSubUIAppCompletedFirstRunSetup1507 -bool true        #EXCEL
    defaults write com.microsoft.Outlook kSubUIAppCompletedFirstRunSetup1507 -bool true      #OUTLOOK
    defaults write com.microsoft.Outlook FirstRunExperienceCompleted015 -bool true
    defaults write com.microsoft.Powerpoint kSubUIAppCompletedFirstRunSetup1507 -bool true   #POWERPOINT
    defaults write com.microsoft.onenote.mac kSubUIAppCompletedFirstRunSetup1507 -bool true  #ONENOTE
    exit 1
}

#EXECUTE
if [ "$office_vers" == "2011" ]; then
    office_2011
elif [ "$office_vers" == "2016" ]; then
    office_2016
fi

exit 0
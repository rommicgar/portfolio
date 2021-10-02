#!/bin/bash
#
# Name:          Roman Garcia
# Date:          06.06.2017
# 
# Borrowed in part from Calum Hunter
#

#CONSTANTS
dockutil="/usr/local/bin/dockutil"
user_id=$(id -u)
user_name=$(id -un $user_id)
os_vers=$(sw_vers -productVersion)
log_file="$HOME/Library/Logs/dock_setup.log"

exec >> $log_file 2>&1

#OFFICE CHECK
if [ -e /Applications/Microsoft\ Office\ 2011/Microsoft\ Word.app ]; then
    office_vers="2011"
elif [ -e /Applications/Microsoft\ Word.app ]; then
    office_vers="2016"
fi

office_2011() {
${dockutil} --add '/Applications/Microsoft Office 2011/Microsoft Word.app' --no-restart
${dockutil} --add '/Applications/Microsoft Office 2011/Microsoft Excel.app' --no-restart
${dockutil} --add '/Applications/Microsoft Office 2011/Microsoft PowerPoint.app' --no-restart
}

office_2016() {
${dockutil} --add '/Applications/Microsoft Word.app' --no-restart
${dockutil} --add '/Applications/Microsoft Excel.app' --no-restart
${dockutil} --add '/Applications/Microsoft PowerPoint.app' --no-restart
}

#PHOTOSHOP CHECK
if [ -e "/Applications/Adobe Photoshop CC 2015.5/Adobe Photoshop CC 2015.5.app" ]; then
	ps_vers="2015.5"
elif [ -e "/Applications/Adobe Photoshop CC 2017/Adobe Photoshop CC 2017.app" ]; then
	ps_vers="2017"
fi

ps_2015v5() {
${dockutil} --add '/Applications/Adobe Photoshop CC 2015.5/Adobe Photoshop CC 2015.5.app' --no-restart
}

ps_2017() {
${dockutil} --add '/Applications/Adobe Photoshop CC 2017/Adobe Photoshop CC 2017.app' --no-restart
}

#GUEST RESET
guest_reset() {
${dockutil} --remove all --no-restart

# Browsers
${dockutil} --add /Applications/Safari.app --no-restart
${dockutil} --add '/Applications/Google Chrome.app' --no-restart

# Office
if [ "$office_vers" == "2011" ]; then
    office_2011
elif [ "$office_vers" == "2016" ]; then
    office_2016
fi

# Adobe and GIMP
${dockutil} --add '/Applications/Adobe Acrobat DC/Adobe Acrobat.app' --no-restart

if [ "$ps_vers" == "2015.5" ]; then
    ps_2015v5
elif [ "$ps_vers" == "2017" ]; then
    ps_2017
fi

${dockutil} --add /Applications/GIMP.app --no-restart

# Miscellaneous
${dockutil} --add /Applications/ExpanDrive.app --no-restart
${dockutil} --add '~/Downloads' --view list --display folder --sort dateadded --no-restart
${dockutil} --add '/Applications' --view grid --display folder --sort name
}

admin_reset() {
${dockutil} --remove all --no-restart
${dockutil} --add '/Applications/Google Chrome.app' --no-restart
${dockutil} --add '/Applications/Managed Software Center.app' --no-restart
${dockutil} --add '/Applications/App Store.app' --no-restart
${dockutil} --add '/Applications/Utilities/Activity Monitor.app' --no-restart
${dockutil} --add '/Applications/Utilities/Terminal.app' --no-restart
${dockutil} --add '/Applications/Utilities/Console.app' --no-restart
${dockutil} --add '/Applications/Utilities/Disk Utility.app' --no-restart
${dockutil} --add '/Applications/TextWrangler.app' --no-restart
${dockutil} --add '/Applications/System Preferences.app' --no-restart
${dockutil} --add '~/Downloads' --view list --display folder --sort dateadded --no-restart
${dockutil} --add '/Applications/Utilities' --view grid --display folder --sort name --no-restart
${dockutil} --add '/Applications' --view grid --display folder --sort name

touch ~/.dock_reset
}

sleep 3 # Wait for dock to initialize

#EXCEPTION
if [ "$user_name" == "LOCAL_ADMIN" ] && [ ! -e ~/.dock_reset ]; then
	echo "### $(date) begin LOCAL_ADMIN dock reset "
	admin_reset
	echo "### $(date) end LOCAL_ADMIN dock reset "
	
	exit 0
else
	printf "Either ~/.dock_reset exists or not LOCAL_ADMIN... \nDefaulting to guest_reset function!\n"
fi

printf "### $(date) begin Guest dock reset\n"
guest_reset
printf "### $(date) end Guest dock reset\n"

sleep 1 # Wait for dock to reset fully

# Dock reset breaks for macOS Sierra
if [[ "$os_vers" == "10.12"* ]]; then
	/usr/bin/killall Dock
fi

exit 0

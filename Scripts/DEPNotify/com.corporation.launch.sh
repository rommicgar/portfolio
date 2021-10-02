#!/bin/bash
#
# Name:			Roman Garcia
# Organization:	...
# Date:			11.08.2020
#
# Structure is based in large part on the work of John Mahlman at UArts Philadelphia
# This script is called by the LaunchDaemon com.corporation.launch.plist and executes DEPNotify.app plus configuration
# Modified in August 2020 for student laptop deployment

# Get the logged in user
currentUser=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')

# Declare setupDone location
setupDone="/var/db/receipts/com.corporation.provisioned.bom"

# Clean up function
function cleanup {
	
	# Kill DEPNotify
	killall DEPNotify
	/bin/rm -rf /var/tmp/DEPNotify.app
	/bin/rm -f /Library/LaunchDaemons/com.corporation.launch.plist
	/bin/rm -f /var/tmp/DEPNotify.plist
	/bin/rm -f /var/tmp/corp-seal.png
	/bin/rm -f /var/tmp/com.depnotify.registration.done
	/bin/rm -f /var/tmp/com.corporation.launch.sh
	
	# Create provisioned BOM file to prevent accidental relaunch
	/usr/bin/touch /var/db/receipts/com.corporation.provisioned.bom
	
	# Restart the machine after 1 minute
	# /sbin/shutdown -r +1 "Restarting in order to finalize provisioning process..."

}

if pgrep -x "Finder" && pgrep -x "Dock" && [ "$currentUser" != "_mbsetupuser" ] && [ ! -e "$setupDone" ]
then

	# Kill any currently running Installer process
	killall Installer && sleep 5

	# Define location for DEPNotify settings
	dnLog=/var/tmp/depnotify.log

	# Configure DEPNotify
	sudo -u "$currentUser" defaults write menu.nomad.DEPNotify PathToPlistFile /var/tmp/
	sudo -u "$currentUser" defaults write menu.nomad.DEPNotify RegisterMainTitle "Register this Mac"
	sudo -u "$currentUser" defaults write menu.nomad.DEPNotify RegistrationButtonLabel "Submit"
	sudo -u "$currentUser" defaults write menu.nomad.DEPNotify UITextFieldUpperLabel "Barcode"
	sudo -u "$currentUser" defaults write menu.nomad.DEPNotify UITextFieldUpperPlaceholder "123456"

	# Write out initial text
	{
	echo "Command: MainTitle: Registration"
	echo "Command: MainText: The inventory record for this computer will be updated in Jamf."
	echo "Command: Image: /var/tmp/corp-seal.png"
	} >> $dnLog
	
	# Launch DEPNotify
	sudo -u "$currentUser" /var/tmp/DEPNotify.app/Contents/MacOS/DEPNotify &
	
	# Provide Register button and status update
	{
	echo "Command: ContinueButtonRegister: Register"
	echo "Status: Please click Register in order to proceed"
	} >> $dnLog
	
	# Declare location of dnPlist
	dnPlist="/var/tmp/DEPNotify.plist"
	
	# The following loop will only break once DEPNotify writes to dnPlist
	# dnPlist is written to after the user submits the registration form
	while : ; do
		[[ -e "$dnPlist" ]] && break
		sleep 1
	done

	# Wait several seconds, read computer name and asset tag from property list, set computer name, then recon
	sleep 3
	
	echo "Status: Resetting computer name and submitting information to Jamf..." >> $dnLog
	
	assetTag=$(defaults read "$dnPlist" "Barcode")
	compName="$assetTag-$currentUser"
	
	/usr/local/bin/jamf setComputerName -name "$compName"
	/usr/local/bin/jamf recon
	
	cleanup
	
fi

exit 0

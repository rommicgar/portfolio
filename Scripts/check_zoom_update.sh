#!/bin/bash
# Quit Zoom and install update

# Assign static variables: get PID for zoom.us parent process and computer name
zoom_pid=$(/usr/bin/pgrep zoom.us)
computerName=$(scutil --get ComputerName)

# Store Zoom version: utilize at later date 
# zoom_ver=$(defaults read /Applications/zoom.us.app/Contents/Info.plist CFBundleShortVersionString | cut -c 1-5)

# Get PID for any zoom.us child process
# Indicates whether actively "on call" or merely idling
pgrep -P "$zoom_pid" >/dev/null

# Checks subprocess ID for read out: 0 success, > or <1 indicates no process found
if [[ "$?" == 0 ]]; then
	echo "Zoom is running and is in a call. Halt..."
    exit 1
else
 	/usr/bin/pkill zoom.us
 	/usr/local/bin/jamf policy -trigger "installZoom"
    exit 0
 fi

exit 0
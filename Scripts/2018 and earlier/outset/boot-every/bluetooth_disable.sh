#!/bin/bash
#
# Name:          Roman Garcia
# Date:          20.03.2017
# 
# Disables the Bluetooth controller
#

if [ `defaults read /Library/Preferences/com.apple.Bluetooth.plist ControllerPowerState` == "1" ]
then
	killall blued
	launchctl unload /System/Library/LaunchDaemons/com.apple.blued.plist
	defaults write /Library/Preferences/com.apple.Bluetooth.plist ControllerPowerState 0
	exit 1
else
	echo "Bluetooth was already disabled. Aborting..."
	exit 1
fi

exit 0
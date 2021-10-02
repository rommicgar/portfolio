#!/bin/bash
# Sets dock for student workstations, runs for current logged in user

currentUser=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
currentUserHome=$(eval echo ~"$currentUser")
dockutil=$(which dockutil)

# Remove all dock shortcuts
"$dockutil" --remove all --no-restart "$currentUserHome" && sleep 2

# Add standard set of apps
"$dockutil" --add '/Applications/Google Chrome.app' --no-restart "$currentUserHome" && sleep 1
"$dockutil" --add '/Applications/Google Docs.app' --no-restart "$currentUserHome" && sleep 1
"$dockutil" --add '/Applications/Google Sheets.app' --no-restart "$currentUserHome" && sleep 1
"$dockutil" --add '/Applications/Google Slides.app' --no-restart "$currentUserHome" && sleep 1
"$dockutil" --add '/Applications/zoom.us.app' --no-restart "$currentUserHome" && sleep 1

# Evaluates FS path to System Preferences and adds to dock accordingly
# System Preferences app bundle moved to System directory starting with Catalina
if [ -d "/Applications/System Preferences.app" ]; then
	"$dockutil" --add '/Applications/System Preferences.app' --no-restart "$currentUserHome" && sleep 1
else
	"$dockutil" --add '/System/Applications/System Preferences.app' --no-restart "$currentUserHome" && sleep 1
fi

# Dock folders: user downloads and applications
"$dockutil" --add '~/Downloads' --view list --display folder --sort dateadded --no-restart "$currentUserHome" && sleep 1
"$dockutil" --add '/Applications' --view grid --display folder --sort name "$currentUserHome"

exit 0

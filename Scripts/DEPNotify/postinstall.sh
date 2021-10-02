#!/bin/bash
#
# Name:			Roman Garcia
# Organization:	...
# Date:			11.08.2020
#
# Script is based on the work of John Mahlman at UArts Philadelphia
# Modified for August 2020 student laptop deployment

# Sort out permissions and ownership for main script and LaunchDaemon
chmod a+x /var/tmp/com.corporation.launch.sh
chmod 644 /Library/LaunchDaemons/com.corporation.launch.plist
chown root:wheel /Library/LaunchDaemons/com.corporation.launch.plist

# Load LaunchDaemon
/bin/launchctl load /Library/LaunchDaemons/com.corporation.launch.plist

exit 0

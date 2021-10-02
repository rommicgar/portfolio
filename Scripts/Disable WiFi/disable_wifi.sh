#!/bin/sh
#
# Script periodically disables Wi-Fi interface in labs

wifi_state=$(networksetup -getnetworkserviceenabled Wi-Fi)

if [ "$wifi_state" == "Enabled" ]; then
	networksetup -setnetworkserviceenabled Wi-Fi off
else
	printf "[$(date)] Wi-Fi is already disabled.\n"
fi

exit 0

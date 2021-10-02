#!/bin/bash
#
# Name:          Roman Garcia
# Date:          20.03.2017
# 
# Unloads the com.apple.AdobeCreativeCloud job
# 

PLIST="/Library/LaunchAgents/com.adobe.AdobeCreativeCloud.plist"
CCAPPJOB=`launchctl list | grep com.adobe.AdobeCreativeCloud`

if [ "$CCAPPJOB" != "" ]; then
	/bin/launchctl unload -w "$PLIST"
fi

exit 0
#!/bin/bash
#
# Name:          Roman Garcia
# Date:          19.05.2017
# 
# Disable autoupdate and prevent unwanted storedownloadd credential requests
# An alternative command would be `softwareupdate --schedule off`
#

defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool false

exit 0
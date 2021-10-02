#!/bin/zsh
#
# An extension attribute script that reports whether Rosetta 2 is installed:
# Returns three possible answers:
#   Installed
#   Not Installed
#   Not Applicable
#
# Script modified by Roman Garcia based on Rich Trouton's pgrep test. Retained leading arch variable.

arch=$(/usr/bin/arch)

if [[ "$arch" == "arm64" ]]; then
	if /usr/bin/pgrep oahd >/dev/null 2>&1; then
    	result="Installed"
	else
    	result="Not Installed"
	fi
else
    result="Not Applicable"
fi

echo "<result>$result</result>"
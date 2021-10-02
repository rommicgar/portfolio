#!/bin/bash
#
# Checks and reports on endpoint uptime since last restart
# Reports number of days if days >1

days=$(uptime | awk '{ print $4 }' | sed 's/,//g')
num=$(uptime | awk '{ print $3 }')

if [[ "$days" == "days" ]]; then
    echo "<result>$num</result>"
fi

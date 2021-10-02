#!/bin/bash

# Array of computer name prefixes: add new ones here
names=(
	'LIST'
	'OF'
	'PREFIXES'
)

# Get current computer name
computer_name=$(scutil --get ComputerName)

# For each name in above array, check if it is "like" (in the Jamf sense) the current computer one
# If so, returns "True" and breaks; if none of the above, eventually report "False"
for i in ${names[@]}; do
	if [[ "$computer_name" == "$i"* ]]; then
		echo "<result>True</result>"
		
		exit 0
	fi
	
done

echo "<result>False</result>"
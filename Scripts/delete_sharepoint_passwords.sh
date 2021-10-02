#!/bin/bash
#
# Periodically deletes saved passwords for certain network share points from login keychain
# Script always returns 0 because "security" (bizarrely) returns exit code 44
#

servers=(
	'ARRAY'
	'OF'
	'SERVERS'
	)

for i in "${servers[@]}"
do
	/usr/bin/security delete-internet-password -s "$i"
	
done

exit 0

#!/bin/sh
#
# Utilizes sed to swap final hyphen in array of names for forward slash for Munki manifest subfolders

names=(
	'CORP-506-01'
	'CORP-506-02'
	'CORP-506-03'
	)

for i in ${names[@]}; do
	echo "$i" | sed 's:-:\/:2'
	
done

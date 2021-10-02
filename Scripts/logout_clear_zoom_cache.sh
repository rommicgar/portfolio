#!/bin/bash
#
# Kills active Zoom session and clears user cache, causing logout

# Kill Zoom process
pkill "zoom.us"

# Delete user cache
for i in $(ls -1b /Users); do
	rm -rf /Users/"$i"/Library/"Application Support"/zoom.us/data
done

exit 0

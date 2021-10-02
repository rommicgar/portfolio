#!/bin/bash
# Remove all print queues passed to lpadmin

for printer in $(/usr/bin/lpstat -p | awk '{print $2}'); do
	/usr/sbin/lpadmin -x "$printer"
done
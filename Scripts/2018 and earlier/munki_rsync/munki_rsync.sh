#!/bin/bash
SERVER_MOUNT_PT="/Volumes/munki_main"
SERVER_URL="afp://username:password@munkimirror.corporation.com/munki_repo"
we_mounted="false"

MUNKI_MASTER="/Volumes/Macintosh HD2/Shares/munki_repo/"
MUNKI_COPY="/Volumes/munki_main"

MountServer()
{
	if [ ! -d "${SERVER_MOUNT_PT}" ]; then
		mkdir "${SERVER_MOUNT_PT}"
		mount -t afp "${SERVER_URL}" "${SERVER_MOUNT_PT}"
		result=$?

		if [ "$result" == 0 ]; then
			we_mounted="true"
		else
			rmdir "${SERVER_MOUNT_PT}"
			echo "### error ${result} trying to mount munki_repo, exiting"
			exit ${result}
		fi
	fi
}

UnmountServer()
{
	if [ "${we_mounted}" == "true" ]; then
		umount "${SERVER_MOUNT_PT}"
	fi
}

MunkiSyncEverything()
{
	rsync -ahrv --exclude '.DS_Store' --delete --progress "${MUNKI_MASTER}" "${MUNKI_COPY}"
}

echo "### $(date) munki sync begin "
MountServer
MunkiSyncEverything
UnmountServer
echo "### $(date) munki sync end "

exit 0

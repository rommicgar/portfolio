#!/bin/sh
#
# Moves files under shared user home folder to "hidden," timestamped directory below home root

dated=$(date +%Y%m%d-%H%M)
shared_user="LOCAL_USER"
session_cache_root=/Users/"$shared_user"/."$shared_user"_sessions
dated_cache="$session_cache_root"/"$dated"

if [ ! -d "$session_cache_root" ]; then
    mkdir "$session_cache_root"
fi

if [ ! -d "$dated_cache" ]; then
    mkdir "$dated_cache"
fi

/bin/mv -v /Users/"$shared_user"/Desktop/* "$dated_cache"
/bin/mv -v /Users/"$shared_user"/Documents/* "$dated_cache"
/bin/mv -v /Users/"$shared_user"/Downloads/* "$dated_cache"
/bin/mv -v /Users/"$shared_user"/Movies/* "$dated_cache"
/bin/mv -v /Users/"$shared_user"/Pictures/* "$dated_cache"

chown -R "$shared_user":staff "$session_cache_root"
chmod -R 555 "$session_cache_root"
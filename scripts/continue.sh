#!/bin/bash
export HOME=/home/$(whoami)

if [ -z "$HTTP_PORT" ]; then
    # not 80 as it is supposed to be run behind a reverse proxy and without root
    export HTTP_PORT=3000
fi

if [ -z "$PHP_PORT" ]; then
    export PHP_PORT=9000
fi

if [ -z "$CONFIG_FILE" ]; then
    export CONFIG_FILE="lighttpd.conf"
fi

if [ -z "$TIMEZONE" ]; then
    export TIMEZONE="UTC";
fi

# get ip addresses and export them as environment variables
# if you have multiple services that depend on each other
# and for some reason lighttpd can't resolve the php hostname
#export PHP_TCP=`getent hosts php | awk '{ print $1 }'`

# set timezone
cat /usr/share/zoneinfo/$TIMEZONE > /etc/localtime
echo $TIMEZONE > /etc/timezone

# check if lighttpd file exists
if [ -f "/etc/lighttpd/$CONFIG_FILE" ]; then
    perl -pi -e "s/server\.port\s*=\s*\d{1,5}/server.port=$HTTP_PORT/gi" /etc/lighttpd/$CONFIG_FILE
    perl -pi -e "s/server\.username\s*=\s*\".+?\"/server.username=\"www-data\"/gi" /etc/lighttpd/$CONFIG_FILE
    perl -pi -e "s/server\.groupname\s*=\s*\".+?\"/server.groupname=\"www-data\"/gi" /etc/lighttpd/$CONFIG_FILE
else
    echo "server.document-root=\"/var/www\"
server.port=$HTTP_PORT
server.username=\"www-data\"
server.groupname=\"www-data\"" > /etc/lighttpd/$CONFIG_FILE
fi

# run user scripts
if [[ -d ${ENV_DIR}/files/.$(whoami) ]]; then
	chmod +x ${ENV_DIR}/files/.$(whoami)/*
	run-parts ${ENV_DIR}/files/.$(whoami)
fi

echo "Starting lighttpd on $HTTP_PORT"
# start lighttpd
lighttpd -f /etc/lighttpd/$CONFIG_FILE

$SHELL
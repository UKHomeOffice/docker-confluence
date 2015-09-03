#!/bin/bash -ex

# Add our cron
echo "${CRON_TIME} ${CRON_USER} ${CRON_CMD} > /dev/stdout 2>&1" >> /etc/crontab

# Startup whines that this folder hasn't been created
mkdir -p /usr/local/Confluence/conf/Standalone/localhost

# Fix Confluence DB conf

# Fix Confluence Tomcat conf

# Run Supervisor as pid 1.  
# Typically you want to just run the app directly, but we're also running cron for backups.
exec /usr/bin/supervisord -n -c /etc/supervisord.conf

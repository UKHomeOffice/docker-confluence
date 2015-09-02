#!/bin/bash -ex

# Add our cron
echo "${CRON_TIME} ${CRON_USER} ${CRON_CMD} > /dev/stdout 2>&1" >> /etc/crontab

# Fix Confluence config.


# Run Supervisor as pid 1.  
# Typically you want to just run the app directly, but we're also running cron for backups.
exec /usr/bin/supervisord -n -c /etc/supervisord.conf

#!/bin/bash -ex

# Add our cron
env > /env.txt
echo "${CRON_TIME} ${CRON_USER} source /env.txt && ${CRON_CMD} > /dev/stdout 2>&1" >> /etc/crontab

# Startup whines that this folder hasn't been created
mkdir -p /usr/local/Confluence/conf/Standalone/localhost

# Make sure confluence owns the coluence directory
mkdir -p ${APP_DATA}
chown -R ${APP_USER}:${APP_USER} ${APP_DATA} 

# Fix Confluence Tomcat conf; Don't think we need this

# Run Supervisor as pid 1.  
# Typically you want to just run the app directly, but we're also running cron for backups.
exec /usr/bin/supervisord -n -c /etc/supervisord.conf

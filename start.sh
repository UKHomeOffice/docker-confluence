#!/bin/bash -ex

# Startup whines that this folder hasn't been created
mkdir -p /usr/local/Confluence/conf/Standalone/localhost

# Make sure confluence owns the coluence directory
mkdir -p ${APP_DATA}
chown -R ${APP_USER}:${APP_USER} ${APP_DATA} 

# Fix Confluence Tomcat conf


# Run Supervisor as pid 1.  
exec /usr/local/Confluence/bin/catalina.sh run

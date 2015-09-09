#!/bin/bash -ex

# Startup whines that this folder hasn't been created
mkdir -p /usr/local/Confluence/conf/Standalone/localhost

# Make sure confluence owns the coluence directory
mkdir -p ${APP_DATA}
chown -R ${APP_USER}:${APP_USER} ${APP_DATA} 

# Fix Confluence Tomcat conf
if [ -n "$SSL_REVERSE_PROXY_NAME" ]; then
    sed 's/redirectPort="8443"/scheme="https"\n\t secure="true"\n\t proxyName="'"${SSL_REVERSE_PROXY_NAME}"'"\n\t proxyPort="'"${SSL_REVERSE_PROXY_PORT}"'"/' -i ${APP_PATH}/conf/server.xml
fi


# Run Supervisor as pid 1.  
exec /usr/local/Confluence/bin/catalina.sh run

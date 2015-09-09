#!/bin/bash -ex

$APP_PATH=/usr/local/Confluence

# Startup whines that this folder hasn't been created
mkdir -p /usr/local/Confluence/conf/Standalone/localhost

# Make sure confluence owns the coluence directory
mkdir -p ${APP_DATA}
chown -R ${APP_USER}:${APP_USER} ${APP_DATA} 

# Fix Confluence Tomcat conf
if [ -n "$SSL_REVERSE_PROXY_NAME" ]; then
    sed 's/disableUploadTimeout="true"\/>/disableUploadTimeout="true"\n                secure="true"\/>/' -i ${APP_PATH}/conf/server.xml
    sed 's/disableUploadTimeout="true"/disableUploadTimeout="true"\n                   proxyPort="'"${SSL_REVERSE_PROXY_PORT}"'"/' -i ${APP_PATH}/conf/server.xml
    sed 's/disableUploadTimeout="true"/disableUploadTimeout="true"\n                   proxyName="'"$(echo ${SSL_REVERSE_PROXY_NAME} | sed -e 's/[\/&]/\\&/g')"'"/' -i ${APP_PATH}/conf/server.xml
    sed 's/disableUploadTimeout="true"/disableUploadTimeout="true"\n                   scheme="https"/' -i ${APP_PATH}/conf/server.xml
fi


# Run Supervisor as pid 1.  
exec /usr/local/Confluence/bin/catalina.sh run

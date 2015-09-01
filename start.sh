#!/bin/bash -ex

# Run Confluence as pid 1

exec -l /usr/local/Confluence/bin/catalina.sh run

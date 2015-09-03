FROM quay.io/ukhomeofficedigital/docker-centos-base

# Build time variables
ENV CONFLUENCE_VERSION 5.8.10
ENV ARCH x64
ENV MYSQL_DRIVER_VERSION 5.1.36

# Runtime options
ENV DEBUG_MODE false
ENV CATALINA_OUT /dev/stdout
ENV CATALINA_OPTS -Djava.net.preferIPv4Stack=true

ENV APP_USER confluence
ENV APP_DATA /var/atlassian/application-data/confluence
ENV BACKUP_DIR /var/backups

ENV CRON_TIME "0 */2 * * *"
ENV CRON_USER ${APP_USER}
ENV CRON_CMD 'myqldump -u ${DB_USER:?} -p${DB_PASS:?} -h ${DB_HOST:?} ${DB_NAME:?} > ${APP_DATA:?}/${DB_NAME:?}.sql && \
              tar zcvf ${BACKUP_DIR:?}/${DB_NAME:?}-$(date +%s).tar.gz ${APP_DATA:?} && \
              rm ${APP_DATA:?}/${DB_NAME:?}.sql'

# Install supervsior & crond
RUN yum update -y && \
    yum install -y \
      python-setuptools \
      cronie-noanacron && \
    yum -y clean all && \
    easy_install supervisor

# Add supervisor configs
ADD supervisord/*.ini /etc/supervisord.d/
RUN echo_supervisord_conf > /etc/supervisord.conf && \
    echo '[include]' >> /etc/supervisord.conf && \
    echo 'files = /etc/supervisord.d/*.ini' >> /etc/supervisord.conf

# Unattended install; the -q does it. Default options.
RUN curl -Ls "https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONFLUENCE_VERSION}-${ARCH}.bin" -o confluence.bin
RUN chmod +x confluence.bin && /bin/sh confluence.bin -q && rm confluence.bin 

RUN curl -Lks http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_DRIVER_VERSION}.tar.gz -o /root/mysql-connector.tar.gz
RUN tar xzf /root/mysql-connector.tar.gz --strip=1 --wildcards '*/mysql-connector-java*.jar' && \
    mv mysql-connector-java*.jar /usr/local/Confluence/lib && \
    rm /root/mysql-connector.tar.gz

# Configure config before being replaced by exec'd cmd.
COPY start.sh /
CMD ["/start.sh"]

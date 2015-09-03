FROM quay.io/ukhomeofficedigital/docker-centos-base

# Build time variables
ENV CONFLUENCE_VERSION 5.8.10
ENV ARCH x64

# Runtime options
ENV DEBUG_MODE false
ENV CATALINA_OUT /dev/stdout
ENV CATALINA_OPTS -Djava.net.preferIPv4Stack=true

ENV APP_USER confluence
ENV APP_HOME /home/confluence
ENV BACKUP_DIR /var/backups

# I'm only gonna bother supporting mysql
ENV DB_TYPE mysql
ENV DB_HOST 127.0.0.1
ENV DB_NAME confluence
ENV DB_USER confluence
ENV DB_PASS ecneulfnoc

ENV CRON_TIME "0 */2 * * *"
ENV CRON_USER ${APP_USER}
ENV CRON_CMD 'myqldump -u ${DB_USER:?} -p${DB_PASS:?} -h ${DB_HOST:?} ${DB_NAME:?} > ${APP_HOME:?}/${DB_NAME:?}.sql && \
              tar zcvf ${BACKUP_DIR:?}/${DB_NAME:?}.tar.gz ${APP_HOME:?} && \
              rm ${APP_HOME:?}/${DB_NAME:?}.sql'

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

# Configure config before being replaced by exec'd cmd.
COPY start.sh /
CMD ["/start.sh"]

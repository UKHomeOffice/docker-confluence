FROM quay.io/ukhomeofficedigital/docker-centos-base

ENV CONFLUENCE_VERSION 5.8.10-x64
#ENV CATALINA_OUT /dev/stdout
#ENV CATALINA_OPTS ""

# Install confluence
RUN curl -Ls "https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONFLUENCE_VERSION}.bin" -o confluence.bin
RUN chmod +x confluence.bin && /bin/sh confluence.bin -q && rm confluence.bin 

COPY start.sh /
ENTRYPOINT ["/start.sh"]

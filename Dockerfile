FROM debian:buster-slim
MAINTAINER sysadmin@kronostechnologies.com

ENV DEBIAN_FRONTEND=noninteractive
ENV GEARMAN_JOB_RETRIES=1
ENV GEARMAN_LOG_FILE=stderr
ENV GEARMAN_ROUND_ROBIN=true

ADD https://github.com/kronostechnologies/gearmand/releases/download/1.1.18-161-ga95d1c13/gearmand_1.1.18+161-ga95d1c13-1_amd64.deb /tmp/

RUN apt-get update && apt-get install -y --no-install-recommends /tmp/*.deb \
&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN useradd gearman && mkdir -p /opt/gearman && \
    chown gearman /opt/gearman

WORKDIR /opt/gearman
COPY ./bin /opt/gearman/bin
RUN chmod +x /opt/gearman/bin/*

USER gearman

EXPOSE 4730
ENTRYPOINT ["/opt/gearman/bin/entrypoint.sh"]

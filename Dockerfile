FROM debian:bullseye-slim
MAINTAINER na-qc@equisoft.com

ENV DEBIAN_FRONTEND=noninteractive
ENV GEARMAN_JOB_RETRIES=1
ENV GEARMAN_LOG_FILE=stderr
ENV GEARMAN_ROUND_ROBIN=true

RUN apt update && apt install gearman-job-server -y --no-install-recommends --no-install-suggests \
&& apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

COPY ./bin/entrypoint.sh /bin

USER gearman

EXPOSE 4730
ENTRYPOINT ["/bin/entrypoint.sh"]

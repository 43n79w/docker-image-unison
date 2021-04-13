FROM ubuntu:hirsute

RUN apt-get update && apt-get -y install time unison supervisor bash inotify-tools ruby tzdata monit

ENV TZ="Europe/Helsinki" \
    LANG="C.UTF-8" \
    UNISON_DIR="/data" \
    HOME="/root"

COPY entrypoint.sh /entrypoint.sh
COPY precopy_appsync.sh /usr/local/bin/precopy_appsync
COPY monitrc /etc/monitrc

RUN mkdir -p /docker-entrypoint.d \
 && chmod +x /entrypoint.sh \
 && mkdir -p /etc/supervisor.conf.d \
 && mkdir /unison \
 && chmod +x /usr/local/bin/precopy_appsync \
 && chmod u=rw,g=,o= /etc/monitrc

COPY supervisord.conf /etc/supervisord.conf
COPY supervisor.daemon.conf /etc/supervisor.conf.d/supervisor.daemon.conf

ENTRYPOINT ["/entrypoint.sh"]
CMD ["supervisord"]
############# ############# #############
############# /SHARED     / #############
############# ############# #############

VOLUME /unison
EXPOSE 5000

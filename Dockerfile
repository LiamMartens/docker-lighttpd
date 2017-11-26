FROM liammartens/alpine
LABEL maintainer="Liam Martens <hi@liammartens.com>"

# install lighttpd
RUN apk add --update --no-cache \
    lighttpd lighttpd-mod_auth && \
    rm /etc/lighttpd/lighttpd.conf

# create lighttpd directory
RUN mkdir -p /etc/lighttpd /var/www && \
    chown -R ${USER}:${USER} /etc/lighttpd /var/www

# add volumes
VOLUME /etc/lighttpd /var/www

# copy continue file
COPY scripts/continue.sh ${ENV_DIR}/scripts/continue.sh
RUN chmod +x ${ENV_DIR}/scripts/continue.sh
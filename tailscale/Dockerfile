ARG BUILD_FROM
FROM $BUILD_FROM

LABEL io.hass.version="${BUILD_VERSION}" \
    io.hass.type="addon" \
    io.hass.arch="amd64, aarch64, armv7, armhf, i386"

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]

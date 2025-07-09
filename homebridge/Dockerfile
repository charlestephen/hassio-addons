ARG BUILD_FROM
FROM $BUILD_FROM

LABEL io.hass.type="addon"
LABEL io.hass.arch="amd64, aarch64, armhf, armv7, i386"
LABEL io.hass.version="${VERSION}"

# Copy entrypoint
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Launch add-on
CMD [ "/run.sh" ]

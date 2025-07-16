ARG BUILD_FROM

FROM $BUILD_FROM

ENV FORGEJO_WORK_DIR=/data \
    INSTALL_LOCK=true \
    DB_TYPE=sqlite3 \
    DB_HOST=localhost:3306 \
    DB_NAME=forgejo \
    DB_USER=root \
    DB_PASSWD="" \
    HTTP_PORT=3000 \
    SSH_LISTEN_PORT=22 \
    SSH_PORT=222

RUN apk --no-cache add \
    shadow \
    jq
rm -rf /var/cache/apk/*

COPY rootfs/ /

ARG BUILD_VERSION
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY

LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version="${BUILD_VERSION}" \
    maintainer="Charles Stephen Thompson <hassio@cst.wtf>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="CharleStephen's Hassio Add-ons" \
    org.opencontainers.image.authors="Charles Stephen Thompson <hassio@cst.wtf>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/charlestephen" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}

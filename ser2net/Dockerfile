ARG BUILD_FROM
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Build and install ser2net from source
# hadolint ignore=DL3018
RUN apk add --no-cache --virtual .build-deps \
        build-base pkgconf gensio-dev yaml-dev \
    && curl -fsSL -o /tmp/ser2net.tar.gz \
       "https://github.com/cminyard/ser2net/releases/download/v4.6.8/ser2net-4.6.8.tar.gz" \
    && tar -xzf /tmp/ser2net.tar.gz -C /tmp \
    && cd /tmp/ser2net-4.6.8 \
    && ./configure --prefix=/usr --sysconfdir=/etc \
    && make -j"$(nproc)" \
    && make install \
    && cd / \
    && apk del .build-deps \
    && apk add --no-cache gensio yaml \
    && rm -rf /tmp/ser2net*

# Copy root filesystem
COPY rootfs /

WORKDIR /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="John Hollowell <jhollowe@johnhollowell.com>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="jhollowe Home Assistant Addons" \
    org.opencontainers.image.authors="John Hollowell <jhollowe@johnhollowell.com>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}

# base image
# https://hub.docker.com/r/multiarch/ubuntu-debootstrap/tags/
ARG ARCH
ARG OS_VERSION
FROM multiarch/ubuntu-debootstrap:${ARCH}-${OS_VERSION} AS base

ENV PATH "/usr/local/bin:${PATH}"
WORKDIR /build
RUN uname -a
COPY install-deb-pkgs.sh .
RUN ./install-deb-pkgs.sh

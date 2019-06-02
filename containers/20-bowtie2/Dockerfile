ARG IMAGE_PREFIX
FROM ${IMAGE_PREFIX}10-deb-pkgs AS builder

COPY install-bowtie2.sh .
COPY bowtie2-2.3.4.1-build-on-arm.patch .
RUN ./install-bowtie2.sh

FROM ${IMAGE_PREFIX}10-deb-pkgs
COPY --from=builder /usr/local/bin/bowtie2* /usr/local/bin/

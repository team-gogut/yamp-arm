ARG IMAGE_PREFIX
FROM ${IMAGE_PREFIX}21-pip-pkgs

COPY install-deps.sh .
COPY fastqc-0.11.6-build-on-jdk-10.patch .
RUN ./install-deps.sh

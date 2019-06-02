#!/bin/bash

set -evo pipefail

# Base repository
# software-properties-common: for add-apt-repository.
# python and python-*: to install qiime.
apt-get update -qq
# To suppress warning: debconf: delaying package configuration, since apt-utils is not installed
apt-get install -yq --no-install-suggests --no-install-recommends \
  apt-utils
apt-get install -yq --no-install-suggests --no-install-recommends \
  ca-certificates \
  gcc \
  git \
  g++ \
  default-jre \
  make \
  patch \
  python \
  python3 \
  software-properties-common \
  unzip \
  vim \
  wget \
  zlib1g-dev

add-apt-repository universe
# Universe repository
# ant: to build fastqc
# mercurial: to download metaphlan2.
# metaphlan2: can not be installed
#   because the dependency bowtie2 is not installable on aarch64.
# fastqc: can not be installed
#   because the dependency libhtsjdk-java is not going to be installed on aarch64.
# qiime: https://packages.ubuntu.com/bionic/qiime
# samtools: https://packages.ubuntu.com/bionic/samtools
apt-get update -qq
apt-get install -yq --no-install-suggests --no-install-recommends \
  ant \
  libtbb-dev \
  mercurial \
  python-dev \
  python-pip \
  python-setuptools \
  python-wheel \
  python3-dev \
  python3-pip \
  python3-setuptools \
  python3-wheel \
  qiime \
  samtools

apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

java --version
python3 --version
samtools --version

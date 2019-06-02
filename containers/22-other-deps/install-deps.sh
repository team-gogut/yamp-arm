#!/bin/bash

# Install same version dependencies with x86_64 Dockerfile.

set -evo pipefail

pushd /usr/local/src

# Nextflow
# https://github.com/nextflow-io/nextflow/releases
wget -q https://github.com/nextflow-io/nextflow/archive/v19.01.0.tar.gz -O nextflow.tar.gz
# To prevent error exit status 141 by "<tar or cat> | head -1" with pipe.
tar tzvf nextflow.tar.gz > nextflow.tar.gz.files
head -1 nextflow.tar.gz.files
tar xzf nextflow.tar.gz
pushd nextflow-*
ln -s $(pwd)/nextflow /usr/local/bin/nextflow
popd
rm -f nextflow.tar.gz
nextflow -version

# bbmap: 37.10
# https://sourceforge.net/projects/bbmap/
wget -q https://sourceforge.net/projects/bbmap/files/BBMap_37.10.tar.gz/download -O bbmap.tar.gz
tar tzvf bbmap.tar.gz > bbmap.tar.gz.files
head -1 bbmap.tar.gz.files
tar xzf bbmap.tar.gz
pushd bbmap
ln -s $(pwd)/bbmap.sh /usr/local/bin/bbmap.sh
popd
rm -f bbmap.tar.gz
bbmap.sh --version

# fastqc: 0.11.5 used for x86_64 Dockerfile.
# But the tagged archive is from 0.11.6 on GitHub.
# http://www.bioinformatics.babraham.ac.uk/projects/fastqc/
wget -q https://github.com/s-andrews/FastQC/archive/v0.11.6.tar.gz -O fastqc.tar.gz
tar tzvf fastqc.tar.gz > fastqc.tar.gz.files
head -1 fastqc.tar.gz.files
tar xzf fastqc.tar.gz
pushd FastQC-*
# To fix an build error on JDK 10.
# https://github.com/s-andrews/FastQC/pull/30
cat /build/fastqc-0.11.6-build-on-jdk-10.patch | patch -p1
ant
chmod +x bin/fastqc
ln -s $(pwd)/bin/fastqc /usr/local/bin/fastqc
popd
rm -f fastqc.tar.gz
fastqc --version

# metaphlan2: 2.6.0
# https://bitbucket.org/biobakery/metaphlan2
# Asking an installation by pip command.
# https://bitbucket.org/biobakery/metaphlan2/issues/32
hg clone https://bitbucket.org/biobakery/metaphlan2
pushd metaphlan2
ln -s $(pwd)/metaphlan2.py /usr/local/bin/metaphlan2.py
popd

popd

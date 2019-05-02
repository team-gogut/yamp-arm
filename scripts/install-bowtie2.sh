#!/bin/bash

set -ev

pushd /usr/local/src

# bowtie2: 2.3.4.1
BOWTIE2_VERSION="2.3.4.1"

# Download by git to do "git submodule" in below process.
git clone https://github.com/BenLangmead/bowtie2.git
pushd bowtie2
git checkout "v${BOWTIE2_VERSION}"

# To build on ARM.
# https://github.com/BenLangmead/bowtie2/pull/216
# https://gitlab.com/arm-hpc/packages/wikis/packages/bowtie2
git clone https://github.com/nemequ/simde.git third_party/simde
sed -i 's/__m/simde__m/g' aligner_*
sed -i 's/__m/simde__m/g' sse_util*
sed -i 's/_mm_/simde_mm_/g' aligner_*
sed -i 's/_mm_/simde_mm_/g' sse_util*
cat /build/patches/bowtie2-2.3.4.1-build-on-arm.patch | patch -p1

uname -m
export CXXFLAGS="-Wno-deprecated-declarations -Wno-misleading-indentation -Wno-narrowing -Wno-unused-function -Wno-unused-result"

# A ping to prevent a timeout for the long command.
while sleep 9m; do
  echo "====[ $SECONDS seconds still running ]===="
done &

make install -j 4 \
  POPCNT_CAPABILITY=0 \
  NO_TBB=1

# Stop the ping.
kill %1

popd
bowtie2 --version

popd

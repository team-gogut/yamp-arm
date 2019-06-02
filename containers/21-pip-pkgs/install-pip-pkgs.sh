#!/bin/bash

set -evo pipefail

# humann2: 0.9.9
# https://pypi.org/project/humann2/
pip3 install --install-option='--bypass-dependencies-install' humann2==0.9.9

# awscli
# https://pypi.org/project/awscli/
pip3 install awscli==1.16.106

# qiime: 1.9.1
# http://qiime.org/
# https://pypi.org/project/qiime/
# qiime does not work on Python3.
# https://github.com/alesssia/YAMP/issues/11
# Comment out to install qiime by deb package.
# pip install qiime==1.9.1

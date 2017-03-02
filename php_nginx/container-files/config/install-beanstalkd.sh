#!/bin/bash

set -eu
version=1.10
beanstalkd_opt=/var/lib/beanstalkd

echo "=============================================================="
echo "Installing Beanstalkd ${version}...                              "
echo "=============================================================="

cd /tmp
wget https://github.com/kr/beanstalkd/archive/v$version.tar.gz
tar xf v$version.tar.gz
make -C beanstalkd-$version
make install -C beanstalkd-$version
rm -rf beanstalkd-$version v$version.tar.gz
mkdir -p $beanstalkd_opt
chown nobody:nobody $beanstalkd_opt
# Check etc/supervisor.d/beanstalkd.conf
echo && echo "Beanstalkd installed." && echo
#!/bin/bash

#
# Prerequisite:
# You must run this on CentOS 7 box. A CentOS 7 Vagrantfile is provided.
#

set -e

# Requirements for FPM
yum install -y epel-release ruby-devel gcc rpm-build
gem install fpm

CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

mkdir -p $CURRENT_DIR/build/usr/local

# Compile McRouter dependencies
yum install -y bzip2-devel libevent-devel libcap-devel scons unzip gflags-devel \
openssl-devel bison flex snappy-devel numactl-devel cyrus-sasl-devel cmake libtool \
glibc-devel.i686 glibc-devel.x86_64 gcc gcc-c++ zlib-devel autoconf automake \
double-conversion double-conversion-devel boost boost-devel glog glog-devel thrift thrift-devel

# Folly
cd $CURRENT_DIR/src/folly-0.47.0/folly
autoreconf -ivf
./configure --prefix=$CURRENT_DIR/build/usr/local
make clean && make && make install

# Ragel
cd $CURRENT_DIR/src/ragel-6.9
./configure --prefix=$CURRENT_DIR/build
make clean && make && make install

# Compile McRouter
cd $CURRENT_DIR/src/mcrouter/mcrouter
export LDFLAGS="-L$CURRENT_DIR/build/usr/local/lib -L/usr/local/lib -ldl"
export CXXFLAGS="-fpermissive"
autoreconf --install && ./configure --prefix=$CURRENT_DIR/build/usr/local
make clean && make && make install

# Run FPM to build RPM
fpm  -s dir -t rpm -n mcrouter --iteration 0 -v 0.1.0 -C $CURRENT_DIR/build \
--description "Mcrouter is a memcached protocol router for scaling memcached deployments" \
--depends bzip2-devel --depends libevent-devel --depends libcap-devel --depends scons --depends unzip \
--depends libtool --depends gflags-devel --depends openssl-devel --depends bison --depends flex \
--depends snappy-devel --depends numactl-devel --depends cyrus-sasl-devel --depends cmake \
--depends glibc-devel --depends gcc --depends gcc-c++ --depends zlib-devel \
--depends autoconf --depends automake --depends double-conversion --depends double-conversion-devel \
--depends boost --depends boost-devel --depends glog --depends glog-devel --depends thrift --depends thrift-devel $CURRENT_DIR

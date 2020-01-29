#!/bin/sh

mkdir tmp
cd tmp

#############################################
## download libressl-$VERSION

wget https://boringssl.googlesource.com/boringssl/+archive/refs/heads/master.tar.gz

#############################################
## clean dir

rm -rf boringssl
mkdir boringssl

#############################################
## unpack

tar -xvzf master.tar.gz -C boringssl
cd boringssl

#############################################
## build and install libressl

mkdir build && cd build

cmake -DCMAKE_BUILD_TYPE=Release ..
make
make install

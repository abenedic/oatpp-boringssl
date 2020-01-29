#!/bin/sh

cd third_party/boringssl
rm -rf build
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ../src
make




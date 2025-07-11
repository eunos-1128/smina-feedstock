#!/bin/bash

set -euxo pipefail

mkdir build
cd build

# Patch version.cpp
echo "const char* GIT_REV=\"${GIT_HASH}\";"    >  version.cpp
echo "const char* GIT_TAG=\"${PKG_VERSION}\";" >> version.cpp
echo "const char* GIT_BRANCH=\"conda-forge\";" >> version.cpp

sed -i.bak '/project(smina)/a find_package(Threads REQUIRED)' "${SRC_DIR}/CMakeLists.txt"

cmake ${SRC_DIR} ${CMAKE_ARGS} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    -DOPENBABEL_DIR="${PREFIX}"

make -j${CPU_COUNT}

cp smina ${PREFIX}/bin

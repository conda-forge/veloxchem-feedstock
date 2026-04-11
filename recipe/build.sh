#!/usr/bin/env bash
set -ex

# clean up unwanted compiler flags
#CXXFLAGS="${CXXFLAGS//-march=nocona}"
#CXXFLAGS="${CXXFLAGS//-mtune=haswell}"
#CXXFLAGS="${CXXFLAGS//-march=core2}"
#CXXFLAGS="${CXXFLAGS//-mssse3}"

# configure!
cmake ${CMAKE_ARGS} \
    -S"${SRC_DIR}" \
    -Bbuild \
    -GNinja \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_INSTALL_PREFIX:PATH="${PREFIX}" \
    -DCMAKE_CXX_COMPILER:STRING="${CXX}" \
    -DBUILD_SHARED_LIBS:BOOL=ON \
    -DCMAKE_FIND_FRAMEWORK:STRING=NEVER \
    -DCMAKE_FIND_APPBUNDLE:STRING=NEVER \
    -DENABLE_ARCH_FLAGS:BOOL=OFF \
    -DPython_EXECUTABLE:STRING="${PYTHON}" \
    -DPYMOD_INSTALL_FULLDIR:PATH="${SP_DIR#$PREFIX/}/veloxchem"

# build!
cmake --build build --parallel "${CPU_COUNT}" -- -v -d stats

# install!
cmake --build build --target install

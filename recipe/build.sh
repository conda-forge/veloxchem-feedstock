#!/usr/bin/env bash
set -ex

# clean up unwanted compiler flags
CXXFLAGS="${CXXFLAGS//-march=nocona}"
CXXFLAGS="${CXXFLAGS//-mtune=haswell}"
CXXFLAGS="${CXXFLAGS//-march=core2}"
CXXFLAGS="${CXXFLAGS//-mssse3}"

export CXX=$(basename ${CXX})

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" && "${mpi}" == "openmpi" ]]; then
  export OPAL_PREFIX="$PREFIX"
  export CC=mpicc
  export CXX=mpicxx
fi

# only used when configuring to detect location of xTB header files
export XTBHOME="$CONDA_PREFIX"

# configure!
cmake "${CMAKE_ARGS}" \
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
    -DVLX_LA_VENDOR:STRING="Generic" \
    -DPython_EXECUTABLE:STRING="${PYTHON}" \
    -DPYMOD_INSTALL_FULLDIR:PATH="${SP_DIR#$PREFIX/}/veloxchem" \
    -DMPI_CXX_SKIP_MPICXX:BOOL=ON

# build!
cmake --build build --parallel "${CPU_COUNT}" -- -v -d stats

# install!
cmake --build build --target install

#

sudo yum -y install atlas-devel
sudo yum -y install lapack

# Openblas is based on the famous - GotoBlas  - we should compare to Atlas

# This is not working with the SuitSparse build
#sudo yum -y install openblas
git clone https://github.com/xianyi/OpenBLAS.git
cd OpenBLAS/
mkdir locallibs
make
sudo make PREFIX=./locallibs install
sudo cp ./locallibs* /usr/lib64/
# Revisit - do we want to soft link.
################################

sudo yum -y install cmake

mkdir matrix-libs
cd matrix-libs/
wget http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-4.5.5.tar.gz

tar -xf SuiteSparse-4.5.5.tar.gz

cd SuiteSparse

# ----------------------------------------------------------------
# SuiteSparse package compilation options:
# ----------------------------------------------------------------

# SuiteSparse Version:      4.5.5
# SuiteSparse top folder:   /home/ec2-user/matrix-libs/SuiteSparse
# Package:                  LIBRARY=         PackageNameWillGoHere
# Version:                  VERSION=         x.y.z
# SO version:               SO_VERSION=      x
# System:                   UNAME=           Linux
# Install directory:        INSTALL=         /home/ec2-user/matrix-libs/SuiteSparse
# Install libraries in:     INSTALL_LIB=     /home/ec2-user/matrix-libs/SuiteSparse/lib
# Install include files in: INSTALL_INCLUDE= /home/ec2-user/matrix-libs/SuiteSparse/include
# Install documentation in: INSTALL_DOC=     /home/ec2-user/matrix-libs/SuiteSparse/share/doc/suitesparse-4.5.5
# Optimization level:       OPTIMIZATION=    -O3
# BLAS library:             BLAS=            -lopenblas
# LAPACK library:           LAPACK=          -llapack
# Intel TBB library:        TBB=
# Other libraries:          LDLIBS=          -lm -lrt -Wl,-rpath=/home/ec2-user/matrix-libs/SuiteSparse/lib
# static library:           AR_TARGET=       PackageNameWillGoHere.a
# shared library (full):    SO_TARGET=       PackageNameWillGoHere.so.x.y.z
# shared library (main):    SO_MAIN=         PackageNameWillGoHere.so.x
# shared library (short):   SO_PLAIN=        PackageNameWillGoHere.so
# shared library options:   SO_OPTS=         -L/home/ec2-user/matrix-libs/SuiteSparse/lib -shared -Wl,-soname -Wl,               PackageNameWillGoHere.so.x -Wl,--no-undefined
# shared library name tool: SO_INSTALL_NAME= echo
# ranlib, for static libs:  RANLIB=          ranlib
# static library command:   ARCHIVE=         ar rv
# copy file:                CP=              cp -f
# move file:                MV=              mv -f
# remove file:              RM=              rm -f
# pretty (for Tcov tests):  PRETTY=          grep -v "^#" | indent -bl -nce -bli0 -i4 -sob -l120
# C compiler:               CC=              cc
# C++ compiler:             CXX=             g++
# CUDA compiler:            NVCC=            echo
# CUDA root directory:      CUDA_PATH=
# OpenMP flags:             CFOPENMP=        -fopenmp
# C/C++ compiler flags:     CF=                 -O3 -fexceptions -fPIC -fopenmp
# LD flags:                 LDFLAGS=         -L/home/ec2-user/matrix-libs/SuiteSparse/lib
# Fortran compiler:         F77=             f77
# Fortran flags:            F77FLAGS=
# Intel MKL root:           MKLROOT=
# Auto detect Intel icc:    AUTOCC=          yes
# UMFPACK config:           UMFPACK_CONFIG=
# CHOLMOD config:           CHOLMOD_CONFIG=
# SuiteSparseQR config:     SPQR_CONFIG=
# CUDA library:             CUDART_LIB=
# CUBLAS library:           CUBLAS_LIB=
# METIS and CHOLMOD/Partition configuration:
# Your METIS library:       MY_METIS_LIB=
# Your metis.h is in:       MY_METIS_INC=
# METIS is used via the CHOLMOD/Partition module, configured as follows.
# If the next line has -DNPARTITION then METIS will not be used:
# CHOLMOD Partition config:
# CHOLMOD Partition libs:    -lccolamd -lcamd -lmetis
# CHOLMOD Partition include: -I/home/ec2-user/matrix-libs/SuiteSparse/CCOLAMD/Include -I/home/ec2-user/matrix-libs               /SuiteSparse/CAMD/Include -I/home/ec2-user/matrix-libs/SuiteSparse/metis-5.1.0/include

make config

make


#
# /usr/bin/ld: cannot find -llapack
# /usr/bin/ld: cannot find -lopenblas

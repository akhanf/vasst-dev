#!/bin/bash

if [ "$#" -lt 1 ]
then
echo "Usage: $0 <install folder (absolute path)>"
exit 0
fi

INSTALL=$1
mkdir -p $INSTALL

DCMNII_SRC=$INSTALL/dcm2niix-src
DCMNII_DIR=$INSTALL/dcm2niix
BIN_DIR=$INSTALL/local_install
mkdir -p $BIN_DIR


git clone https://github.com/rordenlab/dcm2niix.git $DCMNII_SRC

mkdir -p $DCMNII_DIR
pushd $DCMNII_DIR

cmake -DCMAKE_INSTALL_PREFIX=$BIN_DIR $DCMNII_SRC
make; make install

popd


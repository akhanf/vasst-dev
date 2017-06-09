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


git clone https://github.com/rordenlab/dcm2niix.git $DCMNII_SRC

mkdir -p $DCMNII_DIR
pushd $DCMNII_DIR

cmake -DCMAKE_INSTALL_PREFIX=$DCMNII_DIR $DCMNII_SRC
make; make install

popd

INIT=$INSTALL/init.d
INIT_DCMNII=$INIT/dcm2niix.sh
mkdir -p $INIT

#create init script
echo "#/bin/bash" > $INIT_DCMNII
echo "export PATH=$DCMNII_DIR/bin:\$PATH" >> $INIT_DCMNII


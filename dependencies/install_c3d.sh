#!/bin/bash

if [ "$#" -lt 1 ]
then
echo "Usage: $0 <install folder (absolute path)>"
exit 0
fi

INSTALL=$1
mkdir -p $INSTALL

VERSION=c3d-1.1.0-Linux-x86_64

C3D_DIR=$INSTALL/$VERSION
mkdir -p $C3D_DIR

pushd $INSTALL

wget https://downloads.sourceforge.net/project/c3d/c3d/Experimental/$VERSION.tar.gz

tar -xvzf $VERSION.tar.gz
rm -f $VERSION.tar.gz


popd

INIT=$INSTALL/init.d
INIT_C3D=$INIT/c3d.sh
mkdir -p $INIT

#create init script
echo "#/bin/bash" > $INIT_C3D
echo "export PATH=$C3D_DIR/bin:\$PATH" >> $INIT_C3D
echo "export LD_LIBRARY_PATH=$C3D_DIR/lib/c3d_gui-1.1.0:\$LD_LIBRARY_PATH" >> $INIT_C3D


#!/bin/bash

if [ "$#" -lt 1 ]
then
echo "Usage: $0 <install folder (absolute path)>"
exit 0
fi

INSTALL=$1
mkdir -p $INSTALL

#save latest repo version to folder with date
LATEST=camino-`date +%F`
SRC=$INSTALL/$LATEST

git clone git://git.code.sf.net/p/camino/code  $SRC

pushd $SRC
make
popd

#reset symlink to latest
rm -f $INSTALL/camino
ln -s $LATEST $INSTALL/camino


INIT=$INSTALL/init.d
INIT_CAMINO=$INIT/camino.sh
mkdir -p $INIT

#create init script
echo "#/bin/bash" > $INIT_CAMINO
echo "export MANPATH=$INSTALL/camino/man:\$MANPATH" >> $INIT_CAMINO
echo "export PATH=$INSTALL/camino/bin:\$PATH" >> $INIT_CAMINO
echo "export CAMINO_HEAP_SIZE=12000"  >> $INIT_CAMINO

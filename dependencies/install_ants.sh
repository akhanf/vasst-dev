#!/bin/bash

if [ "$#" -lt 1 ]
then
echo "Usage: $0 <install folder (absolute path)>"
exit 0
fi

INSTALL=$1
mkdir -p $INSTALL

curl -L --retry 5 https://dl.dropbox.com/s/2f4sui1z6lcgyek/ANTs-Linux-centos5_x86_64-v2.2.0-0740f91.tar.gz | tar zx -C $INSTALL

INIT=$INSTALL/init.d
INIT_ANTS=$INIT/ants.sh
mkdir -p $INIT

#create init script
echo "#/bin/bash" > $INIT_ANTS
echo "export ANTSPATH=$INSTALL/ants" >> $INIT_ANTS
echo "export PATH=$INSTALL/ants:\$PATH" >> $INIT_ANTS


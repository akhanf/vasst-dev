#!/bin/bash

if [ "$#" -lt 1 ]
then
echo "Usage: $0 <install folder (absolute path)>"
exit 0
fi

INSTALL=$1
mkdir -p $INSTALL

#install dependencies:
apt-get update && apt-get install -y libeigen3-dev zlib1g-dev && apt-get clean

#download source and install
git clone https://github.com/MRtrix3/mrtrix3.git $INSTALL/mrtrix3
pushd $INSTALL/mrtrix3
./configure -nogui
./build

INIT=$INSTALL/init.d
INIT_MRTRIX=$INIT/mrtrix3.sh
mkdir -p $INIT

#create init script
echo "#/bin/bash" > $INIT_MRTRIX
echo "export PATH=$INSTALL/mrtrix3/bin:\$PATH" >> $INIT_MRTRIX

popd

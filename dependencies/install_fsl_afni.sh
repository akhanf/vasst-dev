#!/bin/bash

if [ "$#" -lt 1 ]
then
echo "Requires NeuroDebian repository to be set-up"
echo "Usage: $0 <install folder (absolute path)>"
exit 0
fi

INSTALL=$1
mkdir -p $INSTALL

apt-get install fsl-core fsl-atlases fsl-5.0-eddy-nonfree afni
INIT=$INSTALL/init.d
mkdir -p $INIT

ln -s /etc/fsl/5.0/fsl.sh $INIT
ln -s /etc/afni/afni.sh $INIT




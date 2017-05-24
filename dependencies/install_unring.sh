#!/bin/bash

if [ "$#" -lt 1 ]
then
echo "Usage: $0 <install folder (absolute path)>"
exit 0
fi

INSTALL=$1
mkdir -p $INSTALL


#save latest repo version to folder with date
SRC=$INSTALL/unring

if [ -e $SRC ]
then
 echo "unring src already exists -- please remove or change install directory"
 exit 1
fi


git clone https://bitbucket.org/reisert/unring.git $SRC

BIN=$INSTALL/unring/bin
mkdir -p $BIN

#move binary to 
if [ -e $SRC/fsl/unring.a64 ]
then

 cp -v $SRC/fsl/unring.a64 $BIN/unring

else
 echo "Binary $SRC/fsl/unring.a64 does not exist for unring!"
 echo "Cannot complete install.."
 exit 1
fi

INIT=$INSTALL/init.d
INIT_UNRING=$INIT/unring.sh
mkdir -p $INIT

#create init script
echo "#/bin/bash" > $INIT_UNRING
echo "export PATH=$INSTALL/unring/bin:\$PATH" >> $INIT_UNRING


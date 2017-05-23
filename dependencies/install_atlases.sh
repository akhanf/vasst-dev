#!/bin/bash


if [ "$#" -lt 1 ]
then
echo "Usage: $0 <install folder (absolute path)>"
exit 0
fi

INSTALL=$1
mkdir -p $INSTALL


#currently retrieving from dropbox -- update this later to use OSF 
wget --max-redirect=20 -O $INSTALL/atlases.tar https://www.dropbox.com/s/q8l2ap16s5so2ct/atlases.tar
pushd $INSTALL
tar -xvf atlases.tar 
rm -f atlases.tar
popd

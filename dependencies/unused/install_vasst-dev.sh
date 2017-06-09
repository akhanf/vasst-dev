#!/bin/bash

if [ "$#" -lt 1 ]
then
echo "Usage: $0 <install folder (absolute path)>"
exit 0
fi

INSTALL=$1
mkdir -p $INSTALL

git clone https://github.com/akhanf/vasst-dev $INSTALL/vasst-dev

INIT=$INSTALL/init.d
INIT_VASST=$INIT/vasst-dev.sh
mkdir -p $INIT

#create init script
echo "#/bin/bash" > $INIT_VASST
echo "export VASST_DEV_HOME=$INSTALL/vasst-dev" >> $INIT_VASST
echo "export PIPELINE_ATLAS_DIR=$INSTALL/atlases" >> $INIT_VASST
echo ". $INSTALL/vasst-dev/init_vasst_dev.sh"  >> $INIT_VASST

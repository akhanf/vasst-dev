#!/bin/bash

if [ "$#" -lt 1 ]
then
echo "Usage: $0 <install folder (absolute path)>"
exit 0
fi

INSTALL=$1
mkdir -p $INSTALL

NIFTY_VER=1.3.9
NIFTY_SRC=$INSTALL/niftyreg-src
NIFTY_DIR=$INSTALL/niftyreg


#RUN apt-get update && apt-get install -qy \
#build-essential \
#cmake-curses-gui \
#curl \
#libpng12-dev \
#zlib1g-dev && \
mkdir -p $NIFTY_SRC && \
  echo "Downloading http://sourceforge.net/projects/niftyreg/files/nifty_reg-${NIFTY_VER}/nifty_reg-${NIFTY_VER}.tar.gz/download" && \
  curl -L http://sourceforge.net/projects/niftyreg/files/nifty_reg-${NIFTY_VER}/nifty_reg-${NIFTY_VER}.tar.gz/download \
    | tar xz -C $NIFTY_SRC --strip-components 1 && \
mkdir -p $NIFTY_DIR && \
cd $NIFTY_DIR  && \
cmake $NIFTY_SRC \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=OFF \
    -DBUILD_TESTING=OFF \
    -DCMAKE_INSTALL_PREFIX=$NIFTY_DIR  && \
  make -j$(nproc) && \
  make install 


INIT=$INSTALL/init.d
INIT_NIFTYREG=$INIT/niftyreg.sh
mkdir -p $INIT

#create init script
echo "#/bin/bash" > $INIT_NIFTYREG
echo "export LD_LIBRARY_PATH=$NIFTY_DIR/lib:\$LD_LIBRARY_PATH" >> $INIT_NIFTYREG
echo "export PATH=$NIFTY_DIR/bin:\$PATH" >> $INIT_NIFTYREG


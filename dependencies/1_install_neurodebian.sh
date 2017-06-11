#!/bin/bash

if [ "$#" -lt 1 ]
then
echo "Usage: $0 <install folder (absolute path)>"
exit 0
fi

INSTALL=$1
mkdir -p $INSTALL

key=$INSTALL/neurodebian.gpg
wget --max-redirect=20 -O $key https://www.dropbox.com/s/d13u0pqjoraqpyd/neurodebian.gpg

apt-get install -y --no-install-recommends curl bzip2 ca-certificates xvfb && \
    curl -sSL http://neuro.debian.net/lists/xenial.us-ca.full >> /etc/apt/sources.list.d/neurodebian.sources.list && \
    apt-key add $key && \
#    (apt-key adv --refresh-keys --keyserver hkp://ha.pool.sks-keyservers.net 0xA5D32F012649A5A9 || true) && \
    apt-get update

rm -f $key


#!/bin/bash

in_key=`dirname $0`/../keys/neurodebian.gpg

apt-get install -y --no-install-recommends curl bzip2 ca-certificates xvfb && \
    curl -sSL http://neuro.debian.net/lists/xenial.us-ca.full >> /etc/apt/sources.list.d/neurodebian.sources.list && \
    apt-key add $in_key && \
    (apt-key adv --refresh-keys --keyserver hkp://ha.pool.sks-keyservers.net 0xA5D32F012649A5A9 || true) && \
    apt-get update




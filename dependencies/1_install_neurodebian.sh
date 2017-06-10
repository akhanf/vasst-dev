#!/bin/bash

wget -O- http://neuro.debian.net/lists/xenial.us-nh.full | tee /etc/apt/sources.list.d/neurodebian.sources.list
apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9


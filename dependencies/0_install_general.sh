#!/bin/bash

if [ "$#" -lt 1 ]
then
echo "Requires access to apt-get"
echo "Usage: $0 <install folder (absolute path)>"
exit 0
fi

#note: install folder is not used..
apt-get install  -y \
  bison \
  build-essential \
  cmake \
  cmake-curses-gui \
  flex \
  g++ \
  git \
  graphviz \
  imagemagick \
  liboctave-dev \
  libxi-dev \
  libxi6 \
  libxmu-dev \
  libxmu-headers \
  libxmu6 \
  unzip \
  xpdf \
  wget \ 
curl \
openjdk-9-jdk-headless \ 
vim \
bzip2 


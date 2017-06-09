#!/bin/bash

if [ "$#" -lt 1 ]
then
echo "Usage: $0 <install folder (absolute path)>"
exit 0
fi

INSTALL=$1
mkdir -p $INSTALL

VERSION=6.0.0

pushd $INSTALL
#if false
#then
wget  ftp://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/$VERSION/freesurfer-Linux-centos6_x86_64-stable-pub-v${VERSION}.tar.gz
tar -xvzf freesurfer-Linux-centos6_x86_64-stable-pub-v$VERSION.tar.gz \
    --exclude='freesurfer/trctrain' \
    --exclude='freesurfer/subjects/fsaverage_sym' \
    --exclude='freesurfer/subjects/fsaverage3' \
    --exclude='freesurfer/subjects/fsaverage4' \
    --exclude='freesurfer/subjects/fsaverage5' \
    --exclude='freesurfer/subjects/fsaverage6' \
    --exclude='freesurfer/subjects/cvs_avg35' \
    --exclude='freesurfer/subjects/cvs_avg35_inMNI152' \
    --exclude='freesurfer/subjects/bert' \
    --exclude='freesurfer/subjects/V1_average' \
    --exclude='freesurfer/average/mult-comp-cor' \
    --exclude='freesurfer/lib/cuda' \
    --exclude='freesurfer/lib/qt'
rm freesurfer-Linux-centos6_x86_64-stable-pub-v$VERSION.tar.gz
#fi
popd

INIT=$INSTALL/init.d
INIT_FS=$INIT/freesurfer.sh
mkdir -p $INIT

#create init script
echo "#/bin/bash" > $INIT_FS
echo "export FREESURFER_HOME=$INSTALL/freesurfer" >> $INIT_FS
echo ". $INSTALL/freesurfer/SetUpFreeSurfer.sh" >> $INIT_FS


#need to add license as well

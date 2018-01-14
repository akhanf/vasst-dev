Bootstrap: shub
From: khanlab/neuroglia-core

%labels
Maintainer "Ali Khan"

#########
%setup
#########
mkdir -p $SINGULARITY_ROOTFS/opt/vasst-dev
cp -Rv . $SINGULARITY_ROOTFS/opt/vasst-dev

#########
%post
#########

SINGULARITY_TAG=${SINGULARITY_BUILDDEF#Singularity.}

cd /opt/vasst-dev
if [ ! "$SINGULARITY_TAG" = "latest" ]
then
  git checkout $SINGULARITY_TAG
fi

echo addpath\(genpath\(\'${PIPELINE_TOOL_DIR}/matlab\'\)\)\; >> /etc/octave.conf 

cd /opt/vasst-dev/install_scripts
export DEBIAN_FRONTEND=noninteractive

bash 05.install_MCR.sh /opt v92 R2017a
bash 21.install_MRtrix3_by_source_sudo.sh /opt
bash 27.install_vasst_dev_atlases_by_source.sh /opt
bash 28.install_camino_by_source.sh /opt
bash 29.install_unring_by_binary.sh /opt
bash 30.install_dke_by_binary.sh /opt


#########
%environment


#MRtrix3
export PATH=/opt/mrtrix3/bin:$PATH

#vasst-dev
export VASST_DEV_HOME=/opt/vasst-dev
export PIPELINE_ATLAS_DIR=/opt/atlases
export PIPELINE_DIR=$VASST_DEV_HOME/pipeline
export PIPELINE_TOOL_DIR=$VASST_DEV_HOME/tools
MIAL_DEPENDS_DIR=$VASST_DEV_HOME/mial-depends
#MIAL_DEPENDS_LIBS=$VASST_DEV_HOME/mial-depends/lib
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MIAL_DEPENDS_LIBS
export PIPELINE_CFG_DIR=$PIPELINE_DIR/cfg
export PATH=$PIPELINE_TOOL_DIR:$MIAL_DEPENDS_DIR:$PATH
export MCRBINS=$VASST_DEV_HOME/mcr/v92
for name in `ls -d $PIPELINE_DIR/*`; do  export PATH=$name:$PATH; done
#mcr - vasst-dev dependency
export MCRROOT=/opt/mcr/v92



#camino
export PATH=/opt/camino/bin:$PATH
export LD_LIBRARY_PATH=/opt/camino/lib:$LD_LIBRARY_PATH
export MANPATH=/opt/camino/lib:$MANPATH
export CAMINO_HEAP_SIZE=32000

#unring
export PATH=/opt/unring/bin:$PATH


#dke
export PATH=/opt/dke:$PATH




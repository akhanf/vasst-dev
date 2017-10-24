#!/bin/bash

#
#  To install, add the following to your ~/.bashrc
#
# VASST_DEV_HOME=<path to your repository>/vasst-dev
# if [ -f $VASST_DEV_HOME/init_vasst_dev.sh ]
# then
#  . $VASST_DEV_HOME/init_vasst_dev.sh
# fi
#
#


if [ ! -n "$PIPELINE_ATLAS_DIR" ]
then
  std_dir=/eq-nas/$USER/EpilepsyDatabase/standard/
  export PIPELINE_ATLAS_DIR=$std_dir/projects/atlases
  echo "Defining default PIPELINE_ATLAS_DIR, $PIPELINE_ATLAS_DIR"
else
  echo PIPELINE_ATLAS_DIR already defined as $PIPELINE_ATLAS_DIR
fi

if [ ! -n "$VASST_DEV_HOME" ]
then
  export VASST_DEV_HOME=/cluster/software/vasst-dev
  echo "Defining default VASST_DEV_HOME, $VASST_DEV_HOME" 
else
  export VASST_DEV_HOME
 echo "VASST_DEV_HOME already defined as $VASST_DEV_HOME"
fi


export PIPELINE_DIR=$VASST_DEV_HOME/pipeline
export PIPELINE_TOOL_DIR=$VASST_DEV_HOME/tools

MIAL_DEPENDS_DIR=$VASST_DEV_HOME/mial-depends

MIAL_DEPENDS_LIBS=$VASST_DEV_HOME/mial-depends/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MIAL_DEPENDS_LIBS

export PIPELINE_CFG_DIR=$PIPELINE_DIR/cfg

export PATH="$PIPELINE_DIR:$PIPELINE_DIR/fmri:$PIPELINE_DIR/diffusion:$PIPELINE_DIR/registration:$PIPELINE_DIR/t1:$PIPELINE_DIR/batch:$PIPELINE_DIR/import:$PIPELINE_DIR/qc:$PIPELINE_TOOL_DIR:$MIAL_DEPENDS_DIR:$PATH"

export MCRBINS=$VASST_DEV_HOME/mcr/v92

pushd $PIPELINE_DIR > /dev/null
echo -n "adding to path: "
for name in `ls -d *`
do
 echo -n "$name "
 export PATH="$PIPELINE_DIR/$name:$PATH"
done
popd > /dev/null
echo ""

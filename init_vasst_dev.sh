#!/bin/bash


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
 echo "VASST_DEV_HOME already defined as $VASST_DEV_HOME"
fi


PIPELINE_DIR=$VASST_DEV_HOME/pipeline
PIPELINE_TOOL_DIR=$VASST_DEV_HOME/tools

export PIPELINE_CFG_DIR=$PIPELINE_DIR/cfg
export PATH="$PIPELINE_DIR:$PIPELINE_DIR/fmri:$PIPELINE_DIR/diffusion:$PIPELINE_DIR/registration:$PIPELINE_DIR/t1:$PIPELINE_DIR/batch:$PIPELINE_DIR/import:$PIPELINE_DIR/qc:$PIPELINE_TOOL_DIR:$PATH"



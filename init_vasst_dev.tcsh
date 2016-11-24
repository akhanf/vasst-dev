#!/bin/bash

#
#  To install, add the following to your ~/.bashrc
#
#
# setenv PIPELINE_ATLAS_DIR ~/software/atlases
# setenv VASST_DEV_HOME ~/software/vasst-dev
#
# if ( -f "$VASST_DEV_HOME/init_vasst_dev.tcsh" ) then
#  source $VASST_DEV_HOME/init_vasst_dev.tcsh
# endif
#
#


if ( ! $?PIPELINE_ATLAS_DIR ) then
  setenv std_dir /eq-nas/${USER}/EpilepsyDatabase/standard/
  setenv PIPELINE_ATLAS_DIR $std_dir/projects/atlases
   echo "Defining default PIPELINE_ATLAS_DIR, $PIPELINE_ATLAS_DIR"
else
  echo PIPELINE_ATLAS_DIR already defined as $PIPELINE_ATLAS_DIR
endif

if ( ! $?VASST_DEV_HOME ) then
  setenv VASST_DEV_HOME /cluster/software/vasst-dev
  echo "Defining default VASST_DEV_HOME, $VASST_DEV_HOME" 
else
 echo "VASST_DEV_HOME already defined as $VASST_DEV_HOME"
endif


setenv PIPELINE_DIR $VASST_DEV_HOME/pipeline
setenv PIPELINE_TOOL_DIR $VASST_DEV_HOME/tools

setenv PIPELINE_CFG_DIR $PIPELINE_DIR/cfg
setenv PATH "${PIPELINE_DIR}:${PIPELINE_DIR}/fmri:${PIPELINE_DIR}/diffusion:${PIPELINE_DIR}/registration:${PIPELINE_DIR}/t1:${PIPELINE_DIR}/batch:${PIPELINE_DIR}/import:${PIPELINE_DIR}/qc:${PIPELINE_TOOL_DIR}:${PATH}"



#!/bin/bash


umask 002

export SVN_EDITOR=vim

#SW_DIR=/cluster/software
SW_DIR=/eq-nas/$USER/khangrp/software/cluster_backup_2017_05_10

#set up vasst-dev if not set-up already..
if [ ! -n "$PIPELINE_DIR" ]
then

if [ -f $SW_DIR/vasst-dev/init_vasst_dev.sh ]
then
 . $SW_DIR/vasst-dev/init_vasst_dev.sh
fi

fi

#for setting up traditional environment with NeuroDeb fsl
. /etc/fsl/5.0/fsl.sh

FREESURFER_HOME=$SW_DIR/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

MIAL_TOOLS_BIN=$SW_DIR/mial-tools/bin/x86_64
MIAL_TOOLS_SCRIPTS=$SW_DIR/mial-tools/scripts
GEN_DEPEND=$MIAL_TOOLS_SCRIPTS/genDependencies
GROUPWISE_LDDMM=$MIAL_TOOLS_SCRIPTS/groupwiseLDDMM
SW_BIN=$SW_DIR/bin

#camino
CAMINO_BIN=$SW_DIR/camino/bin
CAMINO_MAN=$SW_DIR/camino/man
export CAMINO_HEAP_SIZE=12000
export MANPATH=$MANPATH:$CAMINO_MAN

hostname=`hostname`
if [ "$hostname" = "myelin" ]
then
NIFTYREG_DIR=$SW_DIR/nifty_reg_openmp/nifty_reg/reg-apps
else
NIFTYREG_DIR=$SW_DIR/nifty_reg/nifty_reg/reg-apps
fi


ASHS_ROOT=$SW_DIR/ashs_Linux64_rev103_20140612
export ASHS_ROOT
C3D_DIR=$SW_DIR/c3d/bin
BFTOOLS_DIR=$SW_DIR/bftools

CAIN_PIPELINE_DIR=/eq-nas/$USER/EpilepsyHistology/CAIN2/pipeline/bin
export CAIN_PIPELINE_DIR

ANTSPATH=$SW_DIR/ANTs-1.9.x-Linux/bin/
export ANTSPATH


NIFTYREC_DIR=$SW_DIR/NiftyRec-install/niftyrec/bin/command_line_tools
NIFTYREC_LIB=$SW_DIR/NiftyRec-install/lib

LDDMM_DIR=$SW_DIR/lddmm/bin/x86_64

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$NIFTYREC_LIB

AFNI_DIR=$SW_DIR/afni

#MINICONDA=/cluster/software/miniconda3/bin

ANACONDA2=$SW_DIR/anaconda2/bin

CAMINOTRACKVIS_DIR=$SW_DIR/camino-trackvis/bin
TRACKVIS_DIR=$SW_DIR/TrackVis

PATH="$ASHS_ROOT/bin:$TRACKVIS_DIR:$CAMINOTRACKVIS_DIR:$NIFTYREC_DIR:$BFTOOLS_DIR:$CAIN_PIPELINE_DIR:$C3D_DIR:$GEN_DEPEND:$GROUPWISE_LDDMM:$NIFTYREG_DIR:$CAMINO_BIN:$SW_BIN:$MIAL_TOOLS_SCRIPTS:$MIAL_TOOLS_BIN:$ANTSPATH:$AFNI_DIR:$LDDMM_DIR:$ANACONDA2:$PATH"



#torque/maui
PATH="/usr/local/bin:/opt/torque/sbin:/opt/torque/bin:/opt/maui/sbin:/opt/maui/bin:$PATH"




#eventually change this to point to local SVN/GIT repository 
#std_dir=/eq-nas/$USER/EpilepsyDatabase/standard/

#export VASST_DEV_HOME=$SW_DIR/vasst-dev

#PIPELINE_DIR=$VASST_DEV_HOME/pipeline
#PIPELINE_TOOL_DIR=$VASST_DEV_HOME/tools

#export PIPELINE_ATLAS_DIR=$std_dir/projects/atlases
#export PIPELINE_CFG_DIR=$PIPELINE_DIR/cfg
#export PATH="$PIPELINE_DIR:$PIPELINE_DIR/fmri:$PIPELINE_DIR/diffusion:$PIPELINE_DIR/registration:$PIPELINE_DIR/t1:$PIPELINE_DIR/batch:$PIPELINE_DIR/import:$PIPELINE_DIR/qc:$PIPELINE_TOOL_DIR:$PATH"


# add custom path (for fluidmatch)
if [ "$hostname" = "Sleepy" ]
then
 export PATH="$SW_DIR/mial-tools/bin/$hostname:$PATH"
fi


#need to add these to ~/matlab/startup.m
export MIAL_TOOLS_MATLAB=$SW_DIR/mial-tools
export PIPELINE_MATLAB=$PIPELINE_TOOL_DIR/matlab
export CAIN2_MATLAB=/eq-nas/$USER/EpilepsyHistology/CAIN2/pipeline/matlab



#cfmm braincode pipelines
PIPELINES_ROOT=$SW_DIR/cfmm/xnat_pipelines

return





### old, either reinstall or remove:

DTK_BIN=$SW_DIR/dtk
CAMINOTRACKVIS_BIN=$SW_DIR/camino_trackvis

#itk
ITK_DIR=$SW_DIR/itk
export ITK_DIR

#vtk
VTK_DIR=$SW_DIR/vtk
export VTK_DIR

#home bin:
HOME_BIN=$HOME/bin

DICOM_BIN=$HOME/epilepsy/shared_data/scripts/dicom

SVM_BIN=$SW_DIR/svm-light

#bx
BRAINTOOLSDIR=$SW_DIR/bx
export BRAINTOOLSDIR

#ants
ANTSPATH=$SW_DIR/ANTs-1.9.x-Linux/bin/
export ANTSPATH

Paraview=$SW_DIR/ParaView-3.98.0-RC1-Linux-64bit/bin

EPI_SCRIPTS=$HOME/epilepsy/shared_data/scripts
EPI_DTI_SCRIPTS=$HOME/epilepsy/shared_data/scripts/dti
EPI_WRAP=$HOME/epilepsy/shared_data/scripts/wrappers


MRTRIX=/usr/lib/mrtrix/bin

#set-up PATH for DKE (MCR 2012a)
export PATH="$PATH:/cluster/software/dke/mcr_2012a/v717/runtime/glnxa64:/cluster/software/dke/mcr_2012a/v717/bin/glnxa64:/cluster/software/dke/mcr_2012a/v717/sys/os/glnxa64:/cluster/software/dke/mcr_2012a/v717/sys/java/jre/glnxa64/jre/lib/amd64/native_threads:/cluster/software/dke/mcr_2012a/v717/sys/java/jre/glnxa64/jre/lib/amd64/server:/cluster/software/dke/mcr_2012a/v717/sys/java/jre/glnxa64/jre/lib/amd64"
export XAPPLRESDIR=/cluster/software/dke/mcr_2012a/v717/X11/app-defaults





#PATH="$MRTRIX:$GROUPWISE_LDDMM:$Paraview:$EPI_WRAP:$NIFTYREG_DIR:$ANTSPATH:$CAMINOTRACKVIS_BIN:$DTK_BIN:$BRAINTOOLSDIR/bin:$SVM_BIN:$DICOM_BIN:$CAMINO_BIN:$NIFTYREG_DIR:$SW_BIN:$MIAL_TOOLS_SCRIPTS:$MIAL_TOOLS_BIN:$EPI_SCRIPTS:$EPI_DTI_SCRIPTS:$HOME_BIN:$LDDMM_DIR:$PATH"


#!/bin/bash

if [ "$#" -lt 3 ]
then
 echo "Usage: $0 <input bids folder> <output folder> <analysis level (participant)>"
 exit 0
fi


in_bids=`realpath $1`
out_folder=`realpath $2`
analysis_level=$3

if [ "$analysis_level" = "participant" ]
then
 echo " running participant level analysis"
 else
  echo "only participant level analysis is enabled"
  exit 0
fi

dwi_prefix=multiband

participants=`realpath $in_bids/participants.tsv`

mkdir -p $out_folder
pushd $out_folder
echo $participants
for subjline in `grep sub- $participants`
do
 subj=${subjline%%,*}

 Ndwi=`ls $in_bids/$subj/dwi/${subj}_acq-${dwi_prefix}*_dwi.nii.gz | wc -l`
 importDWI ${dwi_prefix} $Ndwi $in_bids/$subj/dwi/${subj}_acq-${dwi_prefix}*_dwi.nii.gz $subj
 processDwiDenoise multiband $subj
 processUnring multiband_denoise $subj
 processTopUp multiband_denoise_unring_topup $subj
 processEddy multiband_denoise_unring $subj


done


popd

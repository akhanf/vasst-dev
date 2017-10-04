#!/bin/bash

if [ "$#" -lt 3 ]
then
 echo "Usage: $0 <input bids folder> <output folder> <subject list>"
 exit 0
fi


in_bids=`realpath $1`
out_folder=`realpath $2`
subjlist=`realpath $3`

dwi_prefix=multiband

mkdir -p $out_folder
pushd $out_folder

for subj in `cat $subjlist`
do

 Ndwi=`ls $in_bids/$subj/dwi/${subj}_acq-${dwi_prefix}*_dwi.nii.gz | wc -l`
 importDWI ${dwi_prefix} $Ndwi $in_bids/$subj/dwi/${subj}_acq-${dwi_prefix}*_dwi.nii.gz $subj
 processDwiDenoise multiband $subj
 processUnring multiband_denoise $subj
 processTopUp multiband_denoise_unring_topup $subj
 processEddy multiband_denoise_unring $subj

done

popd

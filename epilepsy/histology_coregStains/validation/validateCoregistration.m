

addpath('~/epilepsy/shared_data/scripts/histology');

subjs={'EPI_P006','EPI_P014','EPI_P015'};
stains={'NEUN','GFAP'};
struct='Neo';

datadir='~/epilepsy/Histology';
datadir='~/epilepsy/Histology';
coreg_dir='~/epilepsy/local_data/coregisterStainsToHE';

csvfiles=importdata('validation_csv_files');

% for each HE lmk:
%   
%     ~/epilepsy/Histology/EPI_P006/val_lmks/EPI_P006_A04_HE_100um_nii.csv
%
%
% load it up

dist=cell(length(stains),1);

for i=1:length(csvfiles)
   
    lmks_ref=importdata(csvfiles{i});
    lmks_ref=lmks_ref(:,1:2);
    
    %lmks_stain=cell(length(stains),1);
    warp_lmks_stain=cell(length(stains),1);
    
    for s=1:length(stains)
    
      subj=csvfiles{i}(end-31:end-24);
      block=csvfiles{i}(end-18:end-17);
      
      warp_csv=sprintf('%s/%s/Hist/Processed/coregisterToHE/%s_%s_%s_%s_100um_nii_xfmToHE.csv' ,coreg_dir,subj,subj,struct,block,stains{s});
      warp_lmks_stain{s}=importdata(warp_csv);  
      %csv_stain=[csvfiles{i}(1:end-16) stains{s} '_100um_nii.csv'];
      %lmks_stain{s}=importdata(csv_stain);
    warp_lmks_stain{s}=warp_lmks_stain{s}(:,1:2);
      
      %get flirt xfm
   %   flirt_xfm=sprintf('../%s/Hist/Processed/coregisterToHE/flirt_%s_%s_%s-HE.xfm',subj,subj,block,stains{s});
  %    warp_lmks_stain{s}=warpHistNiiCoordsFlirt([ lmks_stain{s}(:,1), lmks_stain{s}(:,2) ],flirt_xfm,0);
      
        %%% flirt xfm is not transforming the points properly!
        % img2imgcoord works fine.. could be need to xfm voxels not mm...
      
    %euclidean distance:
    lmkdist=sqrt(sum((lmks_ref-warp_lmks_stain{s}).^2,2));
    dist{s}=[dist{s}; lmkdist];
    disp(sprintf('%s, num landmarks: %d, mean dist: %g',warp_csv(end-41:end),size(lmkdist,1),mean(lmkdist)));
    end
    

end
    
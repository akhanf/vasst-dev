% generate heat maps for each combination of transformation model and cost
% function

function genErrorHeatMap(transformationModel,costFunction,lookupTable)

dir=('~/khangrp/projects/unsorted/averageDeepBrain7T/7THippAtlas/');

lookup=importdata(lookupTable,' ');


if strcmp(costFunction, "t1") || strcmp(costFunction, "t2")

    % import average distances
    dist_L=importdata(sprintf('%s/eucDistDir/avgDistDir/%s_%s/avgAllSubj.l.10.dist_mm.txt',dir,transformationModel,costFunction),' ');
    dist_R=importdata(sprintf('%s/eucDistDir/avgDistDir/%s_%s/avgAllSubj.r.10.dist_mm.txt',dir,transformationModel,costFunction),' ');
    
    % load nifti of checkerboard file
    nii_L=load_nifti('V025/labels/t2/checkerboard/checkerboard.l.10.reorient.06mm.affineAtlasSpace.crop.corr.nii.gz');
    vol_L=nii_L.vol;
    nii_R=load_nifti('V025/labels/t2/checkerboard/checkerboard.r.10.reorient.06mm.affineAtlasSpace.crop.corr.nii.gz');
    vol_R=nii_R.vol;
    
    heatmap_L=zeros(size(vol_L,1),size(vol_L,2),size(vol_L,3));
    heatmap_R=zeros(size(vol_R,1),size(vol_R,2),size(vol_R,3));
    
    % converts value associated with bin i from lookup table to the error
    % for that bin
    for i=1:94
        val=lookup(i,2);
        heatmap_L(vol_L(:)==val)=dist_L(i,2);
        heatmap_R(vol_R(:)==val)=dist_R(i,2);
    end
    
    nii_L.vol=heatmap_L;
    nii_R.vol=heatmap_R;
    
    save_nifti(nii_L,sprintf('%s/eucDistDir/avgDistDir/%s_%s/avgAllSubj.l.10.dist_mm.heatmap.nii.gz',dir,transformationModel,costFunction));
    save_nifti(nii_R,sprintf('%s/eucDistDir/avgDistDir/%s_%s/avgAllSubj.r.10.dist_mm.heatmap.nii.gz',dir,transformationModel,costFunction));
    
elseif strcmp(costFunction,"GM") || strcmp(costFunction,"GM_DB")
    
    % import average distances
    dist_L=importdata(sprintf('%s/eucDistDir/avgDistDir/%s_%s/avgAllSubj.l.10.dist_mm.txt',dir,transformationModel,costFunction),' ');
    
    % load nifti of checkerboard file
    nii_L=load_nifti('V025/labels/t2/checkerboard/checkerboard.l.10.reorient.06mm.affineAtlasSpace.crop.corr.nii.gz');
    vol_L=nii_L.vol;
    
    heatmap_L=zeros(size(vol_L,1),size(vol_L,2),size(vol_L,3));
    
    % converts value associated with bin i from lookup table to the error
    % for that bin
    for i=1:94
        val=lookup(i,2);
        heatmap_L(vol_L(:)==val)=dist_L(i,2);
    end
    
    nii_L.vol=heatmap_L;
    
    save_nifti(nii_L,sprintf('%s/eucDistDir/avgDistDir/%s_%s/avgAllSubj.l.10.dist_mm.heatmap.nii.gz',dir,transformationModel,costFunction));
    
elseif strcmp(costFunction,"GM_r") || strcmp(costFunction,"GM_DB_r")
    
    % import average distances
    dist_R=importdata(sprintf('%s/eucDistDir/avgDistDir/%s_%s/avgAllSubj.r.10.dist_mm.txt',dir,transformationModel,costFunction),' ');
    
    % load nifti of checkerboard file
    nii_R=load_nifti('V025/labels/t2/checkerboard/checkerboard.r.10.reorient.06mm.affineAtlasSpace.crop.corr.nii.gz');
    vol_R=nii_R.vol;
    
    heatmap_R=zeros(size(vol_R,1),size(vol_R,2),size(vol_R,3));
    
    % converts value associated with bin i from lookup table to the error
    % for that bin
    for i=1:94
        val=lookup(i,2);
        heatmap_R(vol_R(:)==val)=dist_R(i,2);
    end
    
    nii_R.vol=heatmap_R;
    
    save_nifti(nii_R,sprintf('%s/eucDistDir/avgDistDir/%s_%s/avgAllSubj.r.10.dist_mm.heatmap.nii.gz',dir,transformationModel,costFunction));
    
end

end
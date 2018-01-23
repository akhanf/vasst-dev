% calculate volumes of each checkerboard bin

% path is path to subject folders
function calcBinVol(subjList,path)


subjects=importdata(subjList);

for i=1:length(subjects)
    left_checkerboard=sprintf('%s/%s/labels/t2/checkerboard/checkerboard.l.10.reorient.06mm.affineAtlasSpace.crop.corr.nii.gz',path,subjects{i});
    right_checkerboard=sprintf('%s/%s/labels/t2/checkerboard/checkerboard.r.10.reorient.06mm.affineAtlasSpace.crop.corr.nii.gz',path,subjects{i});
    left_nii=load_nifti(left_checkerboard);
    right_nii=load_nifti(right_checkerboard);
    
    leftvol_txt=zeros(100,2);
    rightvol_txt=zeros(100,2);
    
    leftvol_nii=zeros(size(left_nii.vol,1),size(left_nii.vol,2),size(left_nii.vol,3));
    rightvol_nii=zeros(size(right_nii.vol,1),size(right_nii.vol,2),size(right_nii.vol,3));
    
    maxR=max(max(max(right_nii.vol)));
    maxL=max(max(max(left_nii.vol)));
  
    for j=1:maxL
        leftvol_txt(j,1)=j;
        leftvol_txt(j,2)=sum(left_nii.vol(:)==j);
        
        leftvol_nii(left_nii.vol==j)=leftvol_txt(j,2);
    end
    
    for j=1:maxR
        rightvol_txt(j,1)=j;
        rightvol_txt(j,2)=sum(right_nii.vol(:)==j);
        
        rightvol_nii(right_nii.vol==j)=rightvol_txt(j,2);
    end
    
    dlmwrite(sprintf('%s/checkerboard.l.10.binVolumes.txt',subjects{i}),leftvol_txt,' ');
    dlmwrite(sprintf('%s/checkerboard.r.10.binVolumes.txt',subjects{i}),rightvol_txt,' ');
    
    left_nii.vol=leftvol_nii;
    right_nii.vol=rightvol_nii;
    
    save_nifti(left_nii,sprintf('%s/checkerboard.l.10.binVolumes.nii.gz',subjects{i}));
    save_nifti(right_nii,sprintf('%s/checkerboard.r.10.binVolumes.nii.gz',subjects{i}));
    
end

end

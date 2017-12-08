% generates checkerboard files from input AP and PD maps

function genCheckerboard(subjList,path)

% import subject list
subjects=importdata(subjList);

for i=1:length(subjects)
    
    % set file paths/names
    left_AP=sprintf('%s/%s/labels/t2/AP/AP.l.nii.gz',path,subjects{i});
    left_PD=sprintf('%s/%s/labels/t2/PD/PD.l.nii.gz',path,subjects{i});
    
    right_AP=sprintf('%s/%s/labels/t2/AP/AP.r.nii.gz',path,subjects{i});
    right_PD=sprintf('%s/%s/labels/t2/PD/PD.r.nii.gz',path,subjects{i});
    
    % load in niftis of left and right AP and PD maps
    left_AP_nii=load_nifti(left_AP);
    left_PD_nii=load_nifti(left_PD);
    
    right_AP_nii=load_nifti(right_AP);
    right_PD_nii=load_nifti(right_PD);
    
    % extract volume information from imported niftis and store in
    % matrices
    ap_l=left_AP_nii.vol;
    pd_l=left_PD_nii.vol;
    ap_r=right_AP_nii.vol;
    pd_r=right_PD_nii.vol;
    
    % round off AP and PD maps (originally 100 bins each) to 10 and 20 bins
    % and store in new matrices
    ap_l_10=ceil(ap_l./10);
    pd_l_10=ceil(pd_l./10);
    ap_l_20=ceil(ap_l./5);
    pd_l_20=ceil(pd_l./5);
    
    ap_r_10=ceil(ap_r./10);
    pd_r_10=ceil(pd_r./10);
    ap_r_20=ceil(ap_r./5);
    pd_r_20=ceil(pd_r./5);
    
    % initialize checkerboard matrices
    l_checkerboard_10=zeros(size(ap_l_10));
    r_checkerboard_10=zeros(size(ap_r_10));
    l_checkerboard_20=zeros(size(ap_l_20));
    r_checkerboard_20=zeros(size(ap_r_20));
    
    % iterate through AP and PD maps to generate a logical matrix for each
    % pair of labels. generate a corresponding checkerboard map using this
    % logical matrix. checkerboard map set up where 1:20 are each of the PD
    % bins within the first AP bin, 21:40 are each of the PD bins within
    % the second AP bin, etc.
    for j=1:20
        for k=1:20
            l_vox=(ap_l_20==j & pd_l_20==k);
            l_checkerboard_20(l_vox)=(ap_l_20(l_vox)-1)*20 + pd_l_20(l_vox);
            
            r_vox=(ap_r_20==j & pd_r_20==k);
            r_checkerboard_20(r_vox)=(ap_r_20(r_vox)-1)*20 + pd_r_20(r_vox);
        end
    end
    
    for j=1:10
        for k=1:10
            l_vox=(ap_l_10==j & pd_l_10==k);
            l_checkerboard_10(l_vox)=(ap_l_10(l_vox)-1)*10 + pd_l_10(l_vox);
            
            r_vox=(ap_r_10==j & pd_r_10==k);
            r_checkerboard_10(r_vox)=(ap_r_10(r_vox)-1)*10 + pd_r_10(r_vox);
        end
    end
    
    % change imported nifti volume to checkerboard and save that as the
    % checkerboard file
    left_AP_nii.vol=l_checkerboard_20;
    right_AP_nii.vol=r_checkerboard_20;
    
    save_nifti(left_AP_nii,sprintf('%s/%s/labels/t2/checkerboard/checkerboard.l.20.nii.gz',path,subjects{i}));
    save_nifti(right_AP_nii,sprintf('%s/%s/labels/t2/checkerboard/checkerboard.r.20.nii.gz',path,subjects{i}));

    left_AP_nii.vol=l_checkerboard_10;
    right_AP_nii.vol=r_checkerboard_10;
    
    save_nifti(left_AP_nii,sprintf('%s/%s/labels/t2/checkerboard/checkerboard.l.10.nii.gz',path,subjects{i}));
    save_nifti(right_AP_nii,sprintf('%s/%s/labels/t2/checkerboard/checkerboard.r.10.nii.gz',path,subjects{i}));
    
end

end
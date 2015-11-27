function splitBvalueDWI ( in_dwi_prefix, shell_threshold, out_dwi_prefix)

%splits multi-shell into two files (with b0's in each)

dwi_nii=load_nifti(sprintf('%s.nii.gz',in_dwi_prefix));
bvec=importdata(sprintf('%s.bvec',in_dwi_prefix));
bval=importdata(sprintf('%s.bval',in_dwi_prefix));

%sort by bval
[bval_sorted,ind_sorted]=sort(bval);
bvec_sorted=bvec(ind_sorted,:);
dwi_vol_sorted=dwi_nii.vol(:,:,:,ind_sorted);

dwi_b0_nii=dwi_nii;
dwi_shell1_nii=dwi_nii;
dwi_shell2_nii=dwi_nii;

zero_threshold=50;
shell1=bval_sorted<shell_threshold;
shell2=bval_sorted>shell_threshold | bval_sorted <zero_threshold;
b0=bval_sorted<zero_threshold;


dwi_b0_nii.vol=dwi_vol_sorted(:,:,:,b0);
dwi_shell1_nii.vol=dwi_vol_sorted(:,:,:,shell1);
dwi_shell2_nii.vol=dwi_vol_sorted(:,:,:,shell2);
bval_shell1=bval_sorted(shell1);
bval_shell2=bval_sorted(shell2);
bvec_shell1=bvec_sorted(shell1,:);
bvec_shell2=bvec_sorted(shell2,:);

dwi_avgb0_nii=dwi_b0_nii;
dwi_avgb0_nii.vol=squeeze(mean(dwi_b0_nii.vol,4));

dwi_avgb0_nii.dim(5)=size(dwi_avgb0_nii.vol,4);
dwi_b0_nii.dim(5)=size(dwi_b0_nii.vol,4);
dwi_shell1_nii.dim(5)=size(dwi_shell1_nii.vol,4);
dwi_shell2_nii.dim(5)=size(dwi_shell2_nii.vol,4);


save_nifti(dwi_avgb0_nii,sprintf('%s_avgb0.nii.gz',out_dwi_prefix));
save_nifti(dwi_b0_nii,sprintf('%s_b0.nii.gz',out_dwi_prefix));


dlmwrite(sprintf('%s_shell1.bvec',out_dwi_prefix),bvec_shell1,' ');
dlmwrite(sprintf('%s_shell1.bval',out_dwi_prefix),bval_shell1,' ');
save_nifti(dwi_shell1_nii,sprintf('%s_shell1.nii.gz',out_dwi_prefix));


dlmwrite(sprintf('%s_shell2.bvec',out_dwi_prefix),bvec_shell2,' ');
dlmwrite(sprintf('%s_shell2.bval',out_dwi_prefix),bval_shell2,' ');
save_nifti(dwi_shell2_nii,sprintf('%s_shell2.nii.gz',out_dwi_prefix));

end

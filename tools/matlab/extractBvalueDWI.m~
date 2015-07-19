function extractBvalueDWI ( in_dwi_prefix, lower_bval_th, upper_bval_th, out_dwi_prefix)

dwi_nii=load_nifti(sprintf('%s.nii.gz',in_dwi_prefix));
bvec=importdata(sprintf('%s.bvec',in_dwi_prefix));
bval=importdata(sprintf('%s.bval',in_dwi_prefix));

ind=bval>lower_bval_th & bval <upper_bval_th;


dwi_extract=dwi_nii.vol(:,:,:,ind);
bvec_extract=bvec(ind,:);
bval_extract=bval(ind);

dwi_nii.vol=dwi_extract;
dlmwrite(sprintf('%s.bvec',out_dwi_prefix),bvec_extract);
dlmwrite(sprintf('%s.bval',out_dwi_prefix),bval_extract);
save_nifti(dwi_nii,sprintf('%s.nii.gz',out_dwi_prefix));

end

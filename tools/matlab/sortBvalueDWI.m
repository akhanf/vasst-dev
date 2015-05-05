function sortBvalueDWI ( in_dwi_prefix, out_dwi_prefix)

dwi_nii=load_nifti(sprintf('%s.nii.gz',in_dwi_prefix));
bvec=importdata(sprintf('%s.bvec',in_dwi_prefix));
bval=importdata(sprintf('%s.bval',in_dwi_prefix));

%sort by bval
[bval_sorted,ind_sorted]=sort(bval);
bvec_sorted=bvec(ind_sorted,:);
dwi_vol_sorted=dwi_nii.vol(:,:,:,ind_sorted);

dwi_nii.vol=dwi_vol_sorted;
dlmwrite(sprintf('%s.bvec',out_dwi_prefix),bvec_sorted);
dlmwrite(sprintf('%s.bval',out_dwi_prefix),bval_sorted);
save_nifti(dwi_nii,sprintf('%s.nii.gz',out_dwi_prefix));

end

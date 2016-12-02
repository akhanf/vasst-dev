function prepForKurtosisDWI ( in_dwi_prefix, out_dwi_prefix)

dwi_nii=load_nifti(sprintf('%s.nii.gz',in_dwi_prefix));
bvec=importdata(sprintf('%s.bvec',in_dwi_prefix));
bval=importdata(sprintf('%s.bval',in_dwi_prefix));

%transpose if needed
if(size(bvec,2)==3)
bvec=bvec';
end

%sort by bval
[bval_sorted,ind_sorted]=sort(bval);


bvec_sorted=bvec(:,ind_sorted);
dwi_vol_sorted=dwi_nii.vol(:,:,:,ind_sorted);


%average all b0's
avgb0=mean(dwi_vol_sorted(:,:,:,bval_sorted<100),4);


dwi_new=zeros(size(dwi_vol_sorted,1),size(dwi_vol_sorted,2),size(dwi_vol_sorted,3),sum(bval_sorted>100)+1);
dwi_new(:,:,:,1)=avgb0;
dwi_new(:,:,:,2:end)=dwi_vol_sorted(:,:,:,bval_sorted>100);

bval_new=[0; bval_sorted(bval_sorted>100,:)];
bvec_new=[[0; 0; 0;], bvec_sorted(:,bval_sorted>100)];

dwi_nii.vol=dwi_new;


dlmwrite(sprintf('%s.bvec',out_dwi_prefix),bvec_new);
dlmwrite(sprintf('%s.bval',out_dwi_prefix),bval_new);
save_nifti(dwi_nii,sprintf('%s.nii.gz',out_dwi_prefix));

end

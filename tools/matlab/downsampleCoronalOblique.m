function downsampleCoronalOblique ( in_nii_path, out_nii_path, downsample_factor )

nii=load_nifti(in_nii_path);

dims=size(nii.vol);

%downsample factor
f=downsample_factor;

ds_vol=zeros(dims(1),floor(dims(2)/f),dims(3));

for iy=1:size(ds_vol,2)
    inds=((iy-1).*f+1):(iy*f);
    ds_vol(:,iy,:)=mean(nii.vol(:,inds,:),2);
end

out_nii=nii;
out_nii.vol=ds_vol;
out_nii.pixdim(3)=out_nii.pixdim(3).*f;
save_nifti(out_nii,out_nii_path);
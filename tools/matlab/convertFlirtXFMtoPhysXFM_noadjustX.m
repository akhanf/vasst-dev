function phys_xfm = convertFlirtXFMtoPhysXFM_noadjustX(in_flirt_xfm, in_src_nii, in_dest_nii, out_phys_xfm);
% converts flirt transform into physical transform, which can be applied to
% points in physical space

%flirt transform uses a pseudo-physical space, based only on the voxel
%coordinates and voxel dimensions of the reference image


flirt=dlmread(in_flirt_xfm);

src_hdr=load_nifti(in_src_nii,1);
dest_hdr=load_nifti(in_dest_nii,1);


dest_sform=dest_hdr.sform;
dest_phys_scale=diag([dest_hdr.pixdim(2:4);1]);

src_sform=src_hdr.sform;
src_phys_scale=diag([src_hdr.pixdim(2:4);1]);


%to apply flirt xfm, first xfm to voxel space, then vox*voxdim is the space
%that flirt applies xfm in
phys_xfm=dest_sform*inv(dest_phys_scale)*flirt*src_phys_scale*inv(src_sform);

dlmwrite(out_phys_xfm,phys_xfm,' ');

end

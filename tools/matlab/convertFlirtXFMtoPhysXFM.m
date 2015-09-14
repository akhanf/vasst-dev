function phys_xfm = convertFlirtXFMtoPhysXFM(in_flirt_xfm, in_src_nii, in_dest_nii, out_phys_xfm);
% converts flirt transform into physical transform, which can be applied to
% points in physical space

%flirt transform uses a pseudo-physical space, based only on the voxel
%coordinates and voxel dimensions of the reference image


flirt=dlmread(in_flirt_xfm);

src_hdr=load_nifti(in_src_nii,1);
dest_hdr=load_nifti(in_dest_nii,1);

if (dest_hdr.sform_code~= 1)
    disp(sprintf('Problem to sformcode in %s!',in_dest_nii));
    exit;
end

if (src_hdr.sform_code ~= 1)
    disp(sprintf('Problem to sformcode in %s!',in_src_nii));
    exit;
end


dest_sform=dest_hdr.sform;
dest_phys_scale=diag([dest_hdr.pixdim(2:4);1]);

src_sform=src_hdr.sform;
src_phys_scale=diag([src_hdr.pixdim(2:4);1]);


adjustXfm=eye(4,4);

src_xsign=sign(max(src_sform(:,1)));
dest_xsign=sign(max(dest_sform(:,1)));
if(src_xsign~=dest_xsign)
    adjustXfm(1,1)=-1;
end



%to apply flirt xfm, first xfm to voxel space, then vox*voxdim is the space
%that flirt applies xfm in
%phys_xfm=dest_sform*inv(dest_phys_scale)*flirt*src_phys_scale*inv(src_sform)*adjustXfm;
phys_xfm=dest_sform*inv(dest_phys_scale)*flirt*src_phys_scale*inv(src_sform)*adjustXfm;



dlmwrite(out_phys_xfm,inv(phys_xfm),' ');

end

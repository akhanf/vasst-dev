% convert FLOAT32 to 4D nifti
% purpose: for niftyreg deformation/displacement fields which are collapsed
%   and only shown dim4 = 1
% path to script: /cluster/software/vasst-dev/tools/matlab/
function convertNiftiFLOAT32to4D ( in_nii_gz, out_nii_gz)

    % define input and output files
    out_nii=out_nii_gz(1:end-3);
    in_nii=in_nii_gz(1:end-3);
    gunzip(in_nii_gz);
    nii=load_nifti(in_nii);
    delete(in_nii);

    %nii=load_nifti('affine_displacement_field.nii')
    size(nii.vol);
    nii.dim(1)=4;
    nii.dim(4)=3;
    nii.vol=squeeze(nii.vol);
    size(nii.vol);
    save_nifti(nii,out_nii);
    gzip(out_nii);
    delete(out_nii);
%    save_nifti(nii,'affine_displacement_field_4d.nii')

end
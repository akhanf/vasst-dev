% convert 4D uchar to RGB nifti
function convertNifti4DtoRGB24 ( in_nii_gz, out_nii_gz)


%in_nii_gz='/eq-nas/alik/EpilepsyDatabase/standard/projects/atlases/ctrl_avg/dti/distortCorrect/caminoDTI/dt_rgb.4d.nii.gz';
%out_nii_gz='/eq-nas/alik/EpilepsyDatabase/standard/projects/atlases/ctrl_avg/dti/distortCorrect/caminoDTI/dt_rgb.4d.backTo24bit.nii.gz';


in_nii=in_nii_gz(1:end-3);
out_nii=out_nii_gz(1:end-3);
gunzip(in_nii_gz);
nii=load_nii(in_nii);
delete(in_nii);

%   128 Red-Green-Blue            (Use uint8, bitpix=24) % DT_RGB24, NIFTI_TYPE_RGB24 
nii.hdr.dime.datatype=128
nii.hdr.dime.bitpix=24


if(nii.hdr.dime.dim(4)==1)
    %2d image
    nii.img=reshape(nii.img,size(nii.img,1),size(nii.img,2),1,3);
    nii.hdr.dime.dim(1)=2 %2d
    nii.hdr.dime.dim(5)=1
    
else
    nii.hdr.dime.dim(1)=3 %3d
nii.hdr.dime.dim(5)=1
end



save_nii(nii,out_nii);
gzip(out_nii);
delete(out_nii);

end

% convert RGB to 4D uchar nifti
function convertNiftiRGB24to4D ( in_nii_gz, out_nii_gz)


%in_nii_gz='/eq-nas/alik/EpilepsyDatabase/standard/projects/atlases/ctrl_avg/dti/distortCorrect/caminoDTI/dt_rgb.nii.gz';
%out_nii_gz='/eq-nas/alik/EpilepsyDatabase/standard/projects/atlases/ctrl_avg/dti/distortCorrect/caminoDTI/dt_rgb.4d.nii.gz';

out_nii=out_nii_gz(1:end-3);


in_nii=in_nii_gz(1:end-3);
gunzip(in_nii_gz);
nii=load_nii(in_nii);
delete(in_nii);


%     2 Unsigned char         (uchar or uint8, bitpix=8) % DT_UINT8, NIFTI_TYPE_UINT8 
nii.hdr.dime.datatype=2  %uchar
nii.hdr.dime.bitpix=8  %uchar
nii.hdr.dime.dim(1)=4
nii.hdr.dime.dim(5)=3

save_nii(nii,out_nii);
gzip(out_nii);
delete(out_nii);

% for c=1:3
% nii_4d{c}=nii;
% nii_4d{c}.img=nii_4d{c}.img(:,:,:,c);
% save_nii(nii_4d{c},sprintf('%s/temp_comp%d.nii',wd,c));
% end
% 
% system(sprintf('fslmerge -t %s %s/temp_comp1.nii %s/temp_comp2.nii %s/temp_comp3.nii',out_nii_gz,wd,wd,wd));
% 
% for c=1:3
% delete(sprintf('%s/temp_comp%d.nii',wd,c));
% end

end

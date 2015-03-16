function convertNiftiRGB(in_nii_r,in_nii_g,in_nii_b,out_nii_rgb);
% Note: cannot use .gz niftis

merged=cell(3,1);

merged{1}=load_nii(in_nii_r);
merged{2}=load_nii(in_nii_g);
merged{3}=load_nii(in_nii_b);

out_nii=merged{1};
img=out_nii.img;

out_nii.hdr.dime.datatype=128;
out_nii.hdr.dime.bitpix=128;
out_nii.img=uint8(zeros(size(img,1),size(img,2),size(img,3),3));

for c=1:3
out_nii.img(:,:,:,c)=uint8(merged{c}.img);
end

save_nii(out_nii,out_nii_rgb);

end




























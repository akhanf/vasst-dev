function fixSurfVecCoordWithNifti(in_vec_txt,in_nii,out_vec_txt);

%readjusts BYU coordinates to match that of nifti file

nii=load_nifti(in_nii);

vertices=importdata(in_vec_txt);


%volsize=size(nii.vol)

%for i=1:3
%vertices(:,i)=volsize(i)-vertices(:,i)-1;
%end

cppT=-1.*eye(3,3);

%multiply vertices by sform to get phys coords
vert_phys=nii.sform(1:3,1:3)*cppT*vertices';




dlmwrite(out_vec_txt,vert_phys',' ');

end


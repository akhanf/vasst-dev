function fixByuCoordWithNifti(in_byu,in_nii,out_byu);

%readjusts BYU coordinates to match that of nifti file

nii=load_nifti(in_nii);


[faces,vertices]=readTriByu(in_byu);

%volsize=size(nii.vol)

%for i=1:3
%vertices(:,i)=volsize(i)-vertices(:,i)-1;
%end

vert_homog=[vertices, ones(size(vertices,1),1)]';

%multiply vertices by sform to get phys coords
vert_homog_phys=nii.sform*vert_homog;

vert_phys=vert_homog_phys(1:3,:)';

writeTriByu(out_byu,faces,vert_phys);

end


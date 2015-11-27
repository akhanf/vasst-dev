function getReorientedSform ( in_nii, in_orient, out_sform_txt )
%takes input nifti, and RAS string in terms of input image
%writes out in single line of text file, row by row

hdr=load_nifti(in_nii,1);

if hdr.sform_code==1
    sform=hdr.sform;
else
    sform=hdr.qform;
end
outsform=eye(4,4);

std_orient='RAS';
std_orient_flip='LPI';

ident=eye(4,4);
xfm=eye(4,4);

%flip_mat=eye(4,4);

for axis=1:3

 flip=1;
 
 ind_std=strfind(std_orient,in_orient(axis));
 if isempty(ind_std)
     flip=-1;
     ind_std=strfind(std_orient_flip,in_orient(axis));
 end
 
 outsform(axis,:)=sform(ind_std,:);
 
 
 
 %apply flip
 outsform(axis,1:3)=flip.*outsform(axis,1:3); 
 
 %there is a bug (which prevents DTI from being in alignment after applying
 %sform correction).. at this point, easier to perform addn'l DTI to
 %anatomical registraiton step, as correcting this would provide new Ex
 %anat and all the Ex-Hist and Pre-Ex registrations would need to be
 %redone..  FYI, correct xfm could be found by outsform=xfm*insform
 
 xfm(axis,:)=ident(ind_std,:);
 xfm(axis,1:3)=flip.*xfm(axis,1:3);
 
 
end

%apply flip
%outsform=outsform*flip_mat;

%write out sform row by row
dlmwrite(out_sform_txt,reshape(outsform',1,prod(size(outsform))),'delimiter',' ','precision',6);

end

function genBYUtoNiftiTransformFromCroppedAnalyze(in_cropped_analyze, in_crop_param_txt, out_xfm);

%this function finds the transform to go from BYU to NIFTI when the nifti
%is converted to analyze, cropped, and BYU surface generated (e.g. for the
%template surface in ComputeSurfaceDisplacements)


%in_cropped_analyze='lhipp_ana_crop.hdr';
%in_crop_param_txt='lhipp_crop_param.txt';
%out_xfm='byu_to_nifti.xfm';

%get origin from fslval (same as fslinfo)
tmpfile='tmpfile';
for i=1:3
system(sprintf('fslval %s origin%d > %s',in_cropped_analyze,i,tmpfile));
origin(i)=importdata(tmpfile);
end

%get dimensions from fslval
for i=1:3
system(sprintf('fslval %s dim%d > %s',in_cropped_analyze,i,tmpfile));
dim(i)=importdata(tmpfile);
end

delete(tmpfile);

%get crop params
crop_params=importdata(in_crop_param_txt);

%create matrices

nii_to_ana=[1 0 0 (1-origin(1)); 0 -1 0 (1-origin(2)); 0 0 1 (origin(3)-1); 0 0 0 1];

ana_to_crop=[1 0 0 crop_params(1); 0 1 0 crop_params(3); 0 0 1 -crop_params(5); 0 0 0 1];

crop_to_cpp=[-1 0 0 0; 0 -1 0 0; 0 0 1 0; 0 0 0 1];

cpp_to_byu=[-1 0 0 (dim(1)-1); 0 -1 0 (dim(2)-1); 0 0 -1 (dim(3)-1); 0 0 0 1];

composed=cpp_to_byu*crop_to_cpp*ana_to_crop*nii_to_ana;

dlmwrite(out_xfm,composed);

end
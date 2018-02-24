function genBYUtoNiftiTransformFromCroppedAnalyze(in_nifti, in_crop_param_txt, out_xfm);

%this function finds the transform to go from BYU to NIFTI when the nifti
%is converted to analyze, cropped, and BYU surface generated (e.g. for the
%template surface in ComputeSurfaceDisplacements)


%in_nifti='lhipp.nii.gz';
%in_crop_param_txt='lhipp_crop_param.txt';
%out_xfm='byu_to_nifti.xfm';

nii=load_nifti(in_nifti);


%get crop params
crop_params=importdata(in_crop_param_txt);

vox2ras=nii.sform;
flipx=eye(4,4); flipx(1,1)=-1;
xfm_crop=[1 0 0 crop_params(1); 0 1 0 crop_params(3); 0 0 1 crop_params(5); 0 0 0 1];

%this goes from nifti vox to byu
%inv(vox2ras)*inv(xfm_crop)*flipx*vox2ras*[104,138,89,1]'

%this goes from nifti phys to byu
%inv(vox2ras)*inv(xfm_crop)*flipx*[8,6,11,1]'

%so, this goes from byu to nifti phys
%flipx*vox2ras*xfm_crop*[50,54,50,1]'

%want xfm that takes images from cropped to phys, same as points from phys
%to cropped -> that's why we need the inverse..

composed=flipx*vox2ras*xfm_crop;


dlmwrite(out_xfm,inv(composed));

end
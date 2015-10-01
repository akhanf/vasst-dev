function createFStoSlicerTfm(in_orig_mgz,out_tfm);

%in_orig_mgz='/cluster/data/freesurfer/EPL14_LHS_0068/freesurfer/mri/orig.mgz';
%out_tfm='/tmp/test_final.tfm';


system(sprintf('mri_info --vox2ras-tkr %s > /tmp/Torig.txt',in_orig_mgz));
Torig=importdata('/tmp/Torig.txt');

system(sprintf('mri_info --vox2ras %s > /tmp/Norig.txt',in_orig_mgz));
Norig=importdata('/tmp/Norig.txt');

delete('/tmp/Torig.txt');
delete('/tmp/Norig.txt');

xfm=Torig*inv(Norig);

convertRAStoSlicerTfm(xfm,out_tfm)



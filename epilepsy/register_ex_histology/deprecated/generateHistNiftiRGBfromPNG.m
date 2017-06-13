% generates nifti RGB histology images -- these can be transformed using
% registration xfms to bring into ex mri space



%input hist png  (could alternatively load tif files here too..)

data_dir='~/epilepsy/shared_data/data';
subj='EPI_P014';
struct='Neo';


slicethick=4.4;

%get number of HE slices
nslices=13; %get this later..


res=10; %in microns
res_mm=res./1000;

stains={'HE','Neu-N'};

out_dir=sprintf('%s/%s/Hist/Processed/%dum_nii_rgb',data_dir,subj,res);
mkdir(out_dir);


for slice=1:nslices
    
for st=1:length(stains)
    
    stain=stains{st};
    
in_hist=sprintf('%s/%s/Hist/Processed/%dum_png/%s_%02d.%s.png',data_dir,subj,res,struct,slice,stain);

if (exist(in_hist,'file'))
    

png=imread(in_hist);

imdim=size(png);
png3d=zeros(imdim(1),imdim(2),1,3);
png3d(:,:,1,:)=png;
png3d=permute(png3d,[2 1 3 4]);
png3d=repmat(png3d,[1 1 3 1]);

outthick=1;
%now have png.. create nifti file with proper sform
nii=make_nii(flipdim(flipdim(png3d,1),2),[res_mm,res_mm,outthick],[0,0,0],128);
%nii.hdr.hist.srow_x(1)=res_mm;
%nii.hdr.hist.srow_y(2)=res_mm;
%nii.hdr.hist.srow_z(3)=slicethick;
nii.hdr.hist.originator=ones(1,5);
nii.hdr.hist.originator(3)=2-slice*slicethick./outthick;

out_nii=sprintf('%s/%s_%02d.%s.nii',out_dir,struct,slice,stain);

save_nii(nii,out_nii);

%then can load up computed transform and apply in slicer to get the warped
%histology image

%nii_chk=load_nii(out_nii);

end

end

end
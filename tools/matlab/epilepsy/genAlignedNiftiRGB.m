% transform rgb 100 um pngs to 3D nifti's in aligned space
function genAlignedNiftiRGB(data_dir,subj, struct, session,png_res,histology_study)



hist_dir=sprintf('/eq-nas/%s/EpilepsyHistology/%s',getenv('USER'),histology_study);


%line below for testing
%subj='EPI_P040'; struct='Neo'; session='9.4T'; png_res=100;

reg_dir=sprintf('%s/%s/%s/%s',data_dir,subj,session,struct);

%first, load up hist stack image to determine # of slices and slice spacing
hist_stack_nii=sprintf('%s/images/hist_stack.nii.gz',reg_dir);
hdr=load_nifti(hist_stack_nii,1);
hist_stack_sform=hdr.sform;


%background colour in hist
histfillval=244;

nslices=hdr.dim(4);
slicespacing=hdr.pixdim(4);

png_dir=sprintf('%s/%s/%dum_png',hist_dir,subj,png_res);

coreg_dir=sprintf('%s/%s/%dum_png.coregHE',hist_dir,subj,png_res);
stains={'HE','NEUN','GFAP','LFB','LUXFB'};

out_dir=sprintf('%s/aligned_rgb_%dum_%s',reg_dir,png_res,histology_study);
slice_dir=sprintf('%s/slices',out_dir);

mkdir(out_dir);
mkdir(slice_dir);
init_fill=0;
rgbout=cell(length(stains),1);

%make a rgb vol for a given stain when at least one exists -- this variable keeps track of that
makergbvol=zeros(length(rgbout),1);

totaloffset=0;


for slice=1:nslices

    
   in_png=sprintf('%s/%s_%s_%02d_%s.png',png_dir,subj,struct,slice+totaloffset,stains{1});
    next_png=sprintf('%s/%s_%s_%02d_%s.png',png_dir,subj,struct,slice+totaloffset+1,stains{1});
  

    makergbvol(1)=1;
    
    in_pngs=cell(length(stains),1);
    
    if (exist(in_png))
        in_pngs{1}=in_png;
    end
    
    for st=2:length(stains)
        coreg_png=sprintf('%s/%s_%s_%02d_%s.png',coreg_dir,subj,struct,slice+totaloffset,stains{st});
        if(exist(coreg_png))
         %   in_pngs=[in_pngs; coreg_png];
            in_pngs{st}=coreg_png;
            makergbvol(st)=1;
        end
    end
    
    for st=1:length(stains)
        
            
    if( isempty(in_pngs{st}))
        continue;
    end
        
    hist_png=permute(flipdim(flipdim(imread(in_pngs{st}),1),2),[2,1,3]);
    
    png_res_mm=png_res/1000;
    %
    
    histaligned_xfm=sprintf('%s/final_xfm/hist-aligned_slice_%02d.xfm',reg_dir,slice+totaloffset);
 
     %this hist aligned xfm is essentially 2D -- z dim is just translation
 xfm_ha=importdata(histaligned_xfm);
 
%load up 2d hist (nii for now)..
%in_hist_nii='~/epilepsy/local_data/ex-hist-registration_nii/EPI_P040/Processed/Ex-Hist_Reg/9.4T/Neo/images/hist_slice_5.nii.gz';

%in_hist=load_nifti(in_hist_nii);
%size(in_hist.vol)
%vox2ras=in_hist.vox2ras
vox2ras_png=eye(4,4);
vox2ras_png(1,1)=png_res_mm;
vox2ras_png(2,2)=png_res_mm;
vox2ras_png(3,3)=png_res_mm;


%load up ref slice:
refslice=nslices-slice;
histslice=sprintf('%s/3drigid_iter5/slices/hist_%04d.nii.gz',reg_dir,refslice);
histref_hdr=load_nifti(histslice,1);
vox2ras_ref=histref_hdr.vox2ras;


%can use vox2ras to go from vox indices (0 to size-1) to phys dim
I=eye(4,4);
xfm3dto2d=I;
xfm3dto2d(3,:)=I(2,:);
xfm3dto2d(2,:)=I(3,:);


in_coord_begin=[0;0;0;1];
in_coord_end=[size(hist_png,1)-1;size(hist_png,2)-1;0;1];

%get input coords in phys space (begin to end)
in_coords_phys=vox2ras_png*[in_coord_begin, in_coord_end];

%get output coords in phys space (begin to end)
out_coord_begin=[0;0;0;1];
out_coord_end=[histref_hdr.dim(2:4)-1;1];
out_coords_phys=xfm3dto2d*vox2ras_ref*[out_coord_begin, out_coord_end];
 
udata=in_coords_phys(1,:);
vdata=in_coords_phys(2,:);

xdata=out_coords_phys(1,:);
ydata=out_coords_phys(2,:);


%make output pix dim same as png
%out_size=size(histref_hdr.vol);

% for imtransform -- X and Y are reversed!


%create 2d xfm
transform=xfm3dto2d*inv(xfm_ha);
transform(3,:)=[];
transform(:,3)=[];

T=maketform('affine',transform');

A=permute(hist_png,[2,1,3]);
%A=hist_png;

[B,out_xdata,out_ydata]=imtransform(A,T,'UData',udata,'VData',vdata,'XData',xdata,'YData',ydata,'XYScale',[png_res_mm,png_res_mm],'FillValues',histfillval);

B=permute(B,[2,1,3]);

%if(slice==1 )
    if(init_fill ==0)
    for stb=1:length(stains)
    rgbout{stb}=histfillval.*ones(size(B,1),size(B,2),nslices,3,'uint8');
    end
    init_fill=1;
    end
%end

rgbout{st}(:,:,nslices-slice+1,:)=B;

rgbslice=zeros(size(B,1),size(B,2),1,3,'uint8');
rgbslice(:,:,1,:)=B;


temp=make_nii(rgbslice,[png_res_mm,png_res_mm,slicespacing],[0,0,0], 128);
temp.hdr.dime.datatype=128;
temp.hdr.dime.bitpix=24;
temp.hdr.hist.srow_x=histref_hdr.srow_x';
temp.hdr.hist.srow_y=histref_hdr.srow_y';
temp.hdr.hist.srow_z=histref_hdr.srow_z';
temp.hdr.hist.qform_code=0;
temp.hdr.hist.sform_code=1;



save_nii(temp,sprintf('%s/%s_rigid_rgb_%dum_slice_%02d.nii',slice_dir,stains{st},png_res,slice));

    end


end




%get ref for sform vol:
histvol=sprintf('%s/3drigid_iter5/hist_stack_reg.nii.gz',reg_dir);
histvolref_hdr=load_nifti(histvol,1);


for st=1:length(stains)
    
    if(makergbvol(st)==1)
        
temp=make_nii(rgbout{st},[png_res_mm,png_res_mm,slicespacing],[0,0,0], 128);
temp.hdr.dime.datatype=128;
temp.hdr.dime.bitpix=24;
temp.hdr.hist.srow_x=histvolref_hdr.srow_x';
temp.hdr.hist.srow_y=histvolref_hdr.srow_y';
temp.hdr.hist.srow_z=histvolref_hdr.srow_z';

temp.hdr.hist.qform_code=0;
temp.hdr.hist.sform_code=1;

save_nii(temp,sprintf('%s/%s_rigid_rgb_%dum.nii',out_dir,stains{st},png_res));
gzip(sprintf('%s/%s_rigid_rgb_%dum.nii',out_dir,stains{st},png_res));
delete(sprintf('%s/%s_rigid_rgb_%dum.nii',out_dir,stains{st},png_res));

    end
    
end


end



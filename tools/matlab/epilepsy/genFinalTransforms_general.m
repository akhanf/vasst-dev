function genFinalTransforms_general ( data_dir, subj, struct,resolution )




% applies to images from Histology, 100um_nii


init_phys_xfm=eye(4,4);
init_phys_xfm(1,1)=10;
init_phys_xfm(2,2)=10;

reg_dir=sprintf('%s/%s/mri_hist_reg_%s_%dum',data_dir,subj,struct,resolution);

%first, load up hist stack image to determine # of slices and slice spacing
hist_stack_nii=sprintf('%s/images/hist_stack.nii.gz',reg_dir);
hdr=load_nifti(hist_stack_nii,1);
hist_stack_sform=hdr.sform;

nslices=hdr.dim(4);
slicespacing=hdr.pixdim(4);


%find offset first:

for slice=1:nslices
    hist_slice=sprintf('%s/images/hist_slice_%02d.nii.gz',reg_dir,slice);
    hist_slice_alt=sprintf('%s/images/hist_slice_%03d.nii.gz',reg_dir,slice);

    if exist(hist_slice) || exist(hist_slice_alt)
        
        totaloffset=slice-1;
        break;
    end
end

for slice=1+totaloffset:nslices+totaloffset
    
    %0. get hdr for hist slice to determine initial sform
    hist_slice=sprintf('%s/images/hist_slice_%02d.nii.gz',reg_dir,slice);

    if (~exist(hist_slice))
        hist_slice=sprintf('%s/images/hist_slice_%03d.nii.gz',reg_dir,slice);
    end
    
    hist_slice_hdr=load_nifti(hist_slice,1);
    hist_slice_sform=hist_slice_hdr.vox2ras;
    
     
    % 1. apply hist stack xfm
    stack_flirt=sprintf('%s/stack_xfm/hist_stack_%02d.xfm',reg_dir,slice);
    stack_phys=sprintf('%s/stack_xfm/hist_stack_%02d_phys.xfm',reg_dir,slice);
    
    if (~exist(stack_flirt))
        stack_flirt=sprintf('%s/stack_xfm/hist_stack_%03d.xfm',reg_dir,slice);
        stack_phys=sprintf('%s/stack_xfm/hist_stack_%03d_phys.xfm',reg_dir,slice);
    end
    
    stack_vol=sprintf('%s/images/ex_mri_refslice.nii.gz',reg_dir);
   
    %convert flirt to phys using flirtxfm, src sform, dest sform
    convertFlirtXFMtoPhysXFM_noadjustX(stack_flirt,hist_slice,stack_vol,stack_phys);
    %load up xfm just created
    stack_phys_xfm=importdata(stack_phys);
    
    
    % 2. account for z-stacking slice
    %    y=y+(nslice-slice)*slice_spacing
    
    reg_index=nslices+totaloffset-slice;
    
    zstack_xfm=eye(4,4);
    zstack_xfm(2,4)=(reg_index)*slicespacing;
    
   
    % 3. apply 2d hist/mri xfm
    reg2d_flirt=sprintf('%s/3drigid_iter5/slices/flirt_hist-mri_%04d.xfm',reg_dir,reg_index);
    
        %convert flirt to phys using flirtxfm, src sform, dest sform
        reg2d_phys=sprintf('%s/3drigid_iter5/slices/flirt_hist-mri_%04d.phys.xfm',reg_dir,reg_index);
    hist2d_slice=sprintf('%s/3drigid_iter5/slices/hist_%04d.nii.gz',reg_dir,reg_index);
    mri2d_slice=sprintf('%s/3drigid_iter5/slices/mri_%04d.nii.gz',reg_dir,reg_index);
    convertFlirtXFMtoPhysXFM_noadjustX(reg2d_flirt,hist2d_slice,mri2d_slice,reg2d_phys);
    reg2d_phys_xfm=importdata(reg2d_phys);
    
      
    % 4. apply inverse of 3D flirt xfm
    reg3d_flirt=sprintf('%s/3drigid_iter5/flirt_mri-histstack.xfm',reg_dir);
    %first convert to phys, then invert..
    reg3d_phys=sprintf('%s/3drigid_iter5/flirt_mri-histstack.phys.xfm',reg_dir);
    mri_vol_glob=dir(sprintf('%s/images/ex_mri_th*_iso_crop.nii.gz',reg_dir));
    mri_vol=[mri_vol_glob.folder, filesep mri_vol_glob.name];
  %  if ~exist(mri_vol)
  %          mri_vol=sprintf('%s/images/ex_mri_th0_iso_crop.nii.gz',reg_dir);
  %  end
    convertFlirtXFMtoPhysXFM_noadjustX(reg3d_flirt,mri_vol,hist_stack_nii,reg3d_phys);
    reg3d_phys_xfm=importdata(reg3d_phys);
    
    final_xfm=inv(reg3d_phys_xfm)*reg2d_phys_xfm*zstack_xfm*stack_phys_xfm*hist_slice_sform*init_phys_xfm;
   
    %write final xfms
    final_dir=sprintf('%s/final_xfm',reg_dir);
    mkdir(final_dir);
    
    final_phys=sprintf('%s/ex-hist_slice_%03d.xfm',final_dir,slice);
    final_phys_slicer=sprintf('%s/ex-hist_slice_%03d.tfm',final_dir,slice);

    dlmwrite(final_phys,final_xfm,' ');
    convertRAStoSlicerTfm(final_xfm,final_phys_slicer);
    
    %write inverses too
    final_phys_inv=sprintf('%s/hist-ex_slice_%03d.xfm',final_dir,slice);
    final_phys_slicer_inv=sprintf('%s/hist-ex_slice_%03d.tfm',final_dir,slice);

    dlmwrite(final_phys_inv,inv(final_xfm),' ');
    convertRAStoSlicerTfm(inv(final_xfm),final_phys_slicer_inv);
    
    
    aligned_xfm=reg2d_phys_xfm*zstack_xfm*stack_phys_xfm*hist_slice_sform*init_phys_xfm;
    aligned_phys=sprintf('%s/aligned-hist_slice_%03d.xfm',final_dir,slice);
    aligned_phys_slicer=sprintf('%s/aligned-hist_slice_%03d.tfm',final_dir,slice);

    aligned_phys_inv=sprintf('%s/hist-aligned_slice_%03d.xfm',final_dir,slice);
    aligned_phys_slicer_inv=sprintf('%s/hist-aligned_slice_%03d.tfm',final_dir,slice);
    
    dlmwrite(aligned_phys,aligned_xfm,' ');
    convertRAStoSlicerTfm(aligned_xfm,aligned_phys_slicer);

    dlmwrite(aligned_phys_inv,inv(aligned_xfm),' ');
    convertRAStoSlicerTfm(inv(aligned_xfm),aligned_phys_slicer_inv);
    
    
 

    
end


     %xfms from aligned to ex 
     
     %??
     aligned_ex_xfm=reg3d_phys_xfm;
     
     
    aligned_ex_phys=sprintf('%s/aligned-ex.xfm',final_dir);
    aligned_ex_phys_slicer=sprintf('%s/aligned-ex.tfm',final_dir);
    
    aligned_ex_phys_inv=sprintf('%s/ex-aligned.xfm',final_dir);
    aligned_ex_phys_slicer_inv=sprintf('%s/ex-aligned.tfm',final_dir);

     dlmwrite(aligned_ex_phys,aligned_ex_xfm,' ');
     dlmwrite(aligned_ex_phys_inv,inv(aligned_ex_xfm),' ');
     convertRAStoSlicerTfm(aligned_ex_xfm,aligned_ex_phys_slicer);
     convertRAStoSlicerTfm(inv(aligned_ex_xfm),aligned_ex_phys_slicer_inv);

    

end

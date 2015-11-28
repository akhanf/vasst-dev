function reorientExGradTable (   in_nii,ref_nii,xfm_1_txt,xfm_2_txt,in_grad_table,out_grad_table )


in_hdr=load_nifti(in_nii,1);
in_sform=in_hdr.sform;

ref_hdr=load_nifti(ref_nii,1);
ref_sform=ref_hdr.sform;


%in_grad_table='/home/ROBARTS/alik/EpilepsyDatabase/GradTable9.4T/Dir12Gradient.bvec';

%out_grad_table='test_RotGradTable.bvec';
xfm_1=importdata(xfm_1_txt);
xfm_2=importdata(xfm_2_txt);

final=inv(ref_sform)*inv(xfm_2)*inv(xfm_1)*in_sform;

final=final(1:3,1:3)

in_grad=importdata(in_grad_table);

out_grad=final*in_grad;

dlmwrite(out_grad_table,out_grad,' ');

end
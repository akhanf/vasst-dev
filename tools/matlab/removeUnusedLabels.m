function removeUnusedLabels(in_file,out_file,labellist_txt)

in_nii=load_nifti(in_file);
in=in_nii.vol;

[lbl,shortname]=textread(labellist_txt,'%d %s');


out_nii=in_nii;
out_nii.vol=zeros(size(in));

%copy only the labels in the txt file
for i=1:length(lbl)
    out_nii.vol(in==lbl(i))=lbl(i);
end

save_nifti(out_nii,out_file);

end

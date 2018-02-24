function remapSegmentationLabels( in_seg_nii, in_label_mapping, output_label_mapping, out_folder)
%Remaps segmentation labels using a label mapping text file, writing out
%individual images and a combined label image.  The input indices, in the label
%mapping text file are assumed to be the line numbers (1:end). 

%in_seg_nii='~/projects/atlases/MNI152_1mm/labels/t1/HarvardOxford/HarvardOxford-cort-maxprob-thr50-1mm.nii.gz';
%in_label_mapping='~/pipeline/cfg/labels/HarvardOxford-Cortical_withLobes.csv';
%output_labels='~/pipeline/cfg/labels/Lobes.csv';
%out_folder='~/tmp_labels';

mkdir(out_folder);

in_labels=importdata(in_label_mapping,',',0);
in_names=in_labels.rowheaders;
in_ids=in_labels.data;

output_labels=importdata(output_label_mapping,',',0);
out_names=output_labels.rowheaders;
out_ids=output_labels.data;


in_seg=load_nifti(in_seg_nii);

out_seg=in_seg;
out_seg.vol=zeros(size(out_seg.vol));

for i=1:length(out_names)

    tmp_seg=in_seg;
    tmp_seg.vol=zeros(size(out_seg.vol));
    
    ind_seg=find(in_ids==out_ids(i));
    for j=1:length(ind_seg)
        out_seg.vol(in_seg.vol==ind_seg(j))=out_ids(i);
        tmp_seg.vol(in_seg.vol==ind_seg(j))=1;
    end
    
    %write out tmp_seg
    save_nifti(tmp_seg,sprintf('%s/%s.nii.gz',out_folder,out_names{i}));
        
end

%remove generation of all_segs image (unused..)
%save_nifti(out_seg,sprintf('%s/all_segs.nii.gz',out_folder));


end



function computeSegStats (label_csv,label_root,label_path,img_root,img_path,subjlist,out_csv,out_mat)
% 
% label_csv='/home/ROBARTS/alik/vasst-dev-local/pipeline/cfg/labels/name_number/JHU-labels.csv'
% 
% label_root='/eq-nas/alik/EpilepsyDatabase/EPL14B';
% img_root='/eq-nas/alik/EpilepsyDatabase/EPL14B';
% 
% label_path='labels/t1map/JHU_bspline_f3d_rigid_aladin_MNI152_1mm/JHU-ICBM-labels-1mm.nii.gz'
% img_path='extra_mri/t1map.nii.gz'
% 
% subjlist='etc/lists/study_TLE';
% out_csv='test.csv';
% out_mat='test.mat';





label_list=importdata(label_csv);

subjects=importdata(subjlist);
fid=fopen(out_csv,'w+');


%write to both csv and mat file
row_label=subjects;
col_label=label_list.textdata;
mean_data=zeros(length(subjects),length(label_list.textdata));


%header line
fprintf(fid,'subj');
for l=1:length(label_list.textdata)
    fprintf(fid,',%s',label_list.textdata{l});
end
fprintf(fid,'\n');


for s=1:length(subjects)
    
    subj=subjects{s};
    
    label_nii=sprintf('%s/%s/%s',label_root,subj,label_path);
    img_nii=sprintf('%s/%s/%s',img_root,subj,img_path);
    
    label=load_nifti(label_nii);
    img=load_nifti(img_nii);
    
    fprintf(fid,'%s',subj);
    for i=1:length(label_list.textdata)
        
        inds=find(label.vol==label_list.data(i));
        mean_data(s,i)=mean(img.vol(inds));
        fprintf(fid,',%f',mean_data(s,i));
    end
    fprintf(fid,'\n');
    
    
end

fclose(fid);

save(out_mat,'mean_data','row_label','col_label');


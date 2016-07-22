%% get landmarks for stain coregistration validation -- on HE, GFAP, NEUN --
function loadHistologyAnnotation (annot_folder , res_microns);

hist_microns=0.5;

ds=res_microns./hist_microns;

[path,annot_name,ext]=fileparts(annot_folder);

out_dir=sprintf('%s/../%dum_nii_annot/histspace/%s',path,res_microns,annot_name);
mkdir(out_dir);

files=dir(sprintf('%s/*.xml',annot_folder));


orientcsv=sprintf('%s/../tif/orientation.csv',path);
orient=importdata(orientcsv);
orientflags=orient.data;
tifs=orient.textdata;


for f=1:length(files)
    
[xmlpath,name,ext]=fileparts(files(f).name);

xml=sprintf('%s/%s%s',annot_folder,name,ext);

split=strsplit(name,'_');

%get stain type at end of name:
s=name;

subj=name(1:8);
stain_type=split{end};
strct=split{end-2}; %Hp or Neo

tif=sprintf('%s/../tif/%s.tif',path,name);
index=find(strcmp(tifs,sprintf('%s.tif',name)));
    

imgSizes=mexAperioTiff(tif);
imsize=imgSizes(1,:);
orientflag=orientflags(index);

ds_size=ceil(imsize./ds);
roi_ds=uint8(zeros(ds_size(1),ds_size(2)));



[contours,contoursClosed,names,names_alt]=readAperioXMLContours(xml);
    
    
for c=1:length(contours)
    
    if (length(contours{c})==0)
        disp('no contours');
        continue;
    end
    
                label_num=c;

  %  figure;
        for roi=1:length(contours{c})
            
            lmk=contours{c}{roi};
            
            curr_ds=poly2mask(lmk(:,1)./ds,lmk(:,2)./ds,ds_size(1),ds_size(2));
                        
            roi_ds(curr_ds==1)=label_num;
       %     imagesc(roi_ds);
        end
end 
            


noRot_dir=sprintf('%s/../%dum_nii_annot/%s',path,res_microns,annot_name);
mkdir(noRot_dir);
out_mat=sprintf('%s/%s.mat',noRot_dir,name);
roi=roi_ds;
save(out_mat,'roi');



mkdir(out_dir);

roi=rotateImgTiffSpaceWithOrient(roi_ds,tif,orientcsv);

out_mat=sprintf('%s/%s.mat',out_dir,name);
save(out_mat,'roi');


%save as nifti
nii=make_nii(imrotate(roi,-90),[res_microns./1000,res_microns./1000,4.4],[0,0,0],16);

niifile=sprintf('%s/%s.nii',out_dir,name);
save_nii(nii,niifile);
gzip(niifile);
delete(niifile);



end

    
 
    
end




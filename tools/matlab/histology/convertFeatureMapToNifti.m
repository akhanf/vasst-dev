function convertFeatureMapToNiftii( feat_name, tif )

%feat_name=100um_FeatureMaps

[path,name,ext]=fileparts(tif);

%mat file:
featdir=sprintf('%s/../%s',path,feat_name);
featmap=sprintf('%s/%s.mat',featdir,name);


load(featmap);

orientcsv=sprintf('%s/orientation.csv',path);


for i=1:length(features)


    
outdir=sprintf('%s/histspace/%s',featdir,features{i});
mkdir(outdir);

featRot=rotateImgTiffSpaceWithOrient(featureVec(:,:,i),tif,orientcsv);

if(~exist('res_microns'))
res_microns=100
end

inplane_mm=res_microns/1000;

%save as nifti
nii=make_nii(imrotate(featRot,-90),[inplane_mm,inplane_mm,4.4],[0,0,0],16);

niifile=sprintf('%s/%s.nii',outdir,name);
save_nii(nii,niifile);
gzip(niifile);
delete(niifile);


end





end



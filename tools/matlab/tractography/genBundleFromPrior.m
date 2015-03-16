function genBundleFromPrior(subj,bundle_name)

%subj='SYN00003a';
%bundle_name='InferiorLongitudinal_Left';

threshold=0.025; % 0.025 seems to be decent enough, calibrated on Cingulum and ILF of SYN00003a


data_dir=sprintf('%s/dti/synaptive',subj);

whole_brain_bfloat=sprintf('%s/wholebrain.Tracts.Bfloat',data_dir);
whole_brain_uid_buint32=sprintf('%s/wholebrain.Tracts.uid.Buint32',data_dir);

%load in tracts
all_tracts=readCaminoTracts(whole_brain_bfloat);
all_tracts_uid=readTractUID(whole_brain_uid_buint32);

bundle_dir=sprintf('%s/dti/synaptive/parcellated.Tracts.wm_bundles_bspline_f3d_rigid_aladin_ctrl_avg',subj);


%load in spatial prior stats file if one exists
spatial_probprior_file=sprintf('%s/%s_probprior_stats.txt', bundle_dir,bundle_name);
if(exist(spatial_probprior_file,'file'))
    priors=importdata(spatial_probprior_file);
end



%write out vtk
selected_tracts=all_tracts(priors>threshold);

out_vtk=sprintf('%s/%s_bundle_prior.vtk',bundle_dir,bundle_name);
out_bfloat=sprintf('%s/%s_bundle_prior.Bfloat',bundle_dir,bundle_name);

writeTractsToVTK(selected_tracts,ones(size(selected_tracts,1),1),out_vtk);
writeCaminoTracts(selected_tracts,out_bfloat);

end

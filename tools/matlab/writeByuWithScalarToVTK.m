function writeByuWithScalarToVTK(in_byu,in_mat,out_vtk);

%data_dir='/home/ROBARTS/alik/EpilepsyDatabase/standard/projects/penny_striatum/with_dti'
%template_byu=sprintf('%s/surfdisp_data/surfdisp_singlestruct_striatum_unbiasedAvg_affine/template/dstriatum_nii.byu',data_dir);

tmpfile=sprintf('/tmp/tempsurf%d.txt',rand(1)*10000);
dlmwrite(tmpfile,in_mat);

system(sprintf('CombineBYUandSurfDist %s %s %s',in_byu,tmpfile,out_vtk));

delete(tmpfile);
end

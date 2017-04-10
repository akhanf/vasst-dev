function fitNODDI_general(in_dwi,in_mask,out_noddi_folder);

%determine what the shells are based on bvalues

mkdir(out_noddi_folder);
zipdwi=0;
if (strcmp(in_dwi(end-1:end),'gz'))
    gunzip(in_dwi);
    in_dwi=in_dwi(1:end-3);
    zipdwi=1;
end

zipmask=0;
if (strcmp(in_mask(end-1:end),'gz'))
    gunzip(in_mask);
    in_mask=in_mask(1:end-3);
    zipmask=1;
end

in_bval=[in_dwi(1:end-3),'bval'];
in_bvec=[in_dwi(1:end-3),'bvec'];

out_roi=sprintf('%s/roi.mat',out_noddi_folder);
out_params=sprintf('%s/FittedParams.mat',out_noddi_folder);
out_prefix=sprintf('%s/noddi',out_noddi_folder);

%remove existing results if they exist
if (exist(out_roi))
delete(out_roi);
end

if (exist(out_params))
delete(out_params);
end

CreateROI(in_dwi,in_mask,out_roi);

if (zipdwi)
    gzip(in_dwi);
end

if (zipmask)
    gzip(in_mask);
end

protocol=MultiShell2Protocol(in_bval,in_bvec);
noddi=MakeModel('WatsonSHStickTortIsoV_B0');
batch_fitting(out_roi,protocol,noddi,out_params);
SaveParamsAsNIfTI(out_params,out_roi,in_mask,out_prefix);


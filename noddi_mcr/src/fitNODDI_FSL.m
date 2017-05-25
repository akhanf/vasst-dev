function runNODDI_FSL(in_dwi_hdr,in_mask_hdr,in_bval, in_bvec,out_noddi_folder);


mkdir(out_noddi_folder);

out_roi=sprintf('%s/roi.mat',out_noddi_folder);
out_params=sprintf('%s/FittedParams.mat',out_noddi_folder);
out_prefix=sprintf('%s/noddi',out_noddi_folder);


CreateROI(in_dwi_hdr, in_mask_hdr , out_roi );
protocol = FSL2Protocol(in_bval,in_bvec);

noddi=MakeModel('WatsonSHStickTortIsoV_B0');
batch_fitting(out_roi,protocol,noddi,out_params);
SaveParamsAsNIfTI(out_params,out_roi,in_mask_hdr,out_prefix);


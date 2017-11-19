function correctFieldMapJson(bids_dir,sub,ses)

if (exist('ses','var'))
sub_dir=sprintf('%s/%s/%s',bids_dir,sub,ses);
sub_prefix=sprintf('%s_%s',sub,ses);
else
sub_dir=sprintf('%s/%s',bids_dir,sub);
sub_prefix=sprintf('%s',sub);
end

phasediff_json_file=sprintf('%s/fmap/%s_phasediff.json',sub_dir,sub_prefix);
mag1_json_file=sprintf('%s/fmap/%s_magnitude1.json',sub_dir,sub_prefix);
mag2_json_file=sprintf('%s/fmap/%s_magnitude2.json',sub_dir,sub_prefix);

rest_nii=sprintf('%s/func/%s_task-rest_bold.nii.gz',sub_dir,sub_prefix);

disp(phasediff_json_file);
disp(mag1_json_file);
disp(mag2_json_file);
disp(rest_nii);


phasediff_json=loadjson(phasediff_json_file)
mag1_json=loadjson(mag1_json_file)
mag2_json=loadjson(mag2_json_file)

phasediff_json.EchoTime1=mag1_json.EchoTime;
phasediff_json.EchoTime2=mag2_json.EchoTime;
phasediff_json.IntendedFor=rest_nii;

%need to add write permission before saving..
system(sprintf('chmod a+w %s',phasediff_json_file));
savejson('',phasediff_json,phasediff_json_file);
system(sprintf('chmod a-w %s',phasediff_json_file));


end
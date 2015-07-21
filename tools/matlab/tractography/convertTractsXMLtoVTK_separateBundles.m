function convertTractsXMLtoVTK_separateBundles(in_xml,affinity_th,out_vtk_prefix);

%in_xml='EPI_V042.xml';
%out_vtk='EPI_V042.vtk';

camino_tracts='temp_tracts.Bfloat';
tract_uid_file='temp_uid.uint32';
tract_labels_file='temp_labels.uint16';
tract_affinity_file='temp_labels.Bfloat';

convertTractsXMLtoCamino(in_xml,camino_tracts,tract_uid_file,tract_labels_file,tract_affinity_file);
tracts=readCaminoTracts(camino_tracts);
delete(camino_tracts);


scalari=1;

if (exist(tract_uid_file))
fid=fopen(tract_uid_file,'r');
Ntracts=fread(fid,1,'uint32',0,'b');
tract_uid=uint32(fread(fid,Ntracts,'uint32',0,'b'));
fclose(fid);
delete(tract_uid_file);


scalars{scalari,1}=tract_uid; scalars{scalari,2}='uid'; scalars{scalari,3}='unsigned_int';
scalari=scalari+1;
end

if exist(tract_labels_file)
fid=fopen(tract_labels_file,'r');
Ntracts=fread(fid,1,'uint16',0,'b');
tract_labels=uint16(fread(fid,Ntracts,'uint16',0,'b'));
fclose(fid);
delete(tract_labels_file);

scalars{scalari,1}=tract_labels; scalars{scalari,2}='labels'; scalars{scalari,3}='unsigned_short';


scalari=scalari+1;

end

if (exist(tract_affinity_file))
fid=fopen(tract_affinity_file,'r');
Ntracts=fread(fid,1,'single',0,'b');
tract_affinity=single(fread(fid,Ntracts,'single',0,'b'));
fclose(fid);
delete(tract_affinity_file);


scalars{scalari,1}=tract_affinity; scalars{scalari,2}='affinity'; scalars{scalari,3}='float';


scalari=scalari+1;

end



[bundle_names,bundle_labels]=getBundleNamesLabelsTractXML(in_xml);


[i_lbl,j_lbl]=ind2sub(size(scalars), find(strcmp(scalars,'labels')));
label_scalars=scalars{i_lbl,1};


[i_aff,j_aff]=ind2sub(size(scalars), find(strcmp(scalars,'affinity')));
affinity_scalars=scalars{i_aff,1};

ind_affinity=(affinity_scalars>=affinity_th);


for l=1:length(bundle_labels)
    name=bundle_names{l};
    label=bundle_labels(l);

    out_vtk=sprintf('%s_%s_affinity%g.vtk',out_vtk_prefix,name,affinity_th); 
    ind_labels=(label_scalars==label) & ind_affinity;
    writeTractsToVTK_noScalars(tracts(ind_labels),out_vtk);

end

%get CST separately 
cst_inds=find(strncmp('Cortico_Spinal',bundle_names,14));
lcst=cst_inds([1,3]);
rcst=cst_inds([2,4]);

out_vtk=sprintf('%s_%s_affinity%g.vtk',out_vtk_prefix,'CST_Left',affinity_th); 
ind_labels=(label_scalars==lcst(1) | label_scalars==lcst(2) )& ind_affinity;
writeTractsToVTK_noScalars(tracts(ind_labels),out_vtk);


out_vtk=sprintf('%s_%s_affinity%g.vtk',out_vtk_prefix,'CST_Right',affinity_th); 
ind_labels=(label_scalars==rcst(1) | label_scalars==rcst(2) )& ind_affinity;
writeTractsToVTK_noScalars(tracts(ind_labels),out_vtk);

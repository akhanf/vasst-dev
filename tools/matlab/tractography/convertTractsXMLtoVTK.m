function convertTractsXMLtoVTK(in_xml,out_vtk);

%in_xml='EPI_V042.xml';
%out_vtk='EPI_V042.vtk';

camino_tracts='temp_tracts.Bfloat';
tract_uid_file='temp_uid.uint32';

convertTractsXMLtoCamino(in_xml,camino_tracts,tract_uid_file);
tracts=readCaminoTracts(camino_tracts);


fid=fopen(tract_uid_file,'r');
Ntracts=fread(fid,1,'uint32',0,'b');
tract_uid=uint32(fread(fid,Ntracts,'uint32',0,'b'));
fclose(fid);

rm(camino_tracts);
rm(tract_uid_file);

writeTractsToVTK_withUID(tracts,tract_uid,out_vtk);

end
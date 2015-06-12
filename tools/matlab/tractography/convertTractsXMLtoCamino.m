function convertTractsXMLtoCamino (in_xml,out_Bfloat,out_uid_Buint32,out_labels_Buint16,out_affinity_Bfloat)
% function for extracting tract data from Synaptive XML to camino raw
% Bfloat (can convert from this to vtk with vtkstreamlines)

max_java_memory = java.lang.Runtime.getRuntime.maxMemory;

 foo=xmlread(in_xml);
 
%get point data
pointdata=foo.getElementsByTagName('Data').item(0).getElementsByTagName('PointData').item(0);

points_base64=pointdata.getElementsByTagName('Points').item(0).getFirstChild.getData;
points_uint8=uint8(char(points_base64));
points_float3=typecast(org.apache.commons.codec.binary.Base64.decodeBase64(points_uint8),'single');

npoints=length(points_float3)/3;

points=single(zeros(npoints,3));
points(:,1)=-points_float3(1:3:end);
points(:,2)=-points_float3(2:3:end);
points(:,3)=points_float3(3:3:end);

%get FA data
%favalues_base64=pointdata.getElementsByTagName('FaValues').item(0).getFirstChild.getData;
%favalues_uint8=uint8(char(favalues_base64));
%favalues_float=typecast(org.apache.commons.codec.binary.Base64.decodeBase64(favalues_uint8),'single');

%get tract data (indices into points

tractdata=foo.getElementsByTagName('Data').item(0).getElementsByTagName('TractData').item(0).getElementsByTagName('Tracts').item(0);

ntracts=(tractdata.getLength-1)/2;
tracts=cell(ntracts,1);
tracts_uid=uint32(zeros(ntracts,1));


for i=0:ntracts-1
    
tracts_uid(i+1)=sscanf(char(tractdata.item(i*2+1).getAttribute('UID')),'%u');
tract_base64=tractdata.item(i*2+1).getTextContent;
tract_uint8=uint8(char(tract_base64));
tract_uint32=typecast(org.apache.commons.codec.binary.Base64.decodeBase64(tract_uint8),'uint32');

tracts{i+1}=tract_uint32+1; %change indexing to matlab (start from 1)

end


%write out to Bfloat file
fid=fopen(out_Bfloat,'w');
for i=1:ntracts
    fwrite(fid,length(tracts{i}),'single',0,'b');
    %fwrite(fid,tracts_uid(i),'single',0,'b');
    fwrite(fid,0,'single',0,'b');
    fwrite(fid,reshape(points(tracts{i},:)',length(tracts{i})*3,1),'single',0,'b');
end
fclose(fid);

%write out uid file
fid=fopen(out_uid_Buint32,'w');
fwrite(fid,length(tracts_uid),'uint32',0,'b');
fwrite(fid,tracts_uid,'uint32',0,'b');
fclose(fid);


%get label data
   
labeldata=foo.getElementsByTagName('Data').item(0).getElementsByTagName('TractData').item(0).getElementsByTagName('Labels').item(0);

if (~isempty(labeldata))

labeldata.getAttribute('encoding');
label_type=labeldata.getAttribute('Element');
%labeldata.getAttribute('NumberOfElements')

label_encoded=labeldata.getTextContent;
label_uint8=uint8(char(label_encoded));
label_uint32=typecast(org.apache.commons.codec.binary.Base64.decodeBase64(label_uint8),'uint16');


%write out labels file
fid=fopen(out_labels_Buint16,'w');
fwrite(fid,length(label_uint32),'uint16',0,'b');
fwrite(fid,label_uint32,'uint16',0,'b');
fclose(fid);

end




affinitydata=foo.getElementsByTagName('Data').item(0).getElementsByTagName('TractData').item(0).getElementsByTagName('Affinity').item(0);
if (~isempty(affinitydata))

affinitydata.getAttribute('encoding');
affinity_type=affinitydata.getAttribute('Element');

affinity_encoded=affinitydata.getTextContent;
affinity_uint8=uint8(char(affinity_encoded));
affinity_float=typecast(org.apache.commons.codec.binary.Base64.decodeBase64(affinity_uint8),'single');


%write out affinity file
fid=fopen(out_affinity_Bfloat,'w');
fwrite(fid,length(affinity_float),'single',0,'b');
fwrite(fid,affinity_float,'single',0,'b');
fclose(fid);
end




%test read
% fid=fopen(out_uid_Buint32,'r');
% test_len=fread(fid,1,'uint32',0,'b');
% test_uid=uint32(fread(fid,test_len,'uint32',0,'b'));
% fclose(fid);
 


end

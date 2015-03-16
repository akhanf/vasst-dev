function [ tracts_uid ] = readTractUID( in_uint32 )

fid=fopen(in_uint32,'r');
tract_length=fread(fid,1,'uint32',0,'b');
tracts_uid=uint32(fread(fid,tract_length,'uint32',0,'b'));
fclose(fid);


end


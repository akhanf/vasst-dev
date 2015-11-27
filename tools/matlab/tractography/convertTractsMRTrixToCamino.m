function  convertTractsMRTrixToCamino( in_tck, out_Bfloat )
%convertTractsMRTrixToVTK Converts mrtrix format tracts to VTK

tract_struct=read_mrtrix_tracks(in_tck);
tracts=tract_struct.data;
ntracts=length(tracts);

%write out to Bfloat file
fid=fopen(out_Bfloat,'w');
for i=1:ntracts
    fwrite(fid,length(tracts{i}),'single',0,'b');
    fwrite(fid,0,'single',0,'b');
  
    fwrite(fid,reshape(tracts{i}',length(tracts{i})*3,1),'single',0,'b');
end

fclose(fid);

end

function writeCaminoTracts (tracts, out_Bfloat )

ntracts=length(tracts);
fid=fopen(out_Bfloat,'w');
for i=1:ntracts
    fwrite(fid,length(tracts{i}),'single',0,'b');
    fwrite(fid,0,'single',0,'b');
    fwrite(fid,reshape(tracts{i}',length(tracts{i})*3,1),'single',0,'b');
end
fclose(fid);

end

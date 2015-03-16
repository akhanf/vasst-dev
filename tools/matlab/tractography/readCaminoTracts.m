function [tracts] = readCaminoTracts (in_Bfloat)


%first load in raw data
fid=fopen(in_Bfloat,'r');

[data,count]=fread(fid,inf,'single',0,'b');

if (count==0)
    tracts={};
else
    
iter=1;
i=1;
while i<count
    N=data(i);
    tracts{iter}=zeros(N,3);
    tracts{iter}=reshape(data(i+2:i+1+N*3),3,N)';
    iter=iter+1;
    i=i+2+N*3;
end
    
end

fclose(fid);
end



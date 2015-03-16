function tracts=readTractsFromVTK (in_vtk)

%output format is list of cells, each cell a different tract
fid=fopen(in_vtk,'r');
%skip 1st 4 lines
for i=1:4
fgetl(fid);
end

N=fscanf(fid,'POINTS %d float\n');
points=zeros(N*3,1);
points=fread(fid,N*3,'float',0,'b');
points=reshape(points,3,N)';

fgetl(fid);
ntracts=fscanf(fid,'LINES %d');
nindices=fscanf(fid,' %d\n');

tracts=cell(ntracts,1);

for t=1:ntracts
    
tlength=fread(fid,1,'int',0,'b');
tracts{t}=zeros(tlength,3);
indices=fread(fid,tlength,'int',0,'b');
tracts{t}=points(indices+1,:);
end

fclose(fid);
end
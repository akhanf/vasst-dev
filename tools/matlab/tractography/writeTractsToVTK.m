%writing custom colored vtk -- given tracts cell, and color cell
function writeTractsToVTK(in_tracts,in_scalars,out_vtk)


%first write out basic vtk point data

points=cat(1,in_tracts{:});


%for testing:
%scalars=abs(mean(points,2)); %for testing

points_vec=reshape(points',size(points,1)*3,1);

lines=[];
%zeros(size(points,1)+length(tracts),1);
ind=0;
for i=1:length(in_tracts);
    npts=length(in_tracts{i});
    lines=[lines, npts, (0:(npts-1)) + ind];
    ind=ind+npts;
end


    
fid=fopen(out_vtk,'w');

fprintf(fid,'# vtk DataFile Version 3.0\n');
fprintf(fid,'Camino tracts\n');
fprintf(fid,'BINARY\n');
fprintf(fid,'DATASET POLYDATA\n');
fprintf(fid,'POINTS %d float\n',size(points,1));

%write all points
%px,py,pz
%px,py,pz ...

fwrite(fid,points_vec,'float',0,'b');

fprintf(fid,'\n');
fprintf(fid,'LINES %d %d\n',length(in_tracts),size(lines,2));

%write all lines (indices to these points)
%numPoints,ind1,ind2,ind3...
%...

fwrite(fid,lines,'int',0,'b');
fprintf(fid,'\n');


%add colour here..
fprintf(fid,'CELL_DATA %d\n',length(in_tracts));
fprintf(fid,'POINT_DATA %d\n',size(points,1));
fprintf(fid,'SCALARS roi float 1\n');
fprintf(fid,'LOOKUP_TABLE default\n');

fwrite(fid,in_scalars,'float',0,'b');
fprintf(fid,'\n');


fclose(fid);

end
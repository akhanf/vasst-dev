function convertTagToVTK ( tagfile, vtkfile);


%tagfile='../Patient1/electrodes.tag';
%outfile='../Patient1/electrodes.vtk';

fid=fopen(tagfile,'r');
tags=textscan(fid,'%f %f %f %f %f %f %s %s','HeaderLines',1,'Delimiter',{'','\b','\t','"'},'MultipleDelimsAsone',1);


fclose(fid);

N=length(tags{1});


fid=fopen(vtkfile,'w');
%now write out vtk file
fprintf(fid,'# vtk DataFile Version 2.0\n');
fprintf(fid,'Electrodes\n');
fprintf(fid,'ASCII\n');
fprintf(fid,'DATASET POLYDATA\n');
fprintf(fid,'POINTS %d float\n',N);
for i=1:N
    %LPS - RAS conversion
fprintf(fid,'%f %f %f\n',-tags{1}(i),-tags{2}(i),tags{3}(i));
end
fclose(fid);

%write labels to txt file
label_file=[vtkfile(1:(end-4)) '_labels.txt'];
fid=fopen(label_file,'w');
for i=1:N
fprintf(fid,'%s\n',tags{8}{i});
end
fclose(fid);


%write slicer annotations

annot_dir=[vtkfile(1:(end-4)) '_acsv'];
mkdir(annot_dir);

for i=1:N
acsvfile=sprintf('%s/electrode_%03d.acsv',annot_dir,i);
%create acsv files too
fid=fopen(acsvfile,'w');
fprintf(fid,'# Annotation file %s\n',acsvfile);
fprintf(fid,'# Name = %s\n',tags{8}{i});
fprintf(fid,'point|%f|%f|%f|1|1\n',tags{1}(i),tags{2}(i),tags{3}(i));
fclose(fid);

end





end

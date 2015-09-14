function convertRegAladinToSlicerTfm (xfm, out_tfm)

%tfm = importdata(in_tfm, ' ', 3);
xfm=importdata(xfm);

%xfm=eye(4,4);
%xfm(1:3,1:3)=reshape(tfm.data(1,1:9),3,3)';
%xfm(1:3,4)=tfm.data(1,10:12)';


%slicer tfm is in LPS and is the inverse 

lps2ras=[-1 0 0 0 ; 0 -1 0 0; 0 0 1 0; 0 0 0 1];


%ras_xfm=inv(lps2ras)*inv(xfm)*lps2ras

slicer_xfm=inv(inv(lps2ras)*inv(xfm)*lps2ras)

fid=fopen(out_tfm,'w');

fprintf(fid,'#Insight Transform File V1.0\n');
fprintf(fid,'## Transform 0\n');
fprintf(fid,'Transform: AffineTransform_double_3_3\n');
fprintf(fid,'Parameters: %g %g %g %g %g %g %g %g %g %g %g %g\n',slicer_xfm(1:3,1:3)',slicer_xfm(1:3,4));
fprintf(fid,'FixedParameters: 0 0 0\n');

fclose(fid);
%dlmwrite(out_tfm,ras_xfm,' ');

end


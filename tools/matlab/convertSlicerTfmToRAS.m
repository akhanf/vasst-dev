function convertSlicerTfmToRAS (in_tfm, out_xfm)

tfm = importdata(in_tfm, ' ', 3);
xfm=eye(4,4);
xfm(1:3,1:3)=reshape(tfm.data(1,1:9),3,3)';
xfm(1:3,4)=tfm.data(1,10:12)';


%slicer tfm is in LPS and is the inverse 

lps2ras=[-1 0 0 0 ; 0 -1 0 0; 0 0 1 0; 0 0 0 1];


%ras_xfm=inv(lps2ras)*inv(xfm)*lps2ras
ras_xfm=inv(lps2ras)*xfm*lps2ras

dlmwrite(out_xfm,ras_xfm,' ');

end


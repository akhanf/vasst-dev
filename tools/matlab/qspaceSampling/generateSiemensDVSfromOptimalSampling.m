%% load optimal sampling from http://www.emmanuelcaruyer.com/q-space-sampling.php

optimal=importdata('optimalSampling_130_2shells.txt');
%optimal=importdata('optimalSampling_180_3shells.txt');


ndir=size(optimal.data,1);

%number of b0
nb0_between=10;
nb0_init=0;
 
nb0=nb0_init+nb0_between;

%intersperse the b0's..
spacing=floor(ndir/(nb0*1.2));


% siemens scanner puts a b0 automatically, so don't need this..
 %put first zero

 if(nb0_init>0);
 sampling_withb0=[zeros(nb0_init,4); optimal.data];
 else
 sampling_withb0=optimal.data;
 end
 


for i=1:nb0_between
    
   insertion=i+spacing*i;
   sampling_withb0=[sampling_withb0(1:insertion,:); zeros(1,4); sampling_withb0((insertion+1):end,:);];
   
end

shell=sampling_withb0(:,1);

nshells=max(shell);
normshell=shell./nshells;

bval=sqrt(normshell);


bvec=repmat(bval,1,3).*sampling_withb0(:,2:4);


%% write bvec to dvs file
out_file=sprintf('optimal_sampling_%d_shells_%d_dir_%d_b0.dvs',nshells,ndir,nb0);
fid=fopen(out_file,'w');
fprintf(fid,'# Vector set from optimal sampling of %d shells, %d directions, and %d b0\n',nshells,ndir,nb0);
fprintf(fid,'[directions=%d]\n',size(bvec,1));
fprintf(fid,'CoordinateSystem = xyz\n');
fprintf(fid,'Normalisation = none\n');

for i=1:size(bvec,1)

fprintf(fid,'Vector[%d] = (\t %1.6f, \t %1.6f, \t %1.6f )\n',i-1,bvec(i,:));
norm(bvec(i,:));

end

fclose(fid);


%% write bvec and bval for recon

out_bvec=sprintf('optimal_sampling_%d_shells_%d_dir_%d_b0.bvec',nshells,ndir,nb0);
out_bval=sprintf('optimal_sampling_%d_shells_%d_dir_%d_b0.bval',nshells,ndir,nb0);


%bvalue multiplier
bval_mult=2600;  %set in scanner

fid=fopen(out_bval,'w');
fprintf(fid,'%d\n',bval_mult*bval);
fclose(fid);

fid=fopen(out_bvec,'w');
for i=1:size(bvec,1)
fprintf(fid,'%0.3f %0.3f %0.3f\n',bvec(i,:));
end
fclose(fid);


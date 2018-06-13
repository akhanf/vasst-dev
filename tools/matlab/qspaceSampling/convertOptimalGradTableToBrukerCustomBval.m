function convertOptimalGradTableToBrukerCustomBval( optimal_txt, out_file ,bvalScaling,nb0_init,nb0_between)
% obtain optimal sampling from http://www.emmanuelcaruyer.com/q-space-sampling.php


%bvalScaling=[0.5,1];  %same as bvalScaling=[1000,2000];
%nb0_between=10;
%nb0_init=1;



% scanner will add 3 b0 scans to beginning, and last 3 directions will be
% lost --> so put 3 b0 scans on the end to account for this..



optimal=importdata(optimal_txt);
%optimal=importdata('optimalSampling_130_2shells.txt');
%optimal=importdata('optimalSampling_180_3shells.txt');


ndir=size(optimal.data,1);

%number of b0 (excluding implicit 1)
nb0_end=0;

nb0_implicit=0;


nb0=nb0_init+nb0_between+nb0_implicit+nb0_end;


%intersperse the b0's..
spacing=ceil(ndir/nb0);


% siemens scanner puts a b0 automatically, so don't need this..
%put first zero

sampling_withb0=optimal.data;

if(nb0_init>0);
    sampling_withb0=[zeros(nb0_init,4);  sampling_withb0];
end


if(nb0_end>0);
    sampling_withb0=[sampling_withb0; zeros(nb0_end,4)];
end


for i=1:nb0_between
    
    insertion=i+spacing*i;
    sampling_withb0=[sampling_withb0(1:insertion,:); zeros(1,4); sampling_withb0((insertion+1):end,:);];
    
end

shell=sampling_withb0(:,1);

for i=1:length(bvalScaling)
    shell(shell==i)=bvalScaling(i);
end

%unit normalize
nshells=max(shell);
normshell=shell./nshells;

bval=sqrt(normshell);


bvec=repmat(bval,1,3).*sampling_withb0(:,2:4);


% write bvec to dvs file

%out_file=sprintf('optimal_sampling_%d_shells_%d_dir_%d_b0.dvs',nshells,ndir,nb0);
fid=fopen(out_file,'w');
fprintf(fid,'[directions=%d]\n',ndir+nb0);
fprintf(fid,'CoordinateSystem = xyz\n');
fprintf(fid,'Normalization = none\n');

for i=1:length(bvec)
    fprintf(fid,'Vector[%d] = ( %1.6f, %1.6f, %1.6f )',i-1,bvec(i,:));
    if (i~=length(bvec))
        fprintf(fid,'\n');
    end
    
end
fclose(fid);


end


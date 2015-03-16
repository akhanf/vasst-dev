function [sym_hausdorff_distance , sym_mean_distance] = computeBundleDistanceMetrics_nii(in_nii_1,in_nii_2)


label1=load_nifti(in_nii_1);
[i,j,k]=ind2sub(size(label1.vol),find(label1.vol==1));
vox_coord_1=[i,j,k,zeros(length(i),1)];
ras_coord_1=vox_coord_1*label1.vox2ras;
ras_coord_1=ras_coord_1(:,1:3); %drop homogeneous coord

label2=load_nifti(in_nii_2);
[i,j,k]=ind2sub(size(label2.vol),find(label2.vol==1));
vox_coord_2=[i,j,k,zeros(length(i),1)];
ras_coord_2=vox_coord_2*label2.vox2ras;
ras_coord_2=ras_coord_2(:,1:3); %drop homogeneous coord

pointsA=ras_coord_1;
pointsB=ras_coord_2;

 N=size(pointsA,1);
 M=size(pointsB,1);
 
mindistA=zeros(N,1);

for i=1:N
    %get min dist 
    a1=repmat(pointsA(i,:),M,1);
    mindistA(i)=min(sqrt(sum((a1-pointsB).^2,2)));
end


mindistB=zeros(M,1);

for i=1:M
    %get min dist 
    a1=repmat(pointsB(i,:),N,1);
    mindistB(i)=min(sqrt(sum((a1-pointsA).^2,2)));
end


%return symmetrized mean closest point distance
sym_mean_distance=mean([mean(mindistA),mean(mindistB)]);
sym_hausdorff_distance=mean([max(mindistA),max(mindistB)]);


end
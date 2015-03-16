function [sym_hausdorff_distance , sym_mean_distance] = computeBundleDistanceMetrics(bundleA,bundleB)

 pointsA=cat(1,bundleA{:});
 pointsB=cat(1,bundleB{:});
 
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
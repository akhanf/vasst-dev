function [ mcp ] = computeMeanClosestPointTractDistance( tract1,tract2 ,M)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


%plot them both
%figure; plot3(tract1(:,1),tract1(:,2),tract1(:,3),'r');
%hold on;
% plot3(tract2(:,1),tract2(:,2),tract2(:,3),'b');

ind1=round(linspace(1,size(tract1,1),M));
ind2=round(linspace(1,size(tract2,1),M));

tract1s=tract1(ind1,:);
tract2s=tract2(ind2,:);

%mean closest point
%get mean distance from each point on tract1 to tract2

mindist=zeros(M,2);

for i=1:M
    %get min dist 
    a1=repmat(tract1s(i,:),M,1);
    mindist(i,1)=min(sqrt(sum((a1-tract2s).^2,2)));
end

for i=1:M
    %get min dist 
    a1=repmat(tract2s(i,:),M,1);
    mindist(i,2)=min(sqrt(sum((a1-tract1s).^2,2)));
end

%return symmetrized mean closest point distance
mcp=mean(mean(mindist,1),2);



end


function [ mcp ] = computeMeanTractDistance( tract1,tract2 ,M)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


%plot them both
%figure; plot3(tract1(:,1),tract1(:,2),tract1(:,3),'r');
%hold on;
% plot3(tract2(:,1),tract2(:,2),tract2(:,3),'b');

ind1=round(linspace(1,length(tract1),M));
ind2=round(linspace(1,length(tract2),M));
ind2_rev=round(linspace(length(tract2),1,M));

tract1_sub=tract1(ind1,:);

tract2_sub=tract2(ind2,:);

%mean closest point
mcp_fwd=mean(sum((tract1(ind1,:)-tract2(ind2,:)).^2,2));
%mean closest point with tract reversed 
mcp_rev=mean(sum((tract1(ind1,:)-tract2(ind2_rev,:)).^2,2));

%if(mcp_rev<mcp_fwd)
%    revflag=true;
%else
%    revflag=false;
%end
    
%return min of these
mcp=min(mcp_fwd,mcp_rev);



end


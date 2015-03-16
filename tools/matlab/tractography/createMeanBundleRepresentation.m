function [ mean_bundle ] = createMeanBundleRepresentation( tracts ,M)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%M=10

%compute mean representation

tract1=tracts{1};
ind1=round(linspace(1,length(tract1),M));

accum_bundle=tract1(ind1,:);

for i=2:length(tracts)
    tract2=tracts{i};
    ind2=round(linspace(1,length(tract2),M));
    ind2_rev=round(linspace(length(tract2),1,M));

    %mean closest point
    mcp_fwd=mean(sum((tract1(ind1,:)-tract2(ind2,:)).^2,2));
    %mean closest point with tract reversed 
    mcp_rev=mean(sum((tract1(ind1,:)-tract2(ind2_rev,:)).^2,2));

    if (mcp_rev<mcp_fwd)
        accum_bundle=accum_bundle+tract2(ind2_rev,:);
    else
        accum_bundle=accum_bundle+tract2(ind2,:);
    end
end

mean_bundle=accum_bundle./length(tracts);




end


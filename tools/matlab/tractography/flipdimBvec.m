function flipdimBvec( in_bvec, dims,out_bvec)

bv=dlmread(in_bvec);

if (size(bv,1)==3)
    bv(dims,:)=-bv(dims,:);
else
    bv(:,dims)=-bv(:,dims);
end

dlmwrite(out_bvec,bv,' ');
end
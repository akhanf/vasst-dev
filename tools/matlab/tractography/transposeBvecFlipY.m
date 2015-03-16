function transposeBvecFlipY( in_bvec, out_bvec)

bv=dlmread(in_bvec);

if (size(bv,1)==3)
    bv(2,:)=-bv(2,:);
else
    bv(:,2)=-bv(:,2);
end

dlmwrite(out_bvec,bv',' ');
end
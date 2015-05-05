function transposeBvec( in_bvec, out_bvec)

bv=dlmread(in_bvec);

dlmwrite(out_bvec,bv',' ');
end

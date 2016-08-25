function fixSiemensDiffusionBvec (in_file, out_file)

bvecs=importdata(in_file);
dimflip=[2,3];

if(size(bvecs,1)==3)
   
    bvecs(dimflip,:)=-bvecs(dimflip,:);
    
else
    if (size(bvecs,2)==3)
        
        bvecs(:,dimflip)=-bvecs(:,dimflip);
    else
        disp('bvec does not have 3 dimensions!')
    end
    
    
end

dlmwrite(out_file,bvecs,' ');

end
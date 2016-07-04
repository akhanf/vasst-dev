function transformByuLinearXfm ( in_byu, in_xfm, out_byu, invertXfm)
%Given xfm that takes images from A to B, takes a surface from A to B


    T=importdata(in_xfm);

    if (exist('invertXfm'))
       T=inv(T);
    end
    
    [faces,vertices]=readTriByu(in_byu);
    
    transformed=inv(T)*[vertices';ones(1,length(vertices))];
    vertices_transformed=transformed(1:3,:)';
    faces(:,3)=-faces(:,3);  %output needs last edge negated
    
    writeTriByu(out_byu,faces,vertices_transformed);
    
    
end
    
    
    


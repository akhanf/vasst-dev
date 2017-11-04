function total_area=computeSurfArea(verts,edges,selection)

edge_vec=reshape(edges,3,size(edges,1)/3);

total_area=0;
for e=1:size(edge_vec,2)
    
    vert_inds=abs(edge_vec(:,e));
    
    %check if all inds are in selection
    
    if(any(selection(vert_inds)==0))
        continue 
    end
        
    vi=verts(abs(edge_vec(:,e)),:);
   
    d12=sqrt(sum((vi(1,:)-vi(2,:)).^2));
    d13=sqrt(sum((vi(1,:)-vi(3,:)).^2));
    d23=sqrt(sum((vi(2,:)-vi(3,:)).^2));
    s=0.5*(d12+d13+d23);
    total_area=total_area+sqrt(s*(s-d12)*(s-d13)*(s-d23));
    
end

%for v=1:size(verts,1)
%    find(abs(edge_vec)==1)
%    
%end
%total_area

end
function generateNormalizedDisplacements(in_template_byu,in_prop_byu,out_vec_txt,out_inout_txt,out_norm_byu,out_vec_vtk,out_inout_vtk)
%in_template_byu='../template/dstriatum_ana_crop.byu';
%in_prop_byu='propSurface_dstriatum.byu';

%normalized displacement defined as local vertex displacement minus local
%neighbourhood average displacement

%size of neighbourhood for normalizing displacement
B=10; 

[faces,vertices]=readTriByu(in_prop_byu);
[faces_t,vertices_t]=readTriByu(in_template_byu);


%for each vert

    
%prealloc
    sel=ones(length(vertices),1);
    avdisp=zeros(1,3);

    adj_disp=zeros(length(vertices),3);
for v=1:length(vertices)
        sel=ones(length(vertices),1);

    coord=vertices(v,:);
    %get all vertices within a ball of B millimeters
    for i=1:3
    sel=sel & coord(i)<vertices(:,i)+B & coord(i)>vertices(:,i)-B ;
    end
    
    %find the average displacement from template to subject within the ball
    avdisp=mean(vertices(sel,:)-vertices_t(sel,:),1);
    
    %use that to translate template
    adj_disp(v,:)=vertices(v,:)-vertices_t(v,:)-avdisp;
    progressbar(v,length(vertices));
end

dlmwrite(out_vec_txt,adj_disp,' ');

%write modified byu for computing 
faces_t(:,3)=-faces_t(:,3);
writeTriByu(out_norm_byu,faces_t,vertices_t+adj_disp);

%could perhaps later replace these with matlab code..
system(sprintf('compdisp %s %s > %s',in_template_byu,out_norm_byu,out_inout_txt));
system(sprintf('CombineBYUandSurfDist %s %s %s',in_template_byu,out_inout_txt,out_inout_vtk));
system(sprintf('ConvertBYUandVectorDataToVTK %s %s %s',in_template_byu,out_vec_txt,out_vec_vtk));


end

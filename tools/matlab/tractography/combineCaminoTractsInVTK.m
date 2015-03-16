%combine tracts 
% left_tracts=readCaminoTracts('Cortico_Spinal_Left_bundle.Bfloat');
% right_tracts=readCaminoTracts('Cortico_Spinal_Right_bundle.Bfloat');
% 
% in_tracts{1}='Cortico_Spinal_Left_bundle.Bfloat';
% in_tracts{2}='Cortico_Spinal_Right_bundle.Bfloat';
% 
% in_tracts{1}='Arcuate_Left_bundle.Bfloat';
% in_tracts{2}='Arcuate_Right_bundle.Bfloat';

function combineCaminoTractsInVTK ( in_bfloat_list, out_vtk )

all_tracts=[];
all_scalars=[];
%in_tracts=varargin;
in_tracts=importdata(in_bfloat_list);
for i=1:length(in_tracts)
    
  tracts=readCaminoTracts(in_tracts{i});
  
  scalars=ones(length(cat(1,tracts{:})),1).* i;

  all_tracts=[all_tracts, tracts];
  all_scalars=[all_scalars; scalars];
  
end

writeTractsToVTK(all_tracts,all_scalars,out_vtk);

end
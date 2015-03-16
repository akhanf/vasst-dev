%combine tracts 
% left_tracts=readCaminoTracts('Cortico_Spinal_Left_bundle.Bfloat');
% right_tracts=readCaminoTracts('Cortico_Spinal_Right_bundle.Bfloat');
% 
% in_tracts{1}='Cortico_Spinal_Left_bundle.Bfloat';
% in_tracts{2}='Cortico_Spinal_Right_bundle.Bfloat';
% 
% in_tracts{1}='Arcuate_Left_bundle.Bfloat';
% in_tracts{2}='Arcuate_Right_bundle.Bfloat';

function combineCaminoTractsInVTK_withLUT ( in_bfloat_list, in_lut_csv,out_vtk)

lut=importdata(in_lut_csv);


all_tracts=[];
all_scalars=[];


all_mean_tracts=[];
all_mean_scalars=[];

%in_tracts=varargin;
in_tracts=importdata(in_bfloat_list);
for i=1:length(in_tracts)
%i
  tracts=readCaminoTracts(in_tracts{i});
  
  [path,name,ext]=fileparts(in_tracts{i});
  
  prefix=name(1:end-7); %take off _bundle
   
  label=lut.data(strcmp(prefix,lut.textdata));
  
  scalars=ones(length(cat(1,tracts{:})),1).* label;

  all_tracts=[all_tracts, tracts];
  all_scalars=[all_scalars; scalars];
% 
%   if (length(tracts)==0)
%       mean_tract={};
%       mean_scalars=[];
%   else
%   mean_tract={createMeanBundleRepresentation(tracts,100)};
%   mean_scalars=ones(100,1).* label;
%   
%   %write out mean bundle too
%   writeCaminoTracts(mean_tract,[path filesep name '_mean_bundle.Bfloat']);
%   
%   
%   end
%   all_mean_tracts=[all_mean_tracts,mean_tract];
%   all_mean_scalars=[all_mean_scalars;mean_scalars];
%    
  
  
end

writeTractsToVTK(all_tracts,all_scalars,out_vtk);
% writeTractsToVTK(all_mean_tracts,all_mean_scalars,out_mean_bundle_vtk);


end
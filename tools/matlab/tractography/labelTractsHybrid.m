% cleaner script for tract labelling

% given initial bundles:

function labelTractsHybrid ( subj)



in_lut_csv='~/pipeline/cfg/labels/FibreBundleLUT.csv';
lut=importdata(in_lut_csv);

%without custom tractography settings:
data_dir=sprintf('%s/dti/synaptive',subj);

whole_brain_bfloat=sprintf('%s/wholebrain.Tracts.Bfloat',data_dir);
whole_brain_uid_buint32=sprintf('%s/wholebrain.Tracts.uid.Buint32',data_dir);


bundle_dir=sprintf('%s/parcellated.Tracts.wm_bundles_bspline_f3d_rigid_aladin_ctrl_avg',data_dir);
in_bfloat_list=sprintf('%s/all_bundles.txt',bundle_dir);
labeled_out_vtk=sprintf('%s/all_tracts_MCP_labelled.vtk',bundle_dir);

%tract simplification for distance metric
M=15;



%% load bundles
in_tracts=importdata(in_bfloat_list);

nbundles=length(in_tracts);

init_bundles=cell(nbundles,1);
bundle_label=zeros(nbundles,1);
bundle_name=cell(nbundles,1);

for i=1:length(in_tracts)
    
  init_bundles{i}=readCaminoTracts(in_tracts{i});
  
  [path,name,ext]=fileparts(in_tracts{i});
  
  %if (length(tracts)==0)
  %    mean_bundles{i}=zeros(M,3);
  %else
  %    mean_bundles{i}=createMeanBundleRepresentation(tracts,M);
  %end
    
  prefix=name(1:end-7); %take off _bundle
  
  bundle_name{i}=prefix;
  bundle_label(i)=lut.data(strcmp(prefix,lut.textdata));
  
  max_tracts=100;
  
  %subsample tracts if > 100
  if (length(init_bundles{i})>max_tracts)
      randomind=randperm(length(init_bundles{i}));
      init_bundles{i}=init_bundles{i}(randomind(1:max_tracts));
  end
  
end


%% compute adjacency matrix for each bundle

adj_bundle=cell(nbundles,1);
mean_bundle=cell(nbundles,1);

%figure; 
%hold on;
for i=1:nbundles
    
    
    
    N=length(init_bundles{i});
    if(N==0)
       continue
    end
    
    adj_bundle{i}=zeros(N,N);
   
    
    %now compute mean dist for each whoel brain tract to mean bundle
    for x=1:N
        for y=1:N
           if(y>x) %only fill in upper triangle of matrix (symmetric)
            adj_bundle{i}(x,y)=computeMeanClosestPointTractDistance(init_bundles{i}{x},init_bundles{i}{y},M);
            adj_bundle{i}(y,x)=adj_bundle{i}(x,y);
           end
        end
    end
    
    %pick tract with minimal distance to the rest
    [mindist,minind]=min(mean(adj_bundle{i},1));
    mean_bundle{i}=init_bundles{i}{minind};
    
    %plot it:
  %  plotFibreTract(mean_bundle{i},'b');
    
end




%% load all tracts
all_tracts=readCaminoTracts(whole_brain_bfloat);
all_tracts_uid=readTractUID(whole_brain_uid_buint32);

N=length(all_tracts);
K=length(mean_bundle);
maxDist=1e5;
dist_matrix=ones(N,K).*maxDist;

%now compute mean dist for each whoel brain tract to mean bundle
for i=1:length(all_tracts)
    
    for k=1:length(mean_bundle)
        if(isempty(mean_bundle{k}))
            continue
        end
    dist_matrix(i,k)=computeMeanClosestPointTractDistance(all_tracts{i},mean_bundle{k},10);
    
    end
   % i/length(all_tracts)*100
   % progressbar(i,length(all_tracts));
  i
end

%% assign labels based on dist to mean tracts, with a threshold of XX


for dist_threshold=2:2:16
    



[minval,minind]=min(dist_matrix,[],2);


selected_tracts=all_tracts(minval<dist_threshold);

minind_selected_tracts=minind(minval<dist_threshold);

disp(sprintf('Selecting %2.2f percent of tracts for bundles',length(selected_tracts)/length(all_tracts).*100));

N=length(selected_tracts);
tract_label=zeros(N,1);
scalars=zeros(length(cat(1,selected_tracts{:})),1);



startind=1;
for i=1:N
    
    tract_label(i)=bundle_label(minind_selected_tracts(i));
     
    %if(minval>dist_threshold)
    %    tract_label(i)=-100;
    %end
    
    
    endind=startind+length(selected_tracts{i})-1;
    scalars(startind:endind)= ones(length(selected_tracts{i}),1).*tract_label(i);
    startind=endind+1;
end
labeled_out_vtk=sprintf('%s/00_tracts_distFiltToMean_th%02d.vtk',bundle_dir,dist_threshold);

writeTractsToVTK(selected_tracts,scalars,labeled_out_vtk);

end







end





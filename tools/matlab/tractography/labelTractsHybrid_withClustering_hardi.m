% cleaner script for tract labelling

% given initial bundles:

function labelTractsHybrid_withClustering_hardi ( subj)


%subj='1.2.840.113845.11.1000000001951524609.20130802093226.6697837';
lut_color={'r','b','g','c','k','m','r','b','g','c','k','m','r','b','g','c','k','m','r','b','g','c','k','m','r','b','g','c','k','m'};
plot_on=false;


in_lut_csv='~/pipeline/cfg/labels/FibreBundleLUT_2014_11_15.csv';
lut=importdata(in_lut_csv);

out_lut_csv='~/pipeline/cfg/labels/FibreBundleOutputLUT_2014_11_15.csv';
out_lut=importdata(out_lut_csv);

%without custom tractography settings:
%data_dir=sprintf('%s/dti/synaptive',subj);
data_dir=sprintf('%s/dti/distortCorrect/caminoTractographyHARDI',subj);

whole_brain_bfloat=sprintf('%s/wholebrain.Bfloat',data_dir);
%whole_brain_uid_buint32=sprintf('%s/wholebrain.Tracts.uid.Buint32',data_dir);
whole_brain_vtk=sprintf('%s/wholebrain.Tracts.vtk',data_dir);


bundle_dir=sprintf('%s/parcellated.wholebrain.wm_bundles_bspline_f3d_rigid_aladin_ctrl_avg',data_dir);
in_bfloat_list=sprintf('%s/all_bundles.txt',bundle_dir);
labeled_out_vtk=sprintf('%s/all_tracts_MCP_labelled.vtk',bundle_dir);

%tract simplification for distance metric
M=15;

%for affinity matrix:
    sigma=2;
    sigma=15;
    scaling=2*sigma^2;


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
    
    max_tracts=200;
    
    %subsample tracts if > 100
    if (length(init_bundles{i})>max_tracts)
        randomind=randperm(length(init_bundles{i}));
        init_bundles{i}=init_bundles{i}(randomind(1:max_tracts));
    end
    
end


%% compute adjacency matrix for each bundle

adj_bundle=cell(nbundles,1);
mean_bundle=cell(nbundles,1);

if(plot_on)
    figure;
    hold on;
end

for i=1:nbundles
    
    
    i;
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
    
    if(plot_on)
        %plot it:
        plotFibreTract(mean_bundle{i},lut_color{i});
    end
end

%% clustering -- new version -- uses graph affinities and spectral clustering..

%max_clusters=6;
max_distance=10;


max_clusters=3.*ones(length(bundle_name),1); %default to 3
max_clusters(strncmp(bundle_name,'Corpus',6))=8; %set larger number of clusters for corpus callosum

%haven't implemented this yet:
%min_tracts_in_cluster=5;  %minimum number of tracts in a cluster,
                    %if less than this, then cluster is discarded as an outlier


%we have adjacency matrix
% how many clusters do we need?
%  enough so that maximal distance is below a threshold


mean_bundles=cell(nbundles,1);
mean_bundles_label=cell(nbundles,1);
mean_bundles_weight=cell(nbundles,1);


for i=1:nbundles
    
    N=length(init_bundles{i});
    
    
    
    if (N<max_clusters(i))
        %not enough to cluster
        mean_bundles{i}={mean_bundle{i}};
        mean_bundles_label{i}=i;
        mean_bundles_weight{i}=1;
        continue;
        
    end
    
    
    
    dist_matrix=adj_bundle{i};

    %sigma=2;
  %  sigma=10;
  %  scaling=2*sigma^2;

    A=exp(-dist_matrix.^2./scaling);
    for j=1:length(A)
        A(j,j)=0;
    end
    
        
    if(plot_on)
        
        figure;
        ploti=1;
    end
    
    nclusters=1:max_clusters(i);
    
    for nclusi=1:length(nclusters)
        nclus=nclusters(nclusi);
        
        
        %3 to select Jordan Weiss normalized spec clustering
        [C, L, U] = SpectralClustering(A, nclus,3);
  
        %plot membership
        
        if(plot_on)
            
            subplot(2,length(nclusters),nclusi);
            hold on;
            for j=1:length(init_bundles{i});
                plotFibreTract(init_bundles{i}{j},lut_color{C(j)});
            end
            
        end
        
        mean_bundles_cluster=cell(nclus,1);
        
        mean_bundles_cluster_weight=cell(nclus,1);

        mean_bundles_=cell(nclus,1);

        mean_dist_clus=zeros(nclus,1);
        for k=1:nclus
            
            clus_inds=(C==k);
            orig_inds=find(clus_inds);
            
            adj_cluster=adj_bundle{i}(clus_inds,clus_inds);
            [mindist,minind]=min(mean(adj_cluster,1));
            mean_dist_clus(k)=max(adj_cluster(minind,:)); %find max distance from the mean tract to rest of cluster
            mean_bundles_cluster{k}=init_bundles{i}{orig_inds(minind)};
            
            %weight of bundle as the relative proportion of tracts in that
            %cluster
            mean_bundles_cluster_weight{k}=sum(C==k)/length(C)*nclus;

        end
        
        if(plot_on)
            subplot(2,length(nclusters),nclusi+length(nclusters));
            bar(mean_dist_clus);
            ylim([0,50]);
        end
        if(max(mean_dist_clus) <max_distance)
            %we have enough clusters
            chosen_nclus=nclus;
            break;
        end
        
        

    end
    
    mean_bundles_label{i}=ones(length(mean_bundles_cluster),1).* i;
    mean_bundles{i}=mean_bundles_cluster;
    mean_bundles_weight{i}=mean_bundles_cluster_weight;
end


all_mean_labels=cat(1,mean_bundles_label{:});
all_mean_bundles=cat(1,mean_bundles{:});
all_mean_bundles_weight=cat(1,mean_bundles_weight{:});



%% load all tracts
all_tracts=readCaminoTracts(whole_brain_bfloat);
%all_tracts_uid=readTractUID(whole_brain_uid_buint32);

N=length(all_tracts);
K=length(all_mean_bundles);
maxDist=1e5;
dist_matrix=ones(N,K).*maxDist;

%now compute mean dist for each whoel brain tract to mean bundle
for i=1:length(all_tracts)
    
    for k=1:K
        if(isempty(all_mean_bundles{k}))
            continue
        end
        dist_matrix(i,k)=computeMeanClosestPointTractDistance(all_tracts{i},all_mean_bundles{k},10);
        
    end
    % i/length(all_tracts)*100
    % progressbar(i,length(all_tracts));
    %i
end


A=exp(-dist_matrix.^2./scaling);


%%  added Dec 12, 2014 - weighted affinity

%following maps rep bundle indices to bundle names

% rep_labels=bundle_label(all_mean_labels);
% optimal_affinity=importdata('optimal_affinity_scaling.txt');
% affinity_scaling=zeros(length(all_mean_labels),1);
% 
% for rb=1:length(rep_labels)
%      affinity_scaling(rb)=optimal_affinity.data(find(strcmp(out_lut.textdata(find(rep_labels(rb)==out_lut.data)),optimal_affinity.textdata)));
%    
% end
% 
% 
% 
% scaling_new=2.*(repmat(affinity_scaling',N,1).*sigma).^2;
% 
% A_scaled=exp(-dist_matrix.^2./scaling_new);

% cost_dist_scaled=A_scaled;


%% new multi-parametric cost

%costs are NxL (where L is number of labels -- incl clusters)

% 1st term is the distance to the mean bundles

%affinity instead:
cost_dist=A;
%cost_dist=dist_matrix; 




%./dist_normalization;


% 2nd term is the initial label membership
%  ** problem ** don't have the UIDs (or even the indices)
% not saved when camino procstreamlines is run

  % skip this for now, then.. 
  

% 3rd term is the image-based constraint
img_cost=zeros(size(cost_dist));

for i=1:length(all_mean_labels)
    
    %load in spatial prior stats file if one exists
    spatial_prior_file=sprintf('%s/%s_prior_stats.txt', bundle_dir,bundle_name{all_mean_labels(i)});
    if(exist(spatial_prior_file,'file'))
        img_cost(:,i)=importdata(spatial_prior_file);
    end

end


% 4th term is the image-based constraint
probimg_cost=zeros(size(cost_dist));

for i=1:length(all_mean_labels)
    
    %load in spatial prior stats file if one exists
    spatial_probprior_file=sprintf('%s/%s_probprior_stats.txt', bundle_dir,bundle_name{all_mean_labels(i)});
    if(exist(spatial_probprior_file,'file'))
        probimg_cost(:,i)=importdata(spatial_probprior_file);
    end

end

%exclusion zones
exclude_cost=zeros(size(cost_dist));
for i=1:length(all_mean_labels)
    
    %load in spatial prior stats file if one exists
    exclude_file=sprintf('%s/%s_exclude_stats.txt', bundle_dir,bundle_name{all_mean_labels(i)});
    if(exist(exclude_file,'file'))
        exclude_cost(:,i)=importdata(exclude_file);
    end

end

%penalize any exclusion heavily
exclude_cost=100.*exclude_cost.^(1/10);






%% cost with affinities -- maximizing instead


for alpha_img_cost=0%:0.1:0.3%   0:0.025:0.05     %weight for image cost

for beta_img_cost=0%:25:50%[0,1000]%0:10:30;%[0,10,100,1000,10000]; %weight for prob cost

    %negexp_prob=beta_img_cost.*exp(-100.*probimg_cost);  %exponential weight of 100 inflates spatial priors from P~=0.06 -> P~=1
    
    
    
    %combined_cost=negexp_prob+cost_dist;

   %negexp_dist=exp(-cost_dist);
   % norm_probimg_cost=probimg_cost./max(probimg_cost(:));
    
    combined_cost=cost_dist + alpha_img_cost.*img_cost + beta_img_cost.*probimg_cost - exclude_cost;
  %  combined_cost=cost_dist .* exp(-beta_img_cost.*probimg_cost);% - alpha_img_cost.*img_cost - beta_img_cost.*probimg_cost;
 % combined_cost=negexp_dist.*norm_probimg_cost;

    [maxval,maxind]=max(combined_cost,[],2);
  
    
for dist_threshold=0.1:0.05:0.95 %10%5:5:20 %[2:2:16, 20,30,40]
    
    
        
    selected_tracts=all_tracts(maxval>dist_threshold);
    maxind_selected_tracts=maxind(maxval>dist_threshold);
    
    
    
    disp(sprintf('Selecting %2.2f percent of tracts for bundles',length(selected_tracts)/length(all_tracts).*100));
    
    N=length(selected_tracts);
    tract_label=zeros(N,1);
    scalars=zeros(length(cat(1,selected_tracts{:})),1);
    
    
    
    startind=1;
    for i=1:N
        
        tract_label(i)=bundle_label(all_mean_labels(maxind_selected_tracts(i)));
        
        %if(minval>dist_threshold)
        %    tract_label(i)=-100;
        %end
        
        
        endind=startind+length(selected_tracts{i})-1;
        scalars(startind:endind)= ones(length(selected_tracts{i}),1).*tract_label(i);
        startind=endind+1;
    end
    labeled_out_vtk=sprintf('%s/00_tracts_AffinityCost_alpha%g_beta%g_Test_th%02d.vtk',bundle_dir,alpha_img_cost,beta_img_cost,dist_threshold);
    
    writeTractsToVTK(selected_tracts,scalars,labeled_out_vtk);
    
    
    %write indiv vtk files for comparison against slicer
    out_vtk_dir=sprintf('%s/vtk_alpha%g_beta%g_th%02d',bundle_dir,alpha_img_cost,beta_img_cost,dist_threshold);
    mkdir(out_vtk_dir);
    for i=1:length(out_lut.textdata)
            vtk_file=sprintf('%s/%s.vtk',out_vtk_dir,out_lut.textdata{i});
            
                %this_bundle=all_tracts(:,maxval>dist_threshold & maxind == bundle_label(i));

                this_ind=(maxval>dist_threshold & bundle_label(all_mean_labels(maxind)) == out_lut.data(i));
                this_bundle=all_tracts(this_ind);
                scalars=ones(length(cat(1,this_bundle{:})),1);

                writeTractsToVTK(this_bundle,scalars,vtk_file);
    end

 %   for i=1:
    
    
end

end

end

    
    


%% cost with affinities - weighted!

% 
% for alpha_img_cost=0%:0.1:0.3%   0:0.025:0.05     %weight for image cost
% 
% for beta_img_cost=0%:25:50%[0,1000]%0:10:30;%[0,10,100,1000,10000]; %weight for prob cost
% 
%     %negexp_prob=beta_img_cost.*exp(-100.*probimg_cost);  %exponential weight of 100 inflates spatial priors from P~=0.06 -> P~=1
%     
%     
%     
%     %combined_cost=negexp_prob+cost_dist;
% 
%    %negexp_dist=exp(-cost_dist);
%    % norm_probimg_cost=probimg_cost./max(probimg_cost(:));
%     
%     combined_cost=cost_dist_scaled + alpha_img_cost.*img_cost + beta_img_cost.*probimg_cost - exclude_cost;
%   %  combined_cost=cost_dist .* exp(-beta_img_cost.*probimg_cost);% - alpha_img_cost.*img_cost - beta_img_cost.*probimg_cost;
%  % combined_cost=negexp_dist.*norm_probimg_cost;
% 
%     [maxval,maxind]=max(combined_cost,[],2);
%   
%     
% for dist_threshold=0.1:0.05:0.95 %10%5:5:20 %[2:2:16, 20,30,40]
%     
%     
%         
%     selected_tracts=all_tracts(maxval>dist_threshold);
%     maxind_selected_tracts=maxind(maxval>dist_threshold);
%     
%     
%     
%     disp(sprintf('Selecting %2.2f percent of tracts for bundles',length(selected_tracts)/length(all_tracts).*100));
%     
%     N=length(selected_tracts);
%     tract_label=zeros(N,1);
%     scalars=zeros(length(cat(1,selected_tracts{:})),1);
%     
%     
%     
%     startind=1;
%     for i=1:N
%         
%         tract_label(i)=bundle_label(all_mean_labels(maxind_selected_tracts(i)));
%         
%         %if(minval>dist_threshold)
%         %    tract_label(i)=-100;
%         %end
%         
%         
%         endind=startind+length(selected_tracts{i})-1;
%         scalars(startind:endind)= ones(length(selected_tracts{i}),1).*tract_label(i);
%         startind=endind+1;
%     end
%     labeled_out_vtk=sprintf('%s/00_tracts_AffinityCostWeighted_alpha%g_beta%g_Test_th%02d.vtk',bundle_dir,alpha_img_cost,beta_img_cost,dist_threshold);
%     
%     writeTractsToVTK(selected_tracts,scalars,labeled_out_vtk);
%     
%     
%     %write indiv vtk files for comparison against slicer
%     out_vtk_dir=sprintf('%s/vtk_alpha%g_beta%g_weighted_th%02d',bundle_dir,alpha_img_cost,beta_img_cost,dist_threshold);
%     mkdir(out_vtk_dir);
%     for i=1:length(out_lut.textdata)
%             vtk_file=sprintf('%s/%s.vtk',out_vtk_dir,out_lut.textdata{i});
%             
%                 %this_bundle=all_tracts(:,maxval>dist_threshold & maxind == bundle_label(i));
% 
%                 this_ind=(maxval>dist_threshold & bundle_label(all_mean_labels(maxind)) == out_lut.data(i));
%                 this_bundle=all_tracts(this_ind);
%                 scalars=ones(length(cat(1,this_bundle{:})),1);
% 
%                 writeTractsToVTK(this_bundle,scalars,vtk_file);
%     end
% 
%  %   for i=1:
%     
%     
% end
% 
% end
% 
% end

    



%% clean up

if (plot_on)
    close all;
end

end


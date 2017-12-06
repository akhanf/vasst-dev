% calculates Euclidean distance in mm of intensity-based centroids from the
% template and transformed checkerboards

function compareCentroidIntensityWise(template,subjList,costFunction,transformationModel)

% import subject list
subjects=importdata(subjList);

% remove template from subject list
for i=1:length(subjects)
    if template==subjects{i}
        subjects(i,:)=[];
        break;
    end
end

if strcmp(costFunction, "t1") || strcmp(costFunction, "t2")
    
%% run if cost function is t1 or t2, runs comparison for both sides

    for i=1:length(subjects)
        
        % set file paths and import into arrays
        template_centroids_L=importdata(sprintf('~/khangrp/projects/unsorted/averageDeepBrain7T/7THippAtlas/eucDistDir/template_centroids/%s_gauss.l.centroids.txt',template),' ');
        template_centroids_R=importdata(sprintf('~/khangrp/projects/unsorted/averageDeepBrain7T/7THippAtlas/eucDistDir/template_centroids/%s_gauss.r.centroids.txt',template),' ');

        trans_centroids_L=importdata(sprintf('~/khangrp/projects/unsorted/averageDeepBrain7T/7THippAtlas/eucDistDir/%s_%s/%s_to_%s.l.centroids.txt',transformationModel,costFunction,subjects{i},template),' ');
        trans_centroids_R=importdata(sprintf('~/khangrp/projects/unsorted/averageDeepBrain7T/7THippAtlas/eucDistDir/%s_%s/%s_to_%s.r.centroids.txt',transformationModel,costFunction,subjects{i},template),' ');

        % initialize arrays that will hold the Euclidean distance between
        % centroids
        euclideanDistLeft=zeros(94,2);
        euclideanDistRight=zeros(94,2);

        euclideanDistLeft(:,1)=1:94;
        euclideanDistRight(:,1)=1:94;
        
        % calculate Euclidean distances and store
        dist_mat=pdist2(template_centroids_L,trans_centroids_L);
        dist=diag(dist_mat);
        euclideanDistLeft(:,2)=dist(:);
        
        dist_mat=pdist2(template_centroids_R,trans_centroids_R);
        dist=diag(dist_mat);
        euclideanDistRight(:,2)=dist(:);
        
        % calculate distances in mm
        mmDistLeft(:,1)=euclideanDistLeft(:,1);
        mmDistLeft(:,2)=euclideanDistLeft(:,2) .* 0.6;
        mmDistRight(:,1)=euclideanDistRight(:,1);
        mmDistRight(:,2)=euclideanDistRight(:,2) .* 0.6;
        
        dlmwrite(sprintf('eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',transformationModel,costFunction,subjects{i},template),mmDistLeft,' ');
        dlmwrite(sprintf('eucDistDir/%s_%s/%s_to_%s.r.10.dist_mm.txt',transformationModel,costFunction,subjects{i},template),mmDistRight,' '); 
        
    end

    
elseif strcmp(costFunction, "GM") || strcmp(costFunction, "GM_DB")
    
%% run if cost function is GM or GM_DB, runs comparison for left side only
    for i=1:length(subjects)
        
        % set file paths and import into arrays
        template_centroids_L=importdata(sprintf('~/khangrp/projects/unsorted/averageDeepBrain7T/7THippAtlas/eucDistDir/template_centroids/%s_gauss.l.centroids.txt',template),' ');

        trans_centroids_L=importdata(sprintf('~/khangrp/projects/unsorted/averageDeepBrain7T/7THippAtlas/eucDistDir/%s_%s/%s_to_%s.l.centroids.txt',transformationModel,costFunction,subjects{i},template),' ');

        % initialize arrays that will hold the Euclidean distance between
        % centroids
        euclideanDistLeft=zeros(94,2);
        euclideanDistLeft(:,1)=1:94;
        
        % calculate Euclidean distances and store
        dist_mat=pdist2(template_centroids_L,trans_centroids_L);
        dist=diag(dist_mat);
        euclideanDistLeft(:,2)=dist(:);
                
        % calculate distances in mm
        mmDistLeft(:,1)=euclideanDistLeft(:,1);
        mmDistLeft(:,2)=euclideanDistLeft(:,2) .* 0.6;
        
        dlmwrite(sprintf('eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',transformationModel,costFunction,subjects{i},template),mmDistLeft,' ');
        
    end
    
elseif strcmp(costFunction, "GM_r") || strcmp(costFunction, "GM_DB_r")

%% run if cost function is GM_r or GM_DB_r, runs comparison for right side only
    for i=1:length(subjects)
        
        % set file paths and import into arrays
        template_centroids_R=importdata(sprintf('~/khangrp/projects/unsorted/averageDeepBrain7T/7THippAtlas/eucDistDir/template_centroids/%s_gauss.r.centroids.txt',template),' ');

        trans_centroids_R=importdata(sprintf('~/khangrp/projects/unsorted/averageDeepBrain7T/7THippAtlas/eucDistDir/%s_%s/%s_to_%s.r.centroids.txt',transformationModel,costFunction,subjects{i},template),' ');

        % initialize arrays that will hold the Euclidean distance between
        % centroids
        euclideanDistRight=zeros(94,2);
        euclideanDistRight(:,1)=1:94;
        
        % calculate Euclidean distances and store       
        dist_mat=pdist2(template_centroids_R,trans_centroids_R);
        dist=diag(dist_mat);
        euclideanDistRight(:,2)=dist(:);
        
        % calculate distances in mm
        mmDistRight(:,1)=euclideanDistRight(:,1);
        mmDistRight(:,2)=euclideanDistRight(:,2) .* 0.6;
        
        dlmwrite(sprintf('eucDistDir/%s_%s/%s_to_%s.r.10.dist_mm.txt',transformationModel,costFunction,subjects{i},template),mmDistRight,' '); 
        
    end

end

end
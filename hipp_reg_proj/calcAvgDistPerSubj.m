% calculate average Euclidean distance for transformations to the target
% input template for each bin

function calcAvgDistPerSubj(template,subjList, transformationModel, costFunction)

% import subject list
subjects=importdata(subjList);

% remove template from subject list
for i=1:length(subjects)
    if template==subjects{i}
        subjects(i,:)=[];
        break;
    end
end

dir=('~/khangrp/projects/unsorted/averageDeepBrain7T/7THippAtlas/');

if strcmp(costFunction, "t1") || strcmp(costFunction, "t2")
    
%% run if cost function is t1 or t2, runs calculation for both sides
    
    allEucDistL=zeros(94,2,length(subjects));
    allEucDistR=zeros(94,2,length(subjects));

    for i=1:length(subjects)
        
        % set file paths and import into arrays
        dist_L=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',dir,transformationModel,costFunction,subjects{i},template),' ');
        dist_R=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.r.10.dist_mm.txt',dir,transformationModel,costFunction,subjects{i},template),' ');

        allEucDistL(:,:,i)=dist_L;
        allEucDistR(:,:,i)=dist_R;
        
    end
    
    avg_dist_L=mean(allEucDistL,3);
    avg_dist_R=mean(allEucDistR,3);
    
    dlmwrite(sprintf('%s/eucDistDir/avgDistDir/%s_%s/avg_to_%s.l.10.dist_mm.txt',dir,transformationModel,costFunction,template),avg_dist_L,' ');
    dlmwrite(sprintf('%s/eucDistDir/avgDistDir/%s_%s/avg_to_%s.r.10.dist_mm.txt',dir,transformationModel,costFunction,template),avg_dist_R,' ');
    
elseif strcmp(costFunction, "GM") || strcmp(costFunction, "GM_DB")
    
%% run if cost function is GM or GM_DB, runs calculation for left side only
    allEucDistL=zeros(94,2,length(subjects));

    for i=1:length(subjects)
        
        % set file paths and import into arrays
        dist_L=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',dir,transformationModel,costFunction,subjects{i},template),' ');
        allEucDistL(:,:,i)=dist_L;
        
    end
    
    avg_dist_L=mean(allEucDistL,3);   
    dlmwrite(sprintf('%s/eucDistDir/avgDistDir/%s_%s/avg_to_%s.l.10.dist_mm.txt',dir,transformationModel,costFunction,template),avg_dist_L,' ');
    
elseif strcmp(costFunction, "GM_r") || strcmp(costFunction, "GM_DB_r")

%% run if cost function is GM_r or GM_DB_r, runs calculation for right side only
    allEucDistR=zeros(94,2,length(subjects));

    for i=1:length(subjects)
        
        % set file paths and import into arrays
        dist_R=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.r.10.dist_mm.txt',dir,transformationModel,costFunction,subjects{i},template),' ');
        allEucDistR(:,:,i)=dist_R;
        
    end
    
    avg_dist_R=mean(allEucDistR,3);
    
    dlmwrite(sprintf('%s/eucDistDir/avgDistDir/%s_%s/avg_to_%s.r.10.dist_mm.txt',dir,transformationModel,costFunction,template),avg_dist_R,' ');

end

end
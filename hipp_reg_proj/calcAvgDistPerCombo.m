% calculate average Euclidean distance for transformation model/cost
% function combinations 

function calcAvgDistPerCombo(subjList,transformationModel,costFunction)

% import subject list
subjects=importdata(subjList);

dir=('~/khangrp/projects/unsorted/averageDeepBrain7T/7THippAtlas/');

if strcmp(costFunction, "t1") || strcmp(costFunction, "t2")
    
%% run if cost function is t1 or t2, runs calculation for both sides
    
    allSubjDistL=zeros(94,2,length(subjects));
    allSubjDistR=zeros(94,2,length(subjects));

    for i=1:length(subjects)
        
        % set file paths and import into arrays
        dist_L=importdata(sprintf('%s/eucDistDir/avgDistDir/%s_%s/avg_to_%s.l.10.dist_mm.txt',dir,transformationModel,costFunction,subjects{i}),' ');
        dist_R=importdata(sprintf('%s/eucDistDir/avgDistDir/%s_%s/avg_to_%s.r.10.dist_mm.txt',dir,transformationModel,costFunction,subjects{i}),' ');

        allSubjDistL(:,:,i)=dist_L;
        allSubjDistR(:,:,i)=dist_R;
        
    end
    
    avgAllSubj_dist_L=mean(allSubjDistL,3);
    avgAllSubj_dist_R=mean(allSubjDistR,3);
    
    dlmwrite(sprintf('%s/eucDistDir/avgDistDir/%s_%s/avgAllSubj.l.10.dist_mm.txt',dir,transformationModel,costFunction),avgAllSubj_dist_L,' ');
    dlmwrite(sprintf('%s/eucDistDir/avgDistDir/%s_%s/avgAllSubj.r.10.dist_mm.txt',dir,transformationModel,costFunction),avgAllSubj_dist_R,' ');
    
elseif strcmp(costFunction, "GM") || strcmp(costFunction, "GM_DB")
    
%% run if cost function is GM or GM_DB, runs calculation for left side only
    allSubjDistL=zeros(94,2,length(subjects));

    for i=1:length(subjects)
        
        % set file paths and import into arrays
        dist_L=importdata(sprintf('%s/eucDistDir/avgDistDir/%s_%s/avg_to_%s.l.10.dist_mm.txt',dir,transformationModel,costFunction,subjects{i}),' ');
        allSubjDistL(:,:,i)=dist_L;
        
    end
    
    avgAllSubj_dist_L=mean(allSubjDistL,3);
    dlmwrite(sprintf('%s/eucDistDir/avgDistDir/%s_%s/avgAllSubj.l.10.dist_mm.txt',dir,transformationModel,costFunction),avgAllSubj_dist_L,' ');
    
elseif strcmp(costFunction, "GM_r") || strcmp(costFunction, "GM_DB_r")

%% run if cost function is GM_r or GM_DB_r, runs calculation for right side only
    allSubjDistR=zeros(94,2,length(subjects));

    for i=1:length(subjects)
        
        % set file paths and import into arrays
        dist_R=importdata(sprintf('%s/eucDistDir/avgDistDir/%s_%s/avg_to_%s.r.10.dist_mm.txt',dir,transformationModel,costFunction,subjects{i}),' ');
        allSubjDistR(:,:,i)=dist_R;
        
    end
    
    avgAllSubj_dist_R=mean(allSubjDistR,3);
    dlmwrite(sprintf('%s/eucDistDir/avgDistDir/%s_%s/avgAllSubj.r.10.dist_mm.txt',dir,transformationModel,costFunction),avgAllSubj_dist_R,' ');

end

end
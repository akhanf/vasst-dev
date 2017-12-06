% performs a paired t-test using data collapsed into 10 AP bins
% (i.e. collapsed in the PD dimension) for each hemisphere

function calcTTest_APBin_bothHemi(subjList,transformationModel1,costFunction1,transformationModel2,costFunction2,AP_bin)

dir=('~/khangrp/projects/unsorted/averageDeepBrain7T/7THippAtlas/');

templates=importdata(subjList);

if AP_bin==1
    min=1;
    max=9;
    bin=9;
elseif AP_bin==2
    min=10;
    max=19;
    bin=10;
elseif AP_bin==3
    min=20;
    max=29;
    bin=10;
elseif AP_bin==4
    min=30;
    max=39;
    bin=10;
elseif AP_bin==5
    min=40;
    max=49;
    bin=10;
elseif AP_bin==6
    min=50;
    max=59;
    bin=10;
elseif AP_bin==7
    min=60;
    max=69;
    bin=10;
elseif AP_bin==8
    min=70;
    max=79;
    bin=10;
elseif AP_bin==9
    min=80;
    max=89;
    bin=10;
elseif AP_bin==10
    min=90;
    max=94;
    bin=5;
end

% if both tranformation model/cost function combinations are the same then
% exit function
if strcmp(costFunction1, costFunction2) && strcmp(transformationModel1,transformationModel2)
    return;

elseif (strcmp(costFunction1, "t1") || strcmp(costFunction1, "t2")) && (strcmp(costFunction2,"t1") || strcmp(costFunction2,"t2"))
%% if comparing t1/t2 to t1/t2, run comparison for both sides
    
    % initialize matrix to hold distances
    dist_mat_comb1=zeros(bin,264);
    dist_mat_comb2=zeros(bin,264);
    
    % iterate through templates to read in every left side distance file
    for i=1:length(templates)

        % initialize subject list for every template
        subjects=templates;

        % remove template from subject list
        for j=1:length(subjects)
            if templates{i}==subjects{j}
                subjects(j,:)=[];
                break;
            end
        end

        % iterate through subjects to populate distance matrix
        for j=1:length(subjects)
            
            % set matrix index where imported array will be put and
            % populate matrices
            val=((i - 1) * 11) + j;
            
            dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',dir,transformationModel1,costFunction1,subjects{j},templates{i}),' ');
            dist_mat_comb1(:,val)=dist(min:max,2);
            
            dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',dir,transformationModel2,costFunction2,subjects{j},templates{i}),' ');
            dist_mat_comb2(:,val)=dist(min:max,2);
            
        end
        
    end
    
    % iterate through templates to read in every right side distance file
    for i=1:length(templates)

        % initialize subject list for every template
        subjects=templates;

        % remove template from subject list
        for j=1:length(subjects)
            if templates{i}==subjects{j}
                subjects(j,:)=[];
                break;
            end
        end

        % iterate through subjects to populate distance matrix
        for j=1:length(subjects)
            
            % set matrix index where imported array will be put and
            % populate matrices
            val=((i - 1) * 11) + j + 132;
            
            dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.r.10.dist_mm.txt',dir,transformationModel1,costFunction1,subjects{j},templates{i}),' ');
            dist_mat_comb1(:,val)=dist(min:max,2);
            
            dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.r.10.dist_mm.txt',dir,transformationModel2,costFunction2,subjects{j},templates{i}),' ');
            dist_mat_comb2(:,val)=dist(min:max,2);
            
        end
        
    end
    
    vec_comb1=reshape(dist_mat_comb1,[bin*264, 1]);
    vec_comb2=reshape(dist_mat_comb2,[bin*264, 1]);  
    
    % perform paired t-tests and store results in matrices
    [~,p]=ttest(vec_comb1,vec_comb2);
    assignin('base','p',p);
    
    fprintf('Bin %i p-val: %4d\n',AP_bin,p);
        
elseif (strcmp(costFunction1,"GM") || strcmp(costFunction1,"GM_DB") || strcmp(costFunction1,"GM_r") || strcmp(costFunction1,"GM_DB_r"))  && (strcmp(costFunction2,'GM') || strcmp(costFunction2,'GM_DB') || strcmp(costFunction2,"GM_r") || strcmp(costFunction2,"GM_DB_r"))
%% if comparing GM/GM_DB to GM/GM_DB
    
    % initialize matrix to hold distances
    dist_mat_comb1=zeros(bin,264);
    dist_mat_comb2=zeros(bin,264);
    
    % iterate through templates to read in every left side distance file
    for i=1:length(templates)

        % initialize subject list for every template
        subjects=templates;

        % remove template from subject list
        for j=1:length(subjects)
            if templates{i}==subjects{j}
                subjects(j,:)=[];
                break;
            end
        end

        % iterate through subjects to populate distance matrix
        for j=1:length(subjects)
            
            % set matrix index where imported array will be put and
            % populate matrices
            val=((i - 1) * 11) + j;
            
            dist=importdata(sprintf('%s/eucDistDir/%s_GM/%s_to_%s.l.10.dist_mm.txt',dir,transformationModel1,subjects{j},templates{i}),' ');
            dist_mat_comb1(:,val)=dist(min:max,2);
            
            dist=importdata(sprintf('%s/eucDistDir/%s_GM_DB/%s_to_%s.l.10.dist_mm.txt',dir,transformationModel2,subjects{j},templates{i}),' ');
            dist_mat_comb2(:,val)=dist(min:max,2);
            
        end
        
    end
    
    % iterate through templates to read in every right side distance file
    for i=1:length(templates)

        % initialize subject list for every template
        subjects=templates;

        % remove template from subject list
        for j=1:length(subjects)
            if templates{i}==subjects{j}
                subjects(j,:)=[];
                break;
            end
        end

        % iterate through subjects to populate distance matrix
        for j=1:length(subjects)
            
            % set matrix index where imported array will be put and
            % populate matrices
            val=((i - 1) * 11) + j + 132;
            
            dist=importdata(sprintf('%s/eucDistDir/%s_GM_r/%s_to_%s.r.10.dist_mm.txt',dir,transformationModel1,subjects{j},templates{i}),' ');
            dist_mat_comb1(:,val)=dist(min:max,2);
            
            dist=importdata(sprintf('%s/eucDistDir/%s_GM_DB_r/%s_to_%s.r.10.dist_mm.txt',dir,transformationModel2,subjects{j},templates{i}),' ');
            dist_mat_comb2(:,val)=dist(min:max,2);
            
        end
        
    end
    
    vec_comb1=reshape(dist_mat_comb1,[bin*264, 1]);
    vec_comb2=reshape(dist_mat_comb2,[bin*264, 1]);  
    
    % perform paired t-tests and store results in matrices
    [~,p]=ttest(vec_comb1,vec_comb2);
    assignin('base','p',p);
    
    fprintf('Bin %i p-val: %4d\n',AP_bin,p);
    

elseif (strcmp(costFunction1,'t1') || strcmp(costFunction1,'t2')) && (strcmp(costFunction2,'GM') || strcmp(costFunction2,'GM_DB'))
%% if comparing t1/t2 to GM/GM_DB or vice versa
        
    % initialize matrix to hold distances
    dist_mat_comb1=zeros(bin,264);
    dist_mat_comb2=zeros(bin,264);
    
    % iterate through templates to read in every left side distance file
    for i=1:length(templates)

        % initialize subject list for every template
        subjects=templates;

        % remove template from subject list
        for j=1:length(subjects)
            if templates{i}==subjects{j}
                subjects(j,:)=[];
                break;
            end
        end

        % iterate through subjects to populate distance matrix
        for j=1:length(subjects)
            
            % set matrix index where imported array will be put and
            % populate matrices
            val=((i - 1) * 11) + j;
            
            dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',dir,transformationModel1,costFunction1,subjects{j},templates{i}),' ');
            dist_mat_comb1(:,val)=dist(min:max,2);
            
            dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',dir,transformationModel2,costFunction2,subjects{j},templates{i}),' ');
            dist_mat_comb2(:,val)=dist(min:max,2);
            
        end
        
    end
    
    % iterate through templates to read in every right side distance file
    for i=1:length(templates)

        % initialize subject list for every template
        subjects=templates;

        % remove template from subject list
        for j=1:length(subjects)
            if templates{i}==subjects{j}
                subjects(j,:)=[];
                break;
            end
        end

        % iterate through subjects to populate distance matrix
        for j=1:length(subjects)
            
            % set matrix index where imported array will be put and
            % populate matrices
            val=((i - 1) * 11) + j + 132;
            
            dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.r.10.dist_mm.txt',dir,transformationModel1,costFunction1,subjects{j},templates{i}),' ');
            dist_mat_comb1(:,val)=dist(min:max,2);
            
            dist=importdata(sprintf('%s/eucDistDir/%s_%s_r/%s_to_%s.r.10.dist_mm.txt',dir,transformationModel2,costFunction2,subjects{j},templates{i}),' ');
            dist_mat_comb2(:,val)=dist(min:max,2);
            
        end
        
    end
    
    vec_comb1=reshape(dist_mat_comb1,[bin*264, 1]);
    vec_comb2=reshape(dist_mat_comb2,[bin*264, 1]);  
    
    % perform paired t-tests and store results in matrices
    [~,p]=ttest(vec_comb1,vec_comb2);
    assignin('base','p',p);
    
    fprintf('Bin %i p-val: %4d\n',AP_bin,p);

elseif (strcmp(costFunction2,'t1') || strcmp(costFunction2,'t2')) && (strcmp(costFunction1,'GM') || strcmp(costFunction1,'GM_DB'))
%% if comparing t1/t2 to GM/GM_DB or vice versa
        
    % initialize matrix to hold distances
    dist_mat_comb1=zeros(bin,264);
    dist_mat_comb2=zeros(bin,264);
    
    % iterate through templates to read in every left side distance file
    for i=1:length(templates)

        % initialize subject list for every template
        subjects=templates;

        % remove template from subject list
        for j=1:length(subjects)
            if templates{i}==subjects{j}
                subjects(j,:)=[];
                break;
            end
        end

        % iterate through subjects to populate distance matrix
        for j=1:length(subjects)
            
            % set matrix index where imported array will be put and
            % populate matrices
            val=((i - 1) * 11) + j;
            
            dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',dir,transformationModel1,costFunction1,subjects{j},templates{i}),' ');
            dist_mat_comb1(:,val)=dist(min:max,2);
            
            dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',dir,transformationModel2,costFunction2,subjects{j},templates{i}),' ');
            dist_mat_comb2(:,val)=dist(min:max,2);
            
        end
        
    end
    
    % iterate through templates to read in every right side distance file
    for i=1:length(templates)

        % initialize subject list for every template
        subjects=templates;

        % remove template from subject list
        for j=1:length(subjects)
            if templates{i}==subjects{j}
                subjects(j,:)=[];
                break;
            end
        end

        % iterate through subjects to populate distance matrix
        for j=1:length(subjects)
            
            % set matrix index where imported array will be put and
            % populate matrices
            val=((i - 1) * 11) + j + 132;
            
            dist=importdata(sprintf('%s/eucDistDir/%s_%s_r/%s_to_%s.r.10.dist_mm.txt',dir,transformationModel1,costFunction1,subjects{j},templates{i}),' ');
            dist_mat_comb1(:,val)=dist(min:max,2);
            
            dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.r.10.dist_mm.txt',dir,transformationModel2,costFunction2,subjects{j},templates{i}),' ');
            dist_mat_comb2(:,val)=dist(min:max,2);
            
        end
        
    end
    
    vec_comb1=reshape(dist_mat_comb1,[bin*264, 1]);
    vec_comb2=reshape(dist_mat_comb2,[bin*264, 1]);  
    
    % perform paired t-tests and store results in matrices
    [~,p]=ttest(vec_comb1,vec_comb2);
    assignin('base','p',p);
    
    fprintf('Bin %i p-val: %4d\n',AP_bin,p);
    
end

end

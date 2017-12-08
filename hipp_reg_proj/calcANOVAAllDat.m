% performs anova across all non-collapsed data values using the factors of
% transformation model, cost function, and hemisphere

function calcANOVAAllDat(subjlist,transformationModels,costFunctions)

dir=('~/khangrp/projects/unsorted/averageDeepBrain7T/7THippAtlas/');

templates=importdata(subjlist);
model=importdata(transformationModels);
cost=importdata(costFunctions);

data_vec=[];
hemi_vec={};
model_vec={};
cost_vec={};

for i=1:length(model)
    for j=1:length(cost)
        
        % iterate through templates to read in every distance file
        for k=1:length(templates)
        
            % initialize subject list for every template
            subjects=templates;
            
            % remove template from subject list
            for z=1:length(subjects)
                if templates{k}==subjects{z}
                    subjects(z,:)=[];
                    break;
                end
            end
            
            % iterate through subjects to populate distance matrix
            for z=1:length(subjects)
                
                if strcmp(cost{j},'t1') || strcmp(cost{j},'t2')
                
                    % import data
                    dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},templates{k}),' ');
                    data_vec=[data_vec;dist(:,2)];
                    
                    len=size(cost_vec,1);
                    cost_vec((len+1):(len+94),1)={cost{j}};
                    hemi_vec((len+1):(len+94),1)={'L'};
                    model_vec((len+1):(len+94),1)={model{i}};
                    

                    dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.r.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},templates{k}),' ');
                    data_vec=[data_vec;dist(:,2)];
                    
                    len=size(cost_vec,1);
                    cost_vec((len+1):(len+94),1)={cost{j}};
                    hemi_vec((len+1):(len+94),1)={'R'};
                    model_vec((len+1):(len+94),1)={model{i}};
                
                elseif strcmp(cost{j},'GM')
                    
                    dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},templates{k}),' ');
                    data_vec=[data_vec;dist(:,2)];
                                        
                    len=size(cost_vec,1);
                    cost_vec((len+1):(len+94),1)={'GM'};
                    hemi_vec((len+1):(len+94),1)={'L'};
                    model_vec((len+1):(len+94),1)={model{i}};
                    
                elseif strcmp(cost{j},'GM_DB')
                    
                    dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},templates{k}),' ');
                    data_vec=[data_vec;dist(:,2)];
                    
                    len=size(cost_vec,1);
                    cost_vec((len+1):(len+94),1)={'GM_DB'};
                    hemi_vec((len+1):(len+94),1)={'L'};
                    model_vec((len+1):(len+94),1)={model{i}};
                    
                elseif strcmp(cost{j},'GM_r')
                    
                    dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.r.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},templates{k}),' ');
                    data_vec=[data_vec;dist(:,2)];
                    
                    len=size(cost_vec,1);
                    cost_vec((len+1):(len+94),1)={'GM'};
                    hemi_vec((len+1):(len+94),1)={'R'};
                    model_vec((len+1):(len+94),1)={model{i}};
                    
                elseif strcmp(cost{j},'GM_DB_r')
                    
                    dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.r.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},templates{k}),' ');
                    data_vec=[data_vec;dist(:,2)];
                    
                    len=size(cost_vec,1);
                    cost_vec((len+1):(len+94),1)={'GM_DB'};
                    hemi_vec((len+1):(len+94),1)={'R'};
                    model_vec((len+1):(len+94),1)={model{i}};
                    
                end
               
            end
        
        end
        
    end
    
end

%group={hemi_vec,model_vec,cost_vec};

%[anova_p,anova_t,anova_stats,anova_terms]=anovan(data_vec,group,'varnames',{'Hemisphere';'Model';'Cost'},'model','full');



end


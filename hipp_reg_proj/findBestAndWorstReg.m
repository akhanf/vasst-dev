% performs a repeated measures ANOVA using all data

function findBestAndWorstReg(subjList,models,costs)

dir=('~/khangrp/projects/unsorted/averageDeepBrain7T/7THippAtlas/');

templates=importdata(subjList);
model=importdata(models);
cost=importdata(costs);


% vecL=zeros(94,1056);      
vecL=zeros(94,96
% vecR=zeros(94,1056);
valL=1;
% valR=1;

for i=1:length(model)
    for j=1:length(cost)

         if strcmp(cost{j},'GM') || strcmp(cost{j},'GM_DB')

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

                    % import data
                    dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},templates{k}),' ');
                    vecL(:,valL)=dist(:,2);

                    valL=valL + 1;

                end

            end
            
        elseif strcmp(cost{j},'GM_r') || strcmp(cost{j},'GM_DB_r')

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

                    % import data            
                    dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.r.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},templates{k}),' ');
                    vecR(:,valR)=dist(:,2);

                    valR=valR + 1;

                end

            end
        
         elseif strcmp(cost{j},'t1') || strcmp(cost{j},'t2')

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

                    % import data
                    dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},templates{k}),' ');
                    vecL(:,valL)=dist(:,2);

                    dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.r.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},templates{k}),' ');
                    vecR(:,valR)=dist(:,2);

                    valL=valL + 1;
                    valR=valR + 1;
                    
                end

            end  

        end
    end
end

avgL=mean(vecL,1);
avgR=mean(vecR,1);

medianL=median(avgL);
uppPercL=prctile(avgL,90);
lowPercL=prctile(avgL,10);

medianR=median(avgR);
uppPercR=prctile(avgR,90);
lowPercR=prctile(avgR,10);

% medianLind=find(avgL==medianL);
% uppPercLind=find(avgL==uppPercL);
% lowPercLind=find(avgL==lowPercL);
% 
% medianRind=find(avgR==medianR);
% uppPercRind=find(avgR==uppPercR);
% lowPercRind=find(avgR==lowPercR);
% 
% fprintf('Max L: %3d Index: %i\n',medianL, medianLind)
% fprintf('Min L: %3d Index: %i\n',uppPercL, uppPercLind)
% fprintf('Max R: %3d Index: %i\n',medianR, medianRind)
% fprintf('Min R: %3d Index: %i\n',uppPercR, uppPercRind)

               
        
end
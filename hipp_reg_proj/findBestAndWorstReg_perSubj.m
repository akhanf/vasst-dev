% performs a repeated measures ANOVA using all data

function findBestAndWorstReg_perSubj(subjList,models,costs)

dir=('~/khangrp/projects/unsorted/averageDeepBrain7T/7THippAtlas/');

subjects=importdata(subjList);
model=importdata(models);
cost=importdata(costs);
template='V073';


vecL=zeros(94,88);      
vecR=zeros(94,88);
valL=1;
valR=1;

for i=1:length(model)
    for j=1:length(cost)

         if strcmp(cost{j},'GM') || strcmp(cost{j},'GM_DB')

            % remove template from subject list
            for z=1:length(subjects)
                if template==subjects{z}
                    subjects(z,:)=[];
                    break;
                end
            end

            % iterate through subjects to populate distance matrix
            for z=1:length(subjects)

                % import data
                dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},template),' ');
                vecL(:,valL)=dist(:,2);

                valL=valL + 1;

            end
  
        elseif strcmp(cost{j},'GM_r') || strcmp(cost{j},'GM_DB_r')

            % remove template from subject list
            for z=1:length(subjects)
                if template==subjects{z}
                    subjects(z,:)=[];
                    break;
                end
            end

            % iterate through subjects to populate distance matrix
            for z=1:length(subjects)

                % import data            
                dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.r.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},template),' ');
                vecR(:,valR)=dist(:,2);

                valR=valR + 1;

            end
       
         elseif strcmp(cost{j},'t1') || strcmp(cost{j},'t2')


            % remove template from subject list
            for z=1:length(subjects)
                if template==subjects{z}
                    subjects(z,:)=[];
                    break;
                end
            end

            % iterate through subjects to populate distance matrix
            for z=1:length(subjects)

                % import data
                dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},template),' ');
                vecL(:,valL)=dist(:,2);

                dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.r.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},template),' ');
                vecR(:,valR)=dist(:,2);

                valL=valL + 1;
                valR=valR + 1;

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

[~,medianLind]=min(abs(avgL-medianL));
[~,uppPercLind]=min(abs(avgL-uppPercL));
[~,lowPercLind]=min(abs(avgL-lowPercL));

[~,medianRind]=min(abs(avgR-medianR));
[~,uppPercRind]=min(abs(avgR-uppPercR));
[~,lowPercRind]=min(abs(avgR-lowPercR));

fprintf('Median L: %3d Index: %i\n',medianL, medianLind)
fprintf('90 Perc L: %3d Index: %i\n',uppPercL, uppPercLind)
fprintf('10 Perc L: %3d Index: %i\n',lowPercL, lowPercLind)

fprintf('Median R: %3d Index: %i\n',medianR, medianRind)
fprintf('90 Perc R: %3d Index: %i\n',uppPercR, uppPercRind)
fprintf('10 Perc R: %3d Index: %i\n',lowPercL, lowPercRind)
               
        
end
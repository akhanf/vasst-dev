% performs a repeated measures ANOVA using all data

function calcRMANOVAAllDat_withBins(subjList,transformationModels,costFunctions)

dir=('~/khangrp/projects/unsorted/averageDeepBrain7T/7THippAtlas/');

templates=importdata(subjList);
model=importdata(transformationModels);
cost=importdata(costFunctions);

data_vec=[];
hemi_vec={};
model_vec={};
cost_vec={};

bins(1:9,1)=1;
bins(10:19,1)=2;
bins(20:29,1)=3;
bins(30:39,1)=4;
bins(40:49,1)=5;
bins(50:59,1)=6;
bins(60:69,1)=7;
bins(70:79,1)=8;
bins(80:89,1)=9;
bins(90:94,1)=10;

bin_vec=repmat(bins,176,1);

for i=1:length(model)
    
    for j=1:length(cost)
        
        temp_vec=[];
        
        if strcmp(cost{j},'t1') || strcmp(cost{j},'t2')
            
            len=size(cost_vec,1);
            cost_vec((len+1):(len+1034),1)={cost{j}};
            hemi_vec((len+1):(len+1034),1)={'L'};
            model_vec((len+1):(len+1034),1)={model{i}};
            
            len=size(cost_vec,1);
            cost_vec((len+1):(len+1034),1)={cost{j}};
            hemi_vec((len+1):(len+1034),1)={'R'};
            model_vec((len+1):(len+1034),1)={model{i}};
        
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
                    
                    val=((z-1)*94)+1;
                    
                    % import data
                    dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},templates{k}),' ');
                    temp_vec(val:val+93,k)=dist(:,2);
                    
                end
                
            end
            
            data_vec=[data_vec;temp_vec];
            
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
                
                for z=1:length(subjects)
                    
                    val=((z-1)*94)+1;
                    
                    dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.r.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},templates{k}),' ');
                    temp_vec(val:val+93,k)=dist(:,2);
                    
                end
                
            end
            
            data_vec=[data_vec;temp_vec];

                
        elseif strcmp(cost{j},'GM')
                    
            len=size(cost_vec,1);
            cost_vec((len+1):(len+1034),1)={'GM'};
            hemi_vec((len+1):(len+1034),1)={'L'};
            model_vec((len+1):(len+1034),1)={model{i}};
            
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
                                
                    val=((z-1)*94)+1;
                    
                    % import data
                    dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},templates{k}),' ');
                    temp_vec(val:val+93,k)=dist(:,2);
                    
                end
                
            end
            
            data_vec=[data_vec;temp_vec];
                                                                           
        elseif strcmp(cost{j},'GM_DB')
                    
            len=size(cost_vec,1);
            cost_vec((len+1):(len+1034),1)={'GM_DB'};
            hemi_vec((len+1):(len+1034),1)={'L'};
            model_vec((len+1):(len+1034),1)={model{i}};
            
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
                            
                    val=((z-1)*94)+1;
                    
                    % import data
                    dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},templates{k}),' ');
                    temp_vec(val:val+93,k)=dist(:,2);
                    
                end
                
            end
            
            data_vec=[data_vec;temp_vec];
                                
        elseif strcmp(cost{j},'GM_r')
            
            len=size(cost_vec,1);
            cost_vec((len+1):(len+1034),1)={'GM'};
            hemi_vec((len+1):(len+1034),1)={'R'};
            model_vec((len+1):(len+1034),1)={model{i}};
                    
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
                                
                    val=((z-1)*94)+1;
                    
                    % import data
                    dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.r.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},templates{k}),' ');
                    temp_vec(val:val+93,k)=dist(:,2);
                    
                end
                
            end
            
            data_vec=[data_vec;temp_vec];
                                                            
        elseif strcmp(cost{j},'GM_DB_r')
        
            len=size(cost_vec,1);
            cost_vec((len+1):(len+1034),1)={'GM_DB'};
            hemi_vec((len+1):(len+1034),1)={'R'};
            model_vec((len+1):(len+1034),1)={model{i}};
            
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
                                
                    val=((z-1)*94)+1;
                    
                    % import data
                    dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.r.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},templates{k}),' ');
                    temp_vec(val:val+93,k)=dist(:,2);
                    
                end
                
            end
            
            data_vec=[data_vec;temp_vec];
                                           
        end
               
    end
            

end
    
t=table(hemi_vec,model_vec,cost_vec,bin_vec,data_vec(:,1),data_vec(:,2),data_vec(:,3),data_vec(:,4),data_vec(:,5),data_vec(:,6),data_vec(:,7),data_vec(:,8),data_vec(:,9),data_vec(:,10),data_vec(:,11),data_vec(:,12),'VariableNames',{'Hemisphere','Model','Cost','APBin','V025','V069','V070','V071','V072','V073','V074','V075','V076','V077','V078','V079'});
rm=fitrm(t,'V025-V079~ Hemisphere + Model + Cost + APBin + Hemisphere*Model + Hemisphere*Cost + Model*Cost + Hemisphere*APBin + Cost*APBin + Model*APBin + Hemisphere*Model*Cost + Hemisphere*Model*APBin + Model*Cost*APBin + Hemisphere*Model*Cost*APBin');
ranovatbl=ranova(rm)

assignin('base', 'ranova_t', t);
assignin('base', 'ranovatbl', ranovatbl);
        
end
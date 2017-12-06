% performs a repeated measures ANOVA using data collapsed into 10 AP bins
% (i.e. collapsed in the PD dimension)

function calcRMANOVA_APBin(subjList,transformationModels,costFunctions,AP_bin)
% performs a repeated measures ANOVA using all data

dir=('~/khangrp/projects/unsorted/averageDeepBrain7T/7THippAtlas/');

templates=importdata(subjList);
model=importdata(transformationModels);
cost=importdata(costFunctions);

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


data_vec=[];
hemi_vec={};
model_vec={};
cost_vec={};

for i=1:length(model)
    
    for j=1:length(cost)
        
        temp_vec=[];
        
        if strcmp(cost{j},'t1') || strcmp(cost{j},'t2')
            
            len=size(cost_vec,1);
            val=bin*11;
            cost_vec((len+1):(len+val),1)={cost{j}};
            hemi_vec((len+1):(len+val),1)={'L'};
            model_vec((len+1):(len+val),1)={model{i}};
            
            len=size(cost_vec,1);
            val=bin*11;
            cost_vec((len+1):(len+val),1)={cost{j}};
            hemi_vec((len+1):(len+val),1)={'R'};
            model_vec((len+1):(len+val),1)={model{i}};
        
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
                    
                    val=((z-1)*bin)+1;
                    
                    % import data
                    dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},templates{k}),' ');
                    temp_vec(val:val+(bin-1),k)=dist(min:max,2);
                    
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

                % iterate through subjects to populate distance matrix
                for z=1:length(subjects)
                    
                    val=((z-1)*bin)+1;
                    
                    dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.r.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},templates{k}),' ');
                    temp_vec(val:val+(bin-1),k)=dist(min:max,2);
                    
                end
                
            end
            
            data_vec=[data_vec;temp_vec];

                
        elseif strcmp(cost{j},'GM')
                    
            len=size(cost_vec,1);
            val=bin*11;
            cost_vec((len+1):(len+val),1)={'GM'};
            hemi_vec((len+1):(len+val),1)={'L'};
            model_vec((len+1):(len+val),1)={model{i}};
            
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
                                
                    val=((z-1)*bin)+1;
                    
                    % import data
                    dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},templates{k}),' ');
                    temp_vec(val:val+(bin-1),k)=dist(min:max,2);
                    
                end
                
            end
            
            data_vec=[data_vec;temp_vec];
                                                                           
        elseif strcmp(cost{j},'GM_DB')
                    
            len=size(cost_vec,1);
            val=bin*11;
            cost_vec((len+1):(len+val),1)={'GM_DB'};
            hemi_vec((len+1):(len+val),1)={'L'};
            model_vec((len+1):(len+val),1)={model{i}};
            
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
                            
                    val=((z-1)*bin)+1;
                    
                    % import data
                    dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.l.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},templates{k}),' ');
                    temp_vec(val:val+(bin-1),k)=dist(min:max,2);
                    
                end
                
            end
            
            data_vec=[data_vec;temp_vec];
                                
        elseif strcmp(cost{j},'GM_r')
            
            len=size(cost_vec,1);
            val=bin*11;
            cost_vec((len+1):(len+val),1)={'GM'};
            hemi_vec((len+1):(len+val),1)={'R'};
            model_vec((len+1):(len+val),1)={model{i}};
                    
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
                                
                    val=((z-1)*bin)+1;
                    
                    % import data
                    dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.r.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},templates{k}),' ');
                    temp_vec(val:val+(bin-1),k)=dist(min:max,2);
                    
                end
                
            end
            
            data_vec=[data_vec;temp_vec];
                                                            
        elseif strcmp(cost{j},'GM_DB_r')
        
            len=size(cost_vec,1);
            val=bin*11;
            cost_vec((len+1):(len+val),1)={'GM_DB'};
            hemi_vec((len+1):(len+val),1)={'R'};
            model_vec((len+1):(len+val),1)={model{i}};
            
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
                                
                    val=((z-1)*bin)+1;
                    
                    % import data
                    dist=importdata(sprintf('%s/eucDistDir/%s_%s/%s_to_%s.r.10.dist_mm.txt',dir,model{i},cost{j},subjects{z},templates{k}),' ');
                    temp_vec(val:val+(bin-1),k)=dist(min:max,2);
                    
                end
                
            end
            
            data_vec=[data_vec;temp_vec];
                                           
        end
               
    end
            

end
    
t=table(hemi_vec,model_vec,cost_vec,data_vec(:,1),data_vec(:,2),data_vec(:,3),data_vec(:,4),data_vec(:,5),data_vec(:,6),data_vec(:,7),data_vec(:,8),data_vec(:,9),data_vec(:,10),data_vec(:,11),data_vec(:,12),'VariableNames',{'Hemisphere','Model','Cost','V025','V069','V070','V071','V072','V073','V074','V075','V076','V077','V078','V079'});
rm=fitrm(t,'V025-V079~ Hemisphere + Model + Cost + Hemisphere*Model + Hemisphere*Cost + Model*Cost + Hemisphere*Model*Cost');
ranovatbl=ranova(rm)

num=num2str(AP_bin);

writetable(t,sprintf('statsDir/rm_anova/AP%s/allData.RMtable.txt',num),'Delimiter',' ','WriteRowNames',true);
writetable(ranovatbl,sprintf('statsDir/rm_anova/AP%s/allData.RManovaTable.xlsx',num),'WriteRowNames',true);

tbl=multcompare(rm,'Hemisphere');
writetable(tbl,sprintf('statsdir/rm_anova/AP%s/allData.RM_multcompare_hemi.xlsx',num),'WriteRowNames',true);

tbl=multcompare(rm,'Model');
writetable(tbl,sprintf('statsdir/rm_anova/AP%s/allData.RM_multcompare_model.xlsx',num),'WriteRowNames',true);
        
tbl=multcompare(rm,'Cost');
writetable(tbl,sprintf('statsdir/rm_anova/AP%s/allData.RM_multcompare_cost.xlsx',num),'WriteRowNames',true);

tbl=multcompare(rm,'Hemisphere','By','Cost');
writetable(tbl,sprintf('statsdir/rm_anova/AP%s/allData.RM_multcompare_hemi_by_cost.xlsx',num),'WriteRowNames',true);

tbl=multcompare(rm,'Hemisphere','By','Model');
writetable(tbl,sprintf('statsdir/rm_anova/AP%s/allData.RM_multcompare_hemi_by_model.xlsx',num),'WriteRowNames',true);

tbl=multcompare(rm,'Model','By','Cost');
writetable(tbl,sprintf('statsdir/rm_anova/AP%s/allData.RM_multcompare_model_by_cost.xlsx',num),'WriteRowNames',true);

tbl=multcompare(rm,'Model','By','Hemisphere');
writetable(tbl,sprintf('statsdir/rm_anova/AP%s/allData.RM_multcompare_model_by_hemi.xlsx',num),'WriteRowNames',true);

tbl=multcompare(rm,'Cost','By','Model');
writetable(tbl,sprintf('statsdir/rm_anova/AP%s/allData.RM_multcompare_cost_by_model.xlsx',num),'WriteRowNames',true);

tbl=multcompare(rm,'Cost','By','Hemisphere');
writetable(tbl,sprintf('statsdir/rm_anova/AP%s/allData.RM_multcompare_cost_by_hemi.xlsx',num),'WriteRowNames',true);

end
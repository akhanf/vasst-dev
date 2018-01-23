function findNaNValues(templateList,subjList,cost,model)

% import subject list
templates=importdata(templateList);
costFunction=importdata(cost);
transformationModel=importdata(model);

nanMat=zeros(400,2);
nanMat(:,1)=1:400;
nanMat(:,2)=1;

for z=1:length(templates)
    
    subjects=importdata(subjList);

    % remove template from subject list
    for i=1:length(subjects)
        if templates{z}==subjects{i}
            subjects(i,:)=[];
            break;
        end
    end

    % iterate through all combinations of transformation model, cost
    % function, and moving subject for a given template
    for i=1:length(transformationModel)
        for j=1:length(costFunction)
            for k=1:length(subjects)

                % run if cost function is t1 or t2, runs script for both
                % left and right sides
                if strcmp(costFunction{j}, "t1") || strcmp(costFunction{j}, "t2")
                    
                    % set in file path and import it into matrix
                    inFile=sprintf('eucDistDir/%s_%s/%s_to_%s.l.dist_mm.txt',transformationModel{i},costFunction{j},subjects{k},templates{z});
                    inMat=importdata(inFile);
                    
                    % iterate through indices and if a value in the
                    % centroid difference file is nan, set that index in
                    % the NaN matrix to 0
                    for l=1:400
                        if isnan(inMat(l,2))
                            nanMat(l,2)=0;
                        end
                    end
                    
                    % do same for left side
                    inFile=sprintf('eucDistDir/%s_%s/%s_to_%s.r.dist_mm.txt',transformationModel{i},costFunction{j},subjects{k},templates{z});
                    inMat=importdata(inFile);
                    
                    for l=1:400
                        if isnan(inMat(l,2))
                            nanMat(l,2)=0;
                        end
                    end
                    
                % run if cost function is GM or GM_DB, runs script for left
                % side only
                elseif strcmp(costFunction{j}, "GM") || strcmp(costFunction{j}, "GM_DB")
                    inFile=sprintf('eucDistDir/%s_%s/%s_to_%s.l.dist_mm.txt',transformationModel{i},costFunction{j},subjects{k},templates{z});
                    inMat=importdata(inFile);
                    
                    for l=1:400
                        if isnan(inMat(j,2))
                            nanMat(j,2)=0;
                        end
                    end
                    
                % run if cost function is GM_r or GM_DB_r, runs script for
                % right side only
                elseif strcmp(costFunction{j}, "GM_r") || strcmp(costFunction{j}, "GM_DB_r")
                    inFile=sprintf('eucDistDir/%s_%s/%s_to_%s.r.dist_mm.txt',transformationModel{i},costFunction{j},subjects{k},templates{z});
                    inMat=importdata(inFile);
                    
                    for l=1:400
                        if isnan(inMat(j,2))
                            nanMat(j,2)=0;
                        end
                    end
                    
                end

            end
        end
    end
    
end

% print out NaN matrix
dlmwrite('eucDistDir/nanIndices.txt',nanMat,' ');

end
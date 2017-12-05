% generates centroids and compares their locations between a template
% subject and each subject in a subject list

function compareCentroid(template,subjList,costFunction,transformationModel)

% import subject list
subjects=importdata(subjList);

% remove template from subject list
for i=1:length(subjects)
    if template==subjects{i}
        subjects(i,:)=[];
        break;
    end
end

%% run if cost function is t1 or t2, runs comparison for both left and right sides
if strcmp(costFunction, "t1") || strcmp(costFunction, "t2")
    for i=1:length(subjects)
        
        % set file paths
        template_in_L=sprintf('%s/labels/t2/checkerboard/checkerboard.l.20.reorient.06mm.affineAtlasSpace.crop.nii.gz',template);
        template_in_R=sprintf('%s/labels/t2/checkerboard/checkerboard.r.20.reorient.06mm.affineAtlasSpace.crop.nii.gz',template);

        trans_in_L=sprintf('%s/labels/t2/checkerboard_%s_%s/checkerboard.l.20.reorient.06mm.affineAtlasSpace.crop.%s.nii.gz',template,transformationModel,costFunction,subjects{i});
        trans_in_R=sprintf('%s/labels/t2/checkerboard_%s_%s/checkerboard.r.20.reorient.06mm.affineAtlasSpace.crop.%s.nii.gz',template,transformationModel,costFunction,subjects{i});

        % load in niftis of template and transformed left and right
        % checkerboard maps
        temp_L_nii=load_nifti(template_in_L);
        temp_R_nii=load_nifti(template_in_R);

        trans_L_nii=load_nifti(trans_in_L);
        trans_R_nii=load_nifti(trans_in_R);

        % extract volume information from imported niftis and store in
        % matrices
        temp_L_vol=temp_L_nii.vol;
        temp_R_vol=temp_R_nii.vol;

        trans_L_vol=trans_L_nii.vol;
        trans_R_vol=trans_R_nii.vol;

        % initialize arrays that will hold the Euclidean distance between
        % centroids
        euclideanDistLeft=zeros(400,2);
        euclideanDistRight=zeros(400,2);

        % iterate through each label
        for j=1:400

            % initialize array that will hold centroids 
            temp_centroid=zeros(1,3);
            trans_centroid=zeros(1,3);
            
            % find non-zero indices, convert them to subscripts and store the
            % averaged subscript in the centroid array
            ind=find(temp_L_vol(:)==j);
            [tempL_ind1,tempL_ind2,tempL_ind3]=ind2sub(size(temp_L_vol),ind);
            temp_centroid(1,1)=mean(tempL_ind1);
            temp_centroid(1,2)=mean(tempL_ind2);
            temp_centroid(1,3)=mean(tempL_ind3);

            ind=find(trans_L_vol(:)==j);
            [transL_ind1,transL_ind2,transL_ind3]=ind2sub(size(trans_L_vol),ind);
            trans_centroid(1,1)=mean(transL_ind1);
            trans_centroid(1,2)=mean(transL_ind2);
            trans_centroid(1,3)=mean(transL_ind3);

            % calculate Euclidean distances between centroids and store in
            % Euclidean distance array
            euclideanDistLeft(j,1)=j;
            euclideanDistLeft(j,2)=pdist2(trans_centroid,temp_centroid);

            % repeat all steps for right side
            ind=find(temp_R_vol(:)==j);
            [tempR_ind1,tempR_ind2,tempR_ind3]=ind2sub(size(temp_R_vol),ind);
            temp_centroid(1,1)=mean(tempR_ind1);
            temp_centroid(1,2)=mean(tempR_ind2);
            temp_centroid(1,3)=mean(tempR_ind3);

            ind=find(trans_R_vol(:)==j);
            [transR_ind1,transR_ind2,transR_ind3]=ind2sub(size(trans_R_vol),ind);
            trans_centroid(1,1)=mean(transR_ind1);
            trans_centroid(1,2)=mean(transR_ind2);
            trans_centroid(1,3)=mean(transR_ind3);

            euclideanDistRight(j,1)=j;
            euclideanDistRight(j,2)=pdist2(trans_centroid,temp_centroid);

        end
        
        mmDistLeft(:,1)=euclideanDistLeft(:,1);
        mmDistLeft(:,2)=euclideanDistLeft(:,2) .* 0.6;
        mmDistRight(:,1)=euclideanDistRight(:,1);
        mmDistRight(:,2)=euclideanDistRight(:,2) .* 0.6;
        
        dlmwrite(sprintf('eucDistDir/%s_%s/%s_to_%s.l.dist_mm.txt',transformationModel,costFunction,subjects{i},template),mmDistLeft,' ');
        dlmwrite(sprintf('eucDistDir/%s_%s/%s_to_%s.r.dist_mm.txt',transformationModel,costFunction,subjects{i},template),mmDistRight,' '); 
        
    end

%% run if cost function is GM or GM_DB, runs comparison for left side only
elseif strcmp(costFunction, "GM") || strcmp(costFunction, "GM_DB")
    for i=1:length(subjects)
        
        % set file paths/names
        template_in_L=sprintf('%s/labels/t2/checkerboard/checkerboard.l.20.reorient.06mm.affineAtlasSpace.crop.nii.gz',template);

        trans_in_L=sprintf('%s/labels/t2/checkerboard_%s_%s/checkerboard.l.20.reorient.06mm.affineAtlasSpace.crop.%s.nii.gz',template,transformationModel,costFunction,subjects{i});

        % load in niftis of template and transformed left and right
        % checkerboard maps
        temp_L_nii=load_nifti(template_in_L);

        trans_L_nii=load_nifti(trans_in_L);

        % extract volume information from imported niftis and store in
        % matrices
        temp_L_vol=temp_L_nii.vol;

        trans_L_vol=trans_L_nii.vol;

        % initialize arrays that will hold the Euclidean distance between
        % centroids
        euclideanDistLeft=zeros(400,2);

        % iterate through each label
        for j=1:400

            % initialize array that will hold centroids 
            temp_centroid=zeros(1,3);
            trans_centroid=zeros(1,3);

            % find non-zero indices, convert them to subscripts and store the
            % averaged subscript in the centroid array
            ind=find(temp_L_vol(:)==j);
            [tempL_ind1,tempL_ind2,tempL_ind3]=ind2sub(size(temp_L_vol),ind);
            temp_centroid(1,1)=mean(tempL_ind1);
            temp_centroid(1,2)=mean(tempL_ind2);
            temp_centroid(1,3)=mean(tempL_ind3);

            ind=find(trans_L_vol(:)==j);
            [transL_ind1,transL_ind2,transL_ind3]=ind2sub(size(trans_L_vol),ind);
            trans_centroid(1,1)=mean(transL_ind1);
            trans_centroid(1,2)=mean(transL_ind2);
            trans_centroid(1,3)=mean(transL_ind3);

            % calculate Euclidean distances between centroids and store in
            % Euclidean distance array
            euclideanDistLeft(j,1)=j;
            euclideanDistLeft(j,2)=pdist2(trans_centroid,temp_centroid);

        end
        
        mmDistLeft(:,1)=euclideanDistLeft(:,1);
        mmDistLeft(:,2)=euclideanDistLeft(:,2) .* 0.6;
        
        dlmwrite(sprintf('eucDistDir/%s_%s/%s_to_%s.l.dist_mm.txt',transformationModel,costFunction,subjects{i},template),mmDistLeft,' ');
        
    end

 %% run if cost function is GM_r or GM_DB_r, run comparison for right side only
elseif strcmp(costFunction, "GM_r") || strcmp(costFunction, "GM_DB_r")
    for i=1:length(subjects)
        
        % set file paths
        template_in_R=sprintf('%s/labels/t2/checkerboard/checkerboard.r.20.reorient.06mm.affineAtlasSpace.crop.nii.gz',template);

        trans_in_R=sprintf('%s/labels/t2/checkerboard_%s_%s/checkerboard.r.20.reorient.06mm.affineAtlasSpace.crop.%s.nii.gz',template,transformationModel,costFunction,subjects{i});

        % load in niftis of template and transformed left and right
        % checkerboard maps
        temp_R_nii=load_nifti(template_in_R);

        trans_R_nii=load_nifti(trans_in_R);

        % extract volume information from imported niftis and store in
        % matrices
        temp_R_vol=temp_R_nii.vol;

        trans_R_vol=trans_R_nii.vol;

        % initialize arrays that will hold the Euclidean distance between
        % centroids
        euclideanDistRight=zeros(400,2);

        % iterate through each label
        for j=1:400

            % initialize array that will hold centroids 
            temp_centroid=zeros(1,3);
            trans_centroid=zeros(1,3);

            % find non-zero indices, convert them to subscripts and store the
            % averaged subscript in the centroid array
            ind=find(temp_R_vol(:)==j);
            [tempR_ind1,tempR_ind2,tempR_ind3]=ind2sub(size(temp_R_vol),ind);
            temp_centroid(1,1)=mean(tempR_ind1);
            temp_centroid(1,2)=mean(tempR_ind2);
            temp_centroid(1,3)=mean(tempR_ind3);

            ind=find(trans_R_vol(:)==j);
            [transR_ind1,transR_ind2,transR_ind3]=ind2sub(size(trans_R_vol),ind);
            trans_centroid(1,1)=mean(transR_ind1);
            trans_centroid(1,2)=mean(transR_ind2);
            trans_centroid(1,3)=mean(transR_ind3);

            % calculate Euclidean distances between centroids and store in
            % Euclidean distance array
            euclideanDistRight(j,1)=j;
            euclideanDistRight(j,2)=pdist2(trans_centroid,temp_centroid);            

        end
        
        mmDistRight(:,1)=euclideanDistRight(:,1);
        mmDistRight(:,2)=euclideanDistRight(:,2) .* 0.6;
        
        dlmwrite(sprintf('eucDistDir/%s_%s/%s_to_%s.r.dist_mm.txt',transformationModel,costFunction,subjects{i},template),mmDistRight,' ');
        
    end
    
%%
 
end

end


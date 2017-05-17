% to get rid of some of warnings from non-existent extensions
%restoredefaultpath;
%savepath;

%------------ FreeSurfer -----------------------------%
fshome = getenv('FREESURFER_HOME');
fsmatlab = sprintf('%s/matlab',fshome);
if (exist(fsmatlab) == 7)
    path(path,fsmatlab);
end
clear fshome fsmatlab;
%-----------------------------------------------------%

%------------ FreeSurfer FAST ------------------------%
fsfasthome = getenv('FSFAST_HOME');
fsfasttoolbox = sprintf('%s/toolbox',fsfasthome);
if (exist(fsfasttoolbox) == 7)
    path(path,fsfasttoolbox);
end
clear fsfasthome fsfasttoolbox;
%-----------------------------------------------------%

mialtools=getenv('MIAL_TOOLS_MATLAB');
if (exist(mialtools)==7)
	addpath(genpath(mialtools));
end

cain2=getenv('CAIN2_MATLAB');
if (exist(cain2)==7)
	addpath(genpath(cain2));
end

pipeline=getenv('PIPELINE_MATLAB');
if (exist(pipeline)==7)
	addpath(genpath(pipeline));
end


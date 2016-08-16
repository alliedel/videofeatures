function AddToolPaths(parsScript)
%% Add OpenCV Library Path and VLfeat and MATLAB gentools
assert(exist(parsScript.dtPath,'dir')~=0, sprintf('parsScript.dtPath does not exist: %s', parsScript.dtPath));
%parsScript.liblinear
%addpath(parsScript.liblinear); % I don't know why MATLAB hates this line, but I'm taking it out...
%assert(exist('train','file')~=0,'''train'' is not an available function at the moment.  Please check the path: %s\n',parsScript.liblinear);
%addpath(genpath(fullfile(parsScript.anomDetectRoot,'code')));
%run(parsScript.vlfeatPath) % I don't know why MATLAB hates this line, but I'm taking it out...
system(sprintf('export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:%s',parsScript.LD_LIBRARY_PATH),'-echo');
% system('echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"');

% assert(exist(parsScript.glmnetPath,'dir')~=0,'parsScript.glmnetPath does not exist: %s',parsScript.glmnetPath);
% addpath(parsScript.glmnetPath);
% addpath(genpath('../../../global/my_tools_matlab'));

end

function CreateFinalFeatMATFile_liu(params)

params.BKH = floor(params.H/params.patchWin);      % region number in height                                       
params.BKW = floor(params.W/params.patchWin);      % region number in width                                        
fname_testfeats = params.fname_testfeats;
fname_testfeatsPCA = params.fname_testfeatsPCA;
fname_trainfeats = params.fname_trainfeats;
fname_trainfeatsPCA = params.fname_trainfeatsPCA;
fname_testVideo = params.testVideo;
trainvoldir = params.trainvoldir;
fname_Tw = params.fname_Tw;

%% Training features
% Compute training features and Tw
if ~exist(fname_Tw,'file');
    CreateTrainFeatures_liu(params, ...
        trainvoldir, fname_trainfeats, fname_trainfeatsPCA, fname_Tw);
end

%% Test features
CreateTestFeatures_liu(params, ...
    fname_testVideo, fname_testfeats, fname_testfeatsPCA, fname_Tw)
end

%   MODIFIED FROM
%     Distribution code Version 1.0 -- Oct 12, 2013 by Cewu Lu 
%
%   The Code is to demo Sparse Combination in our Avenue Dataset, based on the method described in the following paper 
%   [1] "Abnormal Event Detection at 150 FPS in Matlab" , Cewu Lu, Jianping Shi, Jiaya Jia, 
%   International Conference on Computer Vision, (ICCV), 2013
%   
%   The code and the algorithm are for non-commercial use only.


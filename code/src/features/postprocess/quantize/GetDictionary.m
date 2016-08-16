function [dictionary, idxsFhatIntoDictionary_idxsToUse] = GetDictionary(pars, featsTrain)
  paths = pars.paths;
FEATIDXSTART=11; % 1-10 are frame nums, etc.

if exist(paths.files.dictionaryMATfile,'file')
    load(paths.files.dictionaryMATfile,'dictionary','idxsFhatIntoDictionary_idxsToUse');
    return;
end

fprintf('Running kmeans for %d feats, K = %d\n',size(featsTrain,1),pars.K);
[pth,nm,ext] = fileparts(paths.files.dictionaryMATfile);
save(fullfile(pth,'whitenedTrain'),'featsTrain','-v7.3');
[dictionary, idxsFhatIntoDictionary_idxsToUse] = vl_kmeans(featsTrain(:,FEATIDXSTART:end)',pars.K,'verbose','Initialization','plusplus');
fprintf('Done.\n');


end


%     %% Find start, end frames
%     numFrames = max(fhat(:,1));
%     endFrame = pars.endFrame;
%     if isinf(endFrame) || ischar(endFrame)
%         endFrame = numFrames;
%     end
%     frame_st = min(fhat(:,1)); frame_end = min(endFrame,max(fhat(:,1))); 
%     N = frame_end-frame_st+1; % number of frames

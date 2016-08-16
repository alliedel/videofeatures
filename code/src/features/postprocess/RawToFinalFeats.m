function RawToFinalFeats(pars)
paths = pars.paths;
FEATIDXSTART=11; % 1-10 are frame nums, etc.

if exist(paths.files.finalFeatMATfile,'file')
    return;
end

if ~exist(paths.files.rawFeatMATfile,'file')
    error('bug: rawFeatMATfile didn''t exist\n');
else
    load(paths.files.rawFeatMATfile,'feats');
end
%% == WHITEN TRAINING FEATS (or just get whitening parameters to use on test set) ==
% *** Not whitening before kmeans!! TODO: make this an option.
featsWhite = feats; %#ok<NODEF>
featsWhite(:,1:10) = feats(:,1:10);

if strcmpi('all',pars.dictTrain)
    trainFeatIdxs = 1:size(featsWhite,1);
elseif strcmpi(pars.dictTrain,'firstThird')
    if pars.cuboids
        trainFeatIdxs = feats(:,1) < max(feats(:,1))/3;
    else 
        trainFeatIdxs = feats(:,1) < max(feats(:,1))/3;
    end
elseif strcmpi('firstFifth',pars.dictTrain)
    if pars.cuboids
      trainFeatIdxs = feats(:,1) < max(feats(:,1))/5;
    else 
      trainFeatIdxs = feats(:,1) < max(feats(:,1))/5;
    end
end

%% ==================== GET DICTIONARY ================================
fprintf('Getting dictionary...\n')
[dictionary, idxsFhatIntoDictionary_idxsToUse] = GetDictionary(pars, featsWhite(trainFeatIdxs,:)); %#ok<NASGU,ASGLU>
save(paths.files.dictionaryMATfile,'idxsFhatIntoDictionary_idxsToUse','dictionary','-v7.3');
fprintf('Dictionary computed and saved in %s',paths.files.dictionaryMATfile);

%% =================== QUANTIZE USING DICTIONARY =====================
MyQuantize(pars, featsWhite);

end

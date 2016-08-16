function CreateTrainFeatures_liu(params, ...
    trainvoldir, fname_trainfeats, fname_trainfeatsPCA, fname_Tw)
% Files:
% trainvoldir (directory with vol files in it)
% fname_trainfeats
% fname_trainfeatsPCA
% fname_Tw

tprLen = params.tprLen;
patchWin = params.patchWin;
PCAdim = params.PCAdim;
numEachVol = params.numEachVol;

%% Training feature generation (about 1 minute)
 % The maximum sample number in each training video is numEachVol

if ~exist(fname_trainfeats,'file')
    trainvols = dir2cell(fullfile(trainvoldir,'vol_*.mat'));
    if isempty(trainvols)
        error('No training videos provided in %s\n If you''d like to use the test video as the basis for PCA''d features, place only it in the folder named above.',trainvoldir);
    end

    Cmatrix = zeros(tprLen*patchWin^2, length(trainvols)*numEachVol);
    rand('state', 0);
    for ii = 1 : length(trainvols)
        [feaRawTrain, LocV3Train]  = train_features(trainvols{ii}, params);
        t = randperm(size(feaRawTrain,2));
        curFeaNum = min(size(feaRawTrain,2),numEachVol);
        Cmatrix(:, numEachVol*(ii - 1) + 1 : numEachVol*(ii - 1) + curFeaNum) =  feaRawTrain(:,t(1:curFeaNum));
        disp(['Feature extraction in ', num2str(ii),' th training video is done!']);
        clear feaRawTrain LocV3Train
    end
    Cmatrix(:,sum(abs(Cmatrix)) == 0) = [];
    feaMat = Cmatrix';
    clear Cmatrix
    save(fname_trainfeats,'feaMat');
else
    load(fname_trainfeats,'feaMat');
end
COEFF = princomp(feaMat);
Tw = COEFF(:,1:PCAdim)';
feaMatPCA = Tw*(feaMat'); %#ok<NASGU>
save(fname_trainfeatsPCA,'feaMatPCA','-v7.3');
save(fname_Tw,'Tw');

end

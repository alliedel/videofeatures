function Wrapper_CreateFinalFeatMATFile_liu(pars)
flds = fieldnames(pars);
% export the liu-relevant features to a new structure it can handle
for i = 1:length(flds) 
    parsfld = flds{i};
    a = strfind(parsfld,'liu_');
    if isempty(a)
        continue;
    else
        paramfld = parsfld(a+length('liu_') : end);
        params.(paramfld) = pars.(parsfld);
    end
end
params.testVideo = pars.paths.files.pathToVideo;
params.fname_testfeats = pars.paths.files.liu_testFeats;
params.fname_testfeatsPCA = pars.paths.files.liu_testFeatsPCA;
params.fname_trainfeats = pars.paths.files.liu_trainFeats;
params.fname_trainfeatsPCA = pars.paths.files.liu_trainFeatsPCA;
params.fname_Tw = pars.paths.files.liu_Tw;
params.trainvoldir = pars.paths.folders.pathToTrainVideoDir;

% -- Create 'vol' files
% Test
volname = GenerateVolname(pars.pathToVideo);
if ~exist(volname,'file')
    outdir = extractFrames(pars.pathToVideo);
    vol = Frames2Vol(outdir, pars.liu_imresize);
    save(volname,'vol','-v7.3');
else
    fprintf('Found test file %s\n',volname);
end

[H,W] = MATfileGetHW(volname);
params.H = H;
params.W = W;

% Train
movnames = dir2cell(fullfile(pars.paths.folders.pathToTrainVideoDir,'*.avi'));
movnames = [movnames; dir2cell(fullfile(pars.paths.folders.pathToTrainVideoDir,'*.mp4'))];
for f = 1:length(movnames)
    volname = GenerateVolname(movnames{f});
    if ~exist(volname,'file')
        outdir = extractFrames(movnames{f});
        vol = CreateVol(outdir, pars.liu_imresize);
        save(volname,'vol','-v7.3');
        fprintf('Created %s\n',volname);
    else
        fprintf('Found training file %s\n',volname);
    end
end

if ~exist(params.fname_testfeats,'file')
    CreateFinalFeatMATFile_liu(params);
    assert(exist(pars.paths.files.finalFeatMATfile,'file')~=0);
end
fn_libsvm = pars.paths.files.fn_libsvm;
if ~exist(fn_libsvm,'file')
    fprintf('Converting to LibSVM...\n')
    ConvertToLibSVM(pars.paths.files.finalFeatMATfile, fn_libsvm);
    fprintf('Saving feature locations...\n');
    locsfile = strrep(fn_libsvm,'.train','_locs.mat');
    load(pars.paths.files.finalFeatMATfile,'LocV3');
    save(locsfile,'LocV3');
    assert(exist(fn_libsvm,'file')~=0);
end

end

function [H,W] = MATfileGetHW(matfile)
load(matfile);
info = whos(matfile,'vol');
sz = info.size;
H = sz(1);
W = sz(2);
end

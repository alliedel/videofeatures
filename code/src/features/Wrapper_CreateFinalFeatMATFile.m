function Wrapper_CreateFinalFeatMATFile(pars)

fprintf('I''ve got to generate some %s features\n',pars.rawFeatType)

if pars.rawFeatsOnly
MakeRawFeatures(pars);
return;
end

if strcmpi(pars.rawFeatType,'DT')
    if ~exist(pars.paths.files.fn_libsvm,'file') &&  ~exist(pars.paths.files.finalFeatMATfile,'file')
        fprintf('Generating features. %s didn''t exist\n', pars.paths.files.finalFeatMATfile);
        MakeRawFeatures(pars);
        if strcmpi(pars.ScoreEach,'frame')
            RawToFinalFeats(pars);
        else %pars.ScoreEach == 'interestpoint'
            ConvertRawFeatsToFn(pars);
        end
    end
elseif strcmpi(pars.rawFeatType,'cuboidBin')
    if strcmpi(pars.ScoreEach, 'interestpoint')
        error('I haven''t implemented this yet\n')
    end
    if ~exist(pars.paths.files.fn_libsvm,'file') &&  ~exist(pars.paths.files.finalFeatMATfile,'file')
        fprintf('Generating features. %s didn''t exist\n', pars.paths.files.finalFeatMATfile);
        [locs, fn] = ComputeBinZhaoFeatures(pars.pathToVideo, pars.paths.folders.pathToTmp, pars);
        save(pars.paths.files.finalFeatMATfile,'fn','locs','-v7.3')
    end
elseif strcmpi(pars.rawFeatType,'freq')
    if strcmpi(pars.ScoreEach, 'interestpoint')
        error('I haven''t implemented this yet\n')
    end
    if ~exist(pars.paths.files.fn_libsvm,'file') &&  ~exist(pars.paths.files.finalFeatMATfile,'file')
        fprintf('Generating features. %s didn''t exist\n', pars.paths.files.finalFeatMATfile);
        [fn] = ComputeFrequencyFeatures(pars.pathToVideo,pars);

        save(pars.paths.files.finalFeatMATfile,'fn','-v7.3');
    end
else
    error('Please make rawFeatType something I can understand -- not %s',pars.rawFeatType)
end

assert(exist(pars.paths.files.finalFeatMATfile,'file') > 0);

if pars.whitenBeforeAnomalyDetect
    fprintf('Whitening feats\n');
    try
        load(pars.paths.files.finalFeatMATfile,'whitened')
    catch
        whitened = 0;
    end
    if ~exist('whitened','var') || (whitened == 0)
        d=load(pars.paths.files.finalFeatMATfile);
        d.fn_unwhite = d.fn;
        cntrs = mean(d.fn,2);
        fn_cntrd = bsxfun(@minus,d.fn,cntrs);
        stds = std(fn_cntrd,[],2);
        d.fn = bsxfun(@rdivide,fn_cntrd,stds);
        d.whitened = 1;
        save(pars.paths.files.finalFeatMATfile,'-struct','d','-v7.3');
    end
else
    error(['Haven''t implemented this.  Need a new name for finalFeatMATfile!'
    'Currently I assume everyone wants to whiten before anomalydetect.'])
end

% == Convert to LibSVM
fn_libsvm = pars.paths.files.fn_libsvm;
if ~exist(fn_libsvm,'file')
    fprintf('Converting to LibSVM...\n')
    ConvertToLibSVM(pars.paths.files.finalFeatMATfile, fn_libsvm)
    fprintf('Done.\n')
    
end

end

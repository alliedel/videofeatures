function MyQuantize(pars, feats)

FEATIDXSTART=11;
paths = pars.paths;
if exist(paths.files.finalFeatMATfile,'file')
    fprintf('final feat file already exists in %s\n',paths.files.finalFeatMATfile);
    return;
end
paths = pars.paths;
if ~exist('feats','var')
    load(paths.files.rawFeatWhiteMATfile_test,'fn');
    feats=fn;
end
if strcmpi(pars.BOVtype,'hard')

    fprintf('Dictionary: %s\n',paths.files.dictionaryMATfile);
    load(paths.files.dictionaryMATfile)
    fprintf('Done\n');
    fprintf('Quantizing test features...');
    tic
    [D,idxsFhatIntoDictionary] = min(pdist2(dictionary',feats(:,FEATIDXSTART:end)));

    %% c) BOV: Generate {fn}, histograms of quanitized features in each frame.
    % fn is KxN: N features of dimension K
    K = pars.K; frame_st = min(feats(:,1)); frame_end = max(feats(:,1));
    N = frame_end - frame_st + 1;
    frame_idxs = frame_st:frame_end;
    fn = zeros(N,K);

    bins = 1:K+0.5;
    framenums = frame_st:frame_end;
    for i = 1:length(framenums)
        j = framenums(i);
        frameiFeats = idxsFhatIntoDictionary(feats(:,1) == j);
        fn(i,:) = hist(frameiFeats,bins);
    end

else

    K = size(feats,2)-10;
    frame_st = min(feats(:,1)); frame_end = max(feats(:,1)); % frame_st =  min(feats(:,1));
    N = frame_end - frame_st + 1;
    frame_idxs = frame_st:frame_end;
    fn = zeros(K,N);

    framenums = frame_st:frame_end;
    for i = 1:length(framenums)
       j = framenums(i);
       frameiFeatIdxs = find(feats(:,1) == j);
       if length(frameiFeatIdxs) > 0
           frameiFeats = feats(frameiFeatIdxs,FEATIDXSTART:end);
           if strcmpi(pars.BOVtype,'noneMeanAgg')
               fn(i,:) = mean(frameiFeats,1);
           elseif strcmpi(pars.BOVtype,'noneMaxAgg')
               fn(i,:) = max(frameiFeats,[],1);
           elseif strcmpi(pars.BOVtype,'noneStdAgg')
               fn(i,:) = std(frameiFeats,0,1);
           else
               error('Quantization type %s not understood\n',pars.BOVtype);
           end
       end
   end
end

if strcmpi(pars.normHist,'l1') % l1 normalization means %ages are used as frequencies (rather than raw counts)
    for i = 1:length(framenums)
        if sum(abs(fn(i,:)))==0
            fn(i,:)=0;
        else
            fn(i,:) = fn(i,:)/sum(abs(fn(i,:)));
        end
    end
elseif isempty(pars.normHist) || strcmpi(pars.normHist,'none') % Don't normalize
    % Don't do anything (no normalization)
else
    error('pars.normHist=%s isn''t recognized',pars.normHist)
end

if pars.whitenAfterKmeans
%% =================== WHITEN AGAIN FOR LOGISTIC REGRESSION ==========
    % Center
    K=pars.kPCAFinalFeats;
    X=fn;
    X_c = bsxfun(@minus,X,mean(X,1));
    X=X_c;

    epsilon = 1e-10;
    [U,S,~] = svd(X'*X); % Note third output is also U.
    Upca=U(:,1:K);
    Spca=S(1:K,1:K);
    Xpca = X * Upca;
    Xpcawhite = Xpca * diag( 1./sqrt(diag(Spca) + epsilon) );

    fn = Xpcawhite;
end

save(paths.files.finalFeatMATfile,'fn','frame_st','frame_end','N','frame_idxs','-v7.3');
fprintf('Done.\n');

end

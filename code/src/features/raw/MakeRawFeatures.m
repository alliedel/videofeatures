function MakeRawFeatures(pars)

    paths = pars.paths;

    if exist(paths.files.rawFeatMATfile,'file')
        fprintf('Raw feat file already exists in %s\n',paths.files.rawFeatMATfile);
        return;
    end 

    % Extract features if needed
    pathToFeatTxt = paths.files.dt_Txtfile;
    pathToFeatMAT = paths.files.dt_MATfile;

    if ~existAndNotEmpty(pathToFeatMAT)

        % Run DT code
        if ~existAndNotEmpty(pathToFeatTxt)
            cmdStr=GetDTCmdStr(pars);
            display(cmdStr)
            [stat, res] = runCmd(cmdStr,'-echo',1);
            if ~existAndNotEmpty(pathToFeatTxt)
                if ~exist(pars.paths.files.pathToVideo,'file')
                    error('%s doesn''t exist.',pars.paths.files.pathToVideo);
                else
                    error(['Command didn''t work (but video file exists).' ...
                        'Did you run ''make'' in the densetrajectories directory?']);
                end
            end
        end

        % Convert to mat file
        if ~exist(pathToFeatMAT,'file')
            % Convert txt file to MATLAB file if necessary
            of = convertDTtoMAT(pathToFeatTxt);
            fprintf('Converted DT to MAT: %s\n', of);
        end
    end

    % frame to Grid
    if pars.frameToBlocks
        if ~exist('feats','var')
            load(pathToFeatMAT)
            assert(exist('feats','var') > 0)
        end

        [M,N,T] = GetVideoSize(pars.pathToVideo);
        videoSize = [M,N,T];
        rct = feats(:,[3 2 1]);
        gridIdxs = FramesToGrid(rct, pars.blockSize, pars.blockStride, videoSize);

        feats(:,1) = gridIdxs;    
        save(paths.files.rawFeatMATfile,'feats','-v7.3');
    end
    if ~exist(paths.files.rawFeatMATfile,'file')
        error('Bug: didn''t generate the correct file\n')
    end
end

function cmdStr=GetDTCmdStr(pars)

    if ~isempty(pars.W) || ~ischar(pars.W)
        DenseTrackParsString=sprintf('-W %d ',pars.W);
    else
        DenseTrackParsString='';
    end

    if ~isinf(pars.endFrame) && ~isempty(pars.endFrame)
        DenseTrackParsString=sprintf('%s-E %d ',DenseTrackParsString,pars.endFrame);
    end
    if pars.startFrame~=1
        DenseTrackParsString=sprintf('%s-S %d ',DenseTrackParsString,pars.startFrame);
    end

    pathToFeatTxt = pars.paths.files.dt_Txtfile;
    cmdStr = sprintf([fullfile(pars.parsScript.dtPath, ...
        'release/DenseTrack %s %s %s')], ...
        pars.pathToVideo, pathToFeatTxt, DenseTrackParsString);
end

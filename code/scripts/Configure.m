function [parsCell, argsCell, parsCombos] = Configure(opt, pathToVideo, finalFeatMATfile)
%% [parsCell, argsCell, parsCombos] = Configure(opt)
% opt: string identifier for a batch of experiments to run
% parsCell: cell array of structures, each is the 'pars' for one
%   experiment. length(parsCell) is the number of experiments.
% argsCell: cell array of cell arrays, each is the list of user-set
%   parameters for one experiment.  length(argsCell) is the number of
%   experiments.
% parsCombos: structure whose fields are the parameters set by the user for
% each experiment.  length(parsCombos.lambda) represents the number of
% permutations of lambda used in generating the set of experiments.

parsCombos = struct;

%% List of user-defined parameter combiniations
if strcmpi(opt,'default')
    parsCombos.pathToTrainVideoDir = '../../data/input/videos/Avenue/train';
    parsCombos.anomDetectRoot = '../../';
    parsCombos.featType = 'liu';
    parsCombos.liu_numEachVol = 7000;
    parsCombos.liu_PCAdim = 100;
elseif strcmpi(opt,'avenue03_3000')
    parsCombos.pathToTrainVideoDir = '../../data/input/videos/Avenue/train';
    parsCombos.anomDetectRoot = '../../';
    parsCombos.featType = 'liu';
    parsCombos.liu_numEachVol = 3000;
    parsCombos.liu_PCAdim = 100;
else
    error('Didn''t recognize your configure option opt: %s',opt);
end

parsCombos.pathToVideo = pathToVideo;
[pth,~,~] = fileparts(pathToVideo);
parsCombos.pathToTrainVideoDir = fullfile(pth,'train');

if exist('finalFeatMATfile','var') % Use only if you want to convert .mat file to .train file
    parsCombos.finalFeatMATfile = finalFeatMATfile;
end

argsCell = GetParameterPermutations(parsCombos);

%% Convert to correct format
parsCell = cell(size(argsCell));
for i = 1:length(argsCell)
    parsScript = ParseScriptArgs(argsCell{i}{:});
    AddToolPaths(parsScript);
    pars = parseArgs_anomalyDetection(argsCell{i}{:});
    pars.parsScript = parsScript;
    parsCell{i} = pars;
%     pause(1); % make sure the temp files are generated at different times
end

end

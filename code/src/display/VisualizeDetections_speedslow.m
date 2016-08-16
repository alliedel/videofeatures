function VisualizeDetections_speedslow(A3, inVideo, outVideo, outPlot, optThresh, fps)
% A3 : anomaly scores, in format [rs cs T] -- so if you have a 1D signal,
% reshape([1 1 length(A)])
% optThresh can be left empty; by default it will be 3*std(A)
% If you don't want to save the plot of anomaly scores thresholded, outPlot
% = '';
% fps can be left empty and the fps of the original video will be chosen.
if ~exist('optThr','var')
    stdmult = 1;
    optThr = mean(A3(:)) + stdmult*std(A3(:));
end 

fps_anom = fps/2;
fps_familiar = fps*10;

outdir = extractFrames(inVideo);
orig_frames = dir2cell_old(fullfile(outdir,'*.png'));
T = length(orig_frames);
[M,N,~] = size(imread(orig_frames{1}));

imgString = '%05d.png';

[pth,nm,~] = fileparts(outVideo);
framesdir = fullfile(pth,[nm '_frames']);
if exist(framesdir,'dir')
    system(sprintf('rm -r %s',framesdir));
end

mkdir(framesdir)

if T ~= size(A3,3)
    if abs(T - size(A3,3)) <= 10
        warning('T = %d, size(A3,3) = %d\n',T,size(A3,3));
        T = min(T,size(A3,3));
    else
        error('A3 must be the same size as the video (how else am I going to know which frame to write on?')
    end
end

%% video demo
A3Frames = A3;
for i = 1:T
    A3Frames(:,:,i) = i;
end
plot(A3Frames(:),A3(:));
xlim([0 max(A3Frames(:))]);
xls = xlim();
hold on; plot(xls,[optThr optThr]); hold off
if ~isempty(outPlot)
    export_fig(outPlot,'-png','-pdf','-transparent');
end

anom_frm_cnt = 0;
frameID = 1;
while frameID <= T
    anomLocs = double(imresize(A3(:,:,frameID) ,[M, N], 'nearest') > optThr) ;
    if any(anomLocs(:))
        anom_frm_cnt = anom_frm_cnt + 1;
    end
    orig = double(imread(orig_frames{frameID}));
    tinted = orig;
    tinted(:,:,1) = tinted(:,:,1) + 50*anomLocs;
    fignm = sprintf(imgString,frameID);
    imwrite(uint8([orig tinted]),fullfile(framesdir,fignm))
    if mod(frameID,10) == 0
        fprintf('Frames written: %d/%d . %d anomalous.\r',frameID,T,anom_frm_cnt)
    end
    possibleSkips = frameID + (0:
    if any(reshape(A3(:,:,frameID + (1:),1,[])
    frameID = frameID + 1;
end
if ~exist('fps','var') || isempty(fps)
    fps = GetFrameRate(inVideo);
end
% MergeFrames( framesdir, outVideo, fps, imgString);
[pth,~,ext] = fileparts(imgString);
imgstring = fullfile(pth,imgString);
MergeFrames( framesdir, outVideo, fps, imgstring);

end

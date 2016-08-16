function fn = ComputeFrequencyFeatures(vidPath, pars)

% Convert video to frames
frameDir =  extractFrames(vidPath);
% imgs_names = fullfile(frameDir,dir2cell(fullfile(frameDir,'*.jpg')));
imgs_names = dir2cell_old(fullfile(frameDir,'*.jpg'));

md = pars.downsampleSize(1);
nd = pars.downsampleSize(2);

T = length(imgs_names);
[m,n,~] = size(imread(imgs_names{1}));
im3d = zeros(md, nd, pars.fft_window);
nfreqs = pars.fft_window;
fn = zeros(T,md*nd*nfreqs);
for i = 1:T
    im = imread(imgs_names{i});
    im = rgb2gray(im);
    imDown = imresize(im,[md nd]);
    if i < pars.fft_window
        im3d(:,:,i) = imDown;
    else
        im3d(:,:,1:(pars.fft_window - 1)) = im3d(:,:,2:(pars.fft_window));
        im3d(:,:,pars.fft_window) = imDown;
        freqresponse = fft(reshape(im3d, size(im3d,3),[]),pars.fft_window);
        fn(i,:) = abs(freqresponse(:)); % magnitude only
    end
    
    if mod(i,20) == 0
        fprintf('%d/%d\r',i,T);
    end
    
end

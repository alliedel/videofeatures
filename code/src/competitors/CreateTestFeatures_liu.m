function CreateTestFeatures_liu(params, ...
    fname_testVideo, fname_testfeats, fname_testfeatsPCA, fname_Tw)

tprLen = params.tprLen;
patchWin = params.patchWin;
PCAdim = params.PCAdim;
numEachVol = params.numEachVol;
H = params.H;
W = params.W;

load(fname_Tw,'Tw');
testfeatsvolname =  GenerateVolname(fname_testVideo);
load(testfeatsvolname);
imgVol = im2double(vol);
volBlur = imgVol;
blurKer = fspecial('gaussian', [3,3], 1);
mask = conv2(ones(H,W), blurKer,'same');
for pp = 1 : size(imgVol,3)
     volBlur(:,:,pp) =  conv2(volBlur(:,:,pp), blurKer, 'same')./mask;
end
feaVol = abs(volBlur(:,:,1:(end-1)) - volBlur(:,:,2:end));
[feaPCA, LocV3, feaRaw] = test_features(feaVol, Tw, params);
fn = feaPCA';
save(fname_testfeatsPCA, 'fn', 'LocV3','-v7.3')
fn = feaRaw';
save(fname_testfeats, 'fn','LocV3','-v7.3');
end

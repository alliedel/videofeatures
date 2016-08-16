function [rs,cs,ts, sz] = ComputeGridStartLocsAndSz(blockSize, blockStride, videoSize)
% sz = [dr dc dt]
if any(blockSize(1:2) > 1) % fraction of frame
    error('I haven''t implemented non-fraction blockSizes')
end
if any(blockStride(1:2) > 1) % fraction of frame
    error('I haven''t implemented non-fraction blockSizes')
end
if blockStride(1) ~= 1 || blockStride(2) ~= 1 || (blockStride(3) ~= blockSize(3))
    error('I can''t handle your blockStride/blockSize parameters at the moment.  Please make blockStride [1 1 blockSize(3)]\n')
end

sz = floor([blockSize(1:2).*videoSize(1:2) blockSize(3)]);
stride = [blockStride(1:2).*sz(1:2) blockStride(3)];

startFromLeft = 0:stride(1):(videoSize(1)-sz(1));
rs = CenterLocs(startFromLeft,videoSize(1),sz(1));
startFromLeft = 0:stride(2):(videoSize(2)-sz(2));
cs = CenterLocs(startFromLeft,videoSize(2),sz(2));
ts = 1:stride(3):(videoSize(3)-sz(3) + 1); % we don't center t

end

function idxs_centered = CenterLocs(idxs_leftjustified, rightEdge, sz)

leftover = rightEdge - (idxs_leftjustified(end) + sz - 1);
shift_right = floor(leftover / 2);
idxs_centered = idxs_leftjustified + shift_right;

end


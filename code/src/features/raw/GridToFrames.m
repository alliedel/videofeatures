function [rct, sz] = GridToFrames(gridIdxs, blockSize, blockStride, videoSize, center)
% Center: center the point in the grid.  Otherwise, returns the start locs of the grid.
if ~exist('center','var')
    center = 0;
end

[rst,cst,tst, sz] = ComputeGridStartLocsAndSz(blockSize, blockStride, videoSize);

rct = zeros(length(gridIdxs),3);

for z = 1:size(rct,1)
    rct(z,:) = GetCoordinate_rctVals(gridIdxs(z),rst,cst,tst);
end

if center
    cntr_amt = floor(sz / 2);
    rct = bsxfun(@plus,rct, cntr_amt);
end

assert(size(rct,1) == length(gridIdxs))

end

function rct = GetCoordinate_rctVals(idx,r_startLocs,c_startLocs,t_startLocs)
    sz = [length(r_startLocs) length(c_startLocs),length(t_startLocs)];
    [ridx, cidx, tidx] = ind2sub(sz, idx);
    r = GetSingleValue(ridx,r_startLocs);
    c = GetSingleValue(cidx,c_startLocs);
    t = GetSingleValue(tidx,t_startLocs);    
    rct = [r c t];
end

function val = GetSingleValue(idx,startLocs)
% Right now, points that don't fall into a grid just get assigned to the
% closest grid.

if idx > length(startLocs) || idx < 1
    error('Something is wrong here when converting grid to frames\n')
end

val = startLocs(idx);

end

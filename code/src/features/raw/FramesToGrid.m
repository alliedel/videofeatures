function gridIdxs = FramesToGrid(rct, blockSize, blockStride, videoSize) % r,c,t from DT: 
% ** at the moment, only works for one-to-one mappings!
% rct = [row col frame]
[rst,cst,tst, sz] = ComputeGridStartLocsAndSz(blockSize, blockStride, videoSize);

r=rct(:,1);
c=rct(:,2);
t=rct(:,3);

if any(r > videoSize(1)) || any(c > videoSize(2)) || any(t > videoSize(3))
    error('rct contains indices larger than the videoSize entered\n')
end

gridIdxs = zeros(size(rct,1),1);

for z = 1:size(rct,1)
    
    gridIdxs(z) = GetCoordinate(rct(z,:),rst,cst,tst);

end

end

function idx = GetCoordinate(rct,r_startLocs,c_startLocs,t_startLocs)
    ridx = GetSingleIndex(rct(1), r_startLocs);
    cidx = GetSingleIndex(rct(2), c_startLocs);
    tidx = GetSingleIndex(rct(3), t_startLocs);
    sz = [length(r_startLocs) length(c_startLocs),length(t_startLocs)];
    idx = sub2ind( sz, ridx, cidx, tidx);
end

function idx = GetSingleIndex(val,startLocs)
% Right now, points that don't fall into a grid just get assigned to the
% closest grid.
idx = find(val >= startLocs, 1, 'last');
if isempty(idx)
    if (val < 0)
        error('Something is wrong here when converting frames to grid\n')
    else
        idx = 1;
    end
end

end


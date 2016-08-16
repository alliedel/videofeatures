function volname = GenerateVolname(movname) % Created to keep naming conventions the same
    [pth,nm,~] = fileparts(movname);
    volname = fullfile(pth,['vol_' nm '.mat']);
end

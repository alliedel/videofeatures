function vol = CreateVol(framesdir, sz)                                                        
framefiles = dir2cell(fullfile(framesdir,'*.png'));                                            
T = length(framefiles);                                                                        
vol = zeros(sz(1), sz(2), T);                                                                  
for t = 1:T                                                                                    
    vol(:,:,t) = uint8(imresize(rgb2gray( ...                                                  
        imread(fullfile(framesdir,sprintf('image-%06d.png',t))) ...                            
        ), sz));                                                                               
    % or rgb2gray, etc. of imread(framefiles{t})                                               
end                                                                                            
                                                                                               
end                                                                                            


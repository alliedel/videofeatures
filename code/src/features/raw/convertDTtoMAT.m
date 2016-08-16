function outfile = convertDTtoMAT(pathToDTTxt,override)
MAXNUMFEATS = 5000000;
FEATSIZE = 436;

if ~exist('override','var')
    override = 0;
end

[fpath,fname,EXT] = fileparts(pathToDTTxt);
outpath = fpath;
outfile = fullfile(outpath,[fname '.mat']);

if exist(outfile)
    fprintf('Using file %s\n',outfile);
    return;
end

fload = fullfile(fpath,fname);
FIN = fopen(fload,'r');
if( FIN < 0)
  fload = [fullfile(fpath,fname) EXT];
  FIN = fopen(fload,'r');
end

if( FIN < 0)
  FIN = fopen(fload,'r');
  error('Couldn''t open file %s!\n', fload);
  %keyboard
  exit
end
fprintf('Reading in file %s\n', fload);

count = 1;
fline = fgetl(FIN);
curr_frame = 0;
error_points = 0;
feats = zeros(MAXNUMFEATS,FEATSIZE,'single');
while ( ischar(fline) && count <= MAXNUMFEATS )
  iline = sscanf(fline, '%f'); %float
  iline = iline';
  
  if(length(iline) ~= FEATSIZE)
    error_points = error_points + 1;
    fline = fgetl(FIN);
    fprintf('ERROR: bad desc length: %d\n', length(iline));
    fprintf('error points so far: %d\n', error_points);
    continue;
  end
  feats(count,:) = single(iline);
  
  count = count + 1;
%  curr_frame = iline(1);
  fline = fgetl(FIN);
  if (mod(curr_frame,20)==1) && (curr_frame~=iline(1))
      curr_frame = iline(1);
      fprintf('%d\n',curr_frame);
  end
end

fclose(FIN);


if count <= MAXNUMFEATS
   feats(count:MAXNUMFEATS,:)=[];
end

if isempty(feats)
    outfile = '';
    ALL_OK = 0;
else
    save(outfile,'feats','-v7.3')
    ALL_OK = 1;
end

fprintf('Saved in: %s\n', outfile);

end

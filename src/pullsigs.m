function sig = pullsigs(fname)
% this is an adhoc function. exactly the same as sbxpullsignals except for
% the fact that we do a check for the presence of the align file. Only if
% it is present we do the circshift operation. This option is not present
% in sbxpullsignals.

global info;

load([fname '.segment'],'-mat'); % load segmentation

z = sbxread(fname,1,1);
ncell = max(mask(:));

idx = cell(1,ncell);
for i=1:ncell
    idx{i} = find(mask==i);
end

sig = zeros(info.max_idx, ncell);

h = waitbar(0,sprintf('Pulling %d signals out...',ncell));

for i=1:info.max_idx+1
    waitbar(i/(info.max_idx),h);          % update waitbar...
    z = sbxread(fname,i-1,1);
    z = squeeze(z(1,:,:));
    if ~isempty(info.aligned)
        z = circshift(z,info.aligned.T(i,:)); % align the image
    end
    for j=1:ncell                           % for each cell
        sig(i,j) = mean(z(idx{j}));       % pull the mean signal out...
    end
end
delete(h);

save([fname '.signals'],'sig');     % append the motion estimate data...



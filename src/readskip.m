function z = readskip(fname,startFrame,numFramesToSkip,channel,h)
global info;

numFramesToRead = floor(info.max_idx/numFramesToSkip);

% if no channel is given, use channel 1
if nargin < 4; channel = 1; end

z = sbxread(fname,startFrame,1);
T = [];

z = zeros([size(z,2) size(z,3) numFramesToRead]);

for j = 1:numFramesToRead
    if exist('h','var') && ~isempty(h)
        waitbar(j/numFramesToRead,h);
    end
    q = sbxread(fname,j*numFramesToSkip,1);
    q = squeeze(q(channel,:,:));
    if ~isempty(info.aligned)
        q = circshift(q,info.aligned.T(j*numFramesToSkip,:)); 
%         z = circshift(q,info.aligned.T(i+1,:)); % align the image
    end
    z(:,:,j) = q;
end

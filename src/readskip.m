function z = readskip(fname,startFrame,nFramesToSkip,channel,h)
    global info;

    nFramesToRead = floor(info.max_idx/nFramesToSkip);

    % if no channel is given, use channel 1
    if nargin < 4; channel = 1; end

    % z = sbxread(fname,startFrame,1);
    z = zeros(info.sz);

    for j = 1:nFramesToRead
        if exist('h','var') && ~isempty(h)
            waitbar(j/nFramesToRead,h);
        end
        origFrame = sbxread(fname,j*nFramesToSkip,1);
        origFrame = squeeze(origFrame(channel,:,:));
        if ~isempty(info.aligned)
            alignedFrame = circshift(origFrame,info.aligned.T(j*nFramesToSkip,:)); 
            z = z + double(alignedFrame);
        else
            z = z + double(origFrame);
        end
%         if isfield(info,'alignedNR') && ~isempty(info.alignedNR)
%             warpedFrame = imwarp(origFrame,squeeze(info.alignedNR.T(j*nFramesToSkip,:,:,:))); 
%         end
        
    %     z = z + double(warpedFrame); % RS - 160704
    end
end
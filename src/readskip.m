function z = readskip(fname,nFramesToSample,channel,h)
    global info;

    deltaFrames = floor(info.max_idx/nFramesToSample);
    disp(deltaFrames)

    % if no channel is given, use channel 1
    if nargin < 4; channel = 1; end

    % z = sbxread(fname,startFrame,1);
    z = zeros([info.sz nFramesToSample]);

    for j = 1:nFramesToSample
        if exist('h','var') && ~isempty(h)
            waitbar(j,h);
        end
        origFrame = sbxread(fname,(j-1)*deltaFrames,1);
        origFrame = squeeze(origFrame(channel,:,:));
        if ~isempty(info.aligned)
            alignedFrame = circshift(origFrame,info.aligned.T((j-1)*deltaFrames+1,:)); 
            z(:,:,j)=double(alignedFrame);
            %z = z + double(alignedFrame);
        else
            z(:,:,j)=double(origFrame);
            %z = z + double(origFrame);
        end
%         if isfield(info,'alignedNR') && ~isempty(info.alignedNR)
%             warpedFrame = imwarp(origFrame,squeeze(info.alignedNR.T(j*nFramesToSkip,:,:,:))); 
%         end
        
    %     z = z + double(warpedFrame); % RS - 160704
    end
end
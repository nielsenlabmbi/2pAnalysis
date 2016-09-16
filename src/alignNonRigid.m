function [m,dispField] = alignNonRigid(fname,idx,channel,numIdx,h)
 
if(length(idx)==1)
    A = sbxread(fname,idx(1),1); A = double(squeeze(A(channel,:,:))); % read the frames
    m = A;
    dispField = {zeros([size(A) 2])};
elseif (length(idx)==2) % align two frames
    A = sbxread(fname,idx(1),1); A = double(squeeze(A(channel,:,:))); % read the frames
    B = sbxread(fname,idx(2),1); B = double(squeeze(B(channel,:,:))); 
    [D,Ar] = imregdemons(A,B,[32 16 8 4],'AccumulatedFieldSmoothing',2.5,'PyramidLevels',4,'DisplayWaitBar',false);
    m = (Ar/2+B/2);
    dispField = {D zeros([size(A) 2])};
else
    idx0 = idx(1:floor(end/2)); % split dataset in two
    idx1 = idx(floor(end/2)+1 : end); % recursive alignment
    
    if nargin == 5 && ~isempty(h)
        waitbar(min(idx0)/numIdx,h);
    else
        numIdx = 0; h = [];
    end

    [A,D0] = alignNonRigid(fname,idx0,channel,numIdx,h);
    [B,D1] = alignNonRigid(fname,idx1,channel,numIdx,h);
    [D,Ar] = imregdemons(A,B,[32 16 8 4],'AccumulatedFieldSmoothing',2.5,'PyramidLevels',4,'DisplayWaitBar',false);
    m = (Ar/2+B/2);
    D0 = cellfun(@(x) (x+D),D0,'UniformOutput',false); % concatenate distortions
    dispField = [D0 D1];
end
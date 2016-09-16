% fileList{1} = {'F:\ftaf4\ftaf4_001_012'};
% fileList{2} = {'F:\ftaf1\ftaf1_000_001'};
% fileList{3} = {'F:\ftaf5\ftaf5_000_017' 'F:\ftaf5\ftaf5_000_018' 'F:\ftaf5\ftaf5_000_020' 'F:\ftaf5\ftaf5_000_021' 'F:\ftaf5\ftaf5_000_023'};
% fileList{4} = {'F:\ftaf8\ftaf8_000_006' 'F:\ftaf8\ftaf8_000_007' 'F:\ftaf8\ftaf8_000_008' 'F:\ftaf8\ftaf8_000_009'};
% fileList{5} = {'F:\ftaf8\ftaf8_001_006' 'F:\ftaf8\ftaf8_001_007' 'F:\ftaf8\ftaf8_001_008' 'F:\ftaf8\ftaf8_001_009'};
% fileList{6} = {'F:\ftaf8\ftaf8_001_014' 'F:\ftaf8\ftaf8_001_015'};

function serialPullSigs(fileList)
    for ii=1:length(fileList)
        for jj=1:length(fileList{ii})
            disp(['Pulling signals for file ' fileList{ii}{jj}]);
            signals = pullsigs(fileList{ii}{jj});
            save([fileList{ii}{jj} '.signals'],'signals');
        end
    end
end

function sig = pullsigs(fname)
    % this is an adhoc function. exactly the same as sbxpullsignals except for
    % the fact that we do a check for the presence of the align file. Only if
    % it is present we do the circshift operation. This option is not present
    % in sbxpullsignals.
    global info;
    
    load([fname '.segment'],'-mat'); % load segmentation

    currentFrame = sbxread(fname,1,1); % for getting max_idx
    nCell = max(mask(:));

    idx = cell(1,nCell);
    for cellNum=1:nCell
        idx{cellNum} = find(mask==cellNum);
    end

    sig = zeros(info.max_idx, nCell);

    for frameNum=1:info.max_idx+1
        currentFrame = sbxread(fname,frameNum-1,1);
        currentFrame = squeeze(currentFrame(1,:,:));
        if ~isempty(info.aligned)
            currentFrame = circshift(currentFrame,info.aligned.T(frameNum,:));
        end
        for cellNum=1:nCell
            sig(frameNum,cellNum) = mean(currentFrame(idx{cellNum}));
        end
    end
end
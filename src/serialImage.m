% fileList{1} = {'F:\ftaf4\ftaf4_001_012'};
% fileList{2} = {'F:\ftaf1\ftaf1_000_001'};
% fileList{3} = {'F:\ftaf5\ftaf5_000_017' 'F:\ftaf5\ftaf5_000_018' 'F:\ftaf5\ftaf5_000_020' 'F:\ftaf5\ftaf5_000_021' 'F:\ftaf5\ftaf5_000_023'};
% fileList{4} = {'F:\ftaf8\ftaf8_000_006' 'F:\ftaf8\ftaf8_000_007' 'F:\ftaf8\ftaf8_000_008' 'F:\ftaf8\ftaf8_000_009'};
% fileList{5} = {'F:\ftaf8\ftaf8_001_006' 'F:\ftaf8\ftaf8_001_007' 'F:\ftaf8\ftaf8_001_008' 'F:\ftaf8\ftaf8_001_009'};
% fileList{6} = {'F:\ftaf8\ftaf8_001_014' 'F:\ftaf8\ftaf8_001_015'};

function serialImage(fileList)
% accepts cell list of file paths. if files are in groups, then keep them in the same cell. i.e.
% fileList{1} = 'f:/tpData/ftaf1/ftaf1_001_001';
% fileList{2} = {'f:/tpData/ftaf1/ftaf1_002_001' 'f:/tpData/ftaf1/ftaf1_002_002';}
% fileList{3} = {'f:/tpData/ftaf1/ftad1_010_005' 'f:/tpData/ftaf1/ftad1_010_006';}
    numFramesToSkip = 2;
    
	for ii=1:length(fileList)
		iGroup = cell(length(fileList{ii}),1);
        for jj=1:length(fileList{ii})
			fname = fileList{ii}{jj};
            disp(['Creating image for file ' fname]);
            tempImage = sbxread(fname,0,1);
			
            if size(tempImage,1) == 2
                zGreen = readskip(fname,numFramesToSkip,1);
                zRed = readskip(fname,numFramesToSkip,2);
%                 zFull = cat(3,zRed,zGreen,zeros(size(z)));
                
                channel = 1;
                avgImageG = zGreen;
                avgImageG = avgImageG - min(avgImageG(:)); 
                avgImageG = avgImageG/max(avgImageG(:)); 
                avgImage = repmat(avgImageG,[1 1 3]);
                save([fileList{ii}{jj} '.image_green'],'avgImage','channel','numFramesToSkip');
                
                channel = 2;
                avgImageR = zRed;
                avgImageR = avgImageR - min(avgImageR(:)); 
                avgImageR = avgImageR/max(avgImageR(:)); 
                avgImage = repmat(avgImageR,[1 1 3]);
                save([fileList{ii}{jj} '.image_red'],'avgImage','channel','numFramesToSkip');
                
                avgImage = cat(3,avgImageR,avgImageG,zeros(size(avgImageG)));
                channel = 1;
                save([fileList{ii}{jj} '.image'],'avgImage','channel','numFramesToSkip');
                
                imwrite(avgImage,[fileList{ii}{jj} '.mergeImage.png'])
            else
                zGreen = readskip(fname,numFramesToSkip,1);
                
                channel = 1;
                avgImage = zGreen;
                avgImage = avgImage - min(avgImage(:)); 
                avgImage = avgImage/max(avgImage(:)); 
                avgImage = repmat(avgImage,[1 1 3]);
                save([fileList{ii}{jj} '.image'],'avgImage','channel','numFramesToSkip');
            end
			iGroup{jj} = avgImage;
        end
        save([fileList{ii}{1} '.groupImage'],'iGroup');
	end
end

function z = readskip(fname,nFramesToSkip,channel,useAlignIfExists)
    global info;

    nFramesToRead = floor(info.max_idx/nFramesToSkip);
    
    z = sbxread(fname,0,1);
    T = [];

    z = zeros([size(z,2) size(z,3)]);

    for j = 1:nFramesToRead
        q = sbxread(fname,j*nFramesToSkip,1);
        q = squeeze(q(channel,:,:));
        if useAlignIfExists && ~isempty(info.aligned)
            q = circshift(q,info.aligned.T(j*nFramesToSkip,:)); 
        end
        z = z + double(q);
    end
end

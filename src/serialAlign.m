% fileList{1} = {'F:\ftaf4\ftaf4_001_012'};
% fileList{2} = {'F:\ftaf1\ftaf1_000_001'};
% fileList{3} = {'F:\ftaf5\ftaf5_000_017' 'F:\ftaf5\ftaf5_000_018' 'F:\ftaf5\ftaf5_000_020' 'F:\ftaf5\ftaf5_000_021' 'F:\ftaf5\ftaf5_000_023'};
% fileList{4} = {'F:\ftaf8\ftaf8_000_006' 'F:\ftaf8\ftaf8_000_007' 'F:\ftaf8\ftaf8_000_008' 'F:\ftaf8\ftaf8_000_009'};
% fileList{5} = {'F:\ftaf8\ftaf8_001_006' 'F:\ftaf8\ftaf8_001_007' 'F:\ftaf8\ftaf8_001_008' 'F:\ftaf8\ftaf8_001_009'};
% fileList{6} = {'F:\ftaf8\ftaf8_001_014' 'F:\ftaf8\ftaf8_001_015'};

function serialAlign(fileList,doGroupAlign)
% accepts cell list of file paths. if files are in groups, then keep them in the same cell. i.e.
% fileList{1} = 'f:/tpData/ftaf1/ftaf1_001_001';
% fileList{2} = {'f:/tpData/ftaf1/ftaf1_002_001' 'f:/tpData/ftaf1/ftaf1_002_002';}
% fileList{3} = {'f:/tpData/ftaf1/ftad1_010_005' 'f:/tpData/ftaf1/ftad1_010_006';}
global info;
	channel = 1;
	for ii=1:length(fileList)
		tGroup = cell(length(fileList{ii}),1);
        mGroup = cell(length(fileList{ii}),1);
        for jj=1:length(fileList{ii})
			fname = fileList{ii}{jj};
            disp(['Aligning file ' fname]);
            sbxread(fname,0,1);
            
			[m,T] = align(fname,0:info.max_idx,channel);
			tGroup{jj} = T;
            mGroup{jj} = m;
        end
        save([fileList{ii}{1} '.groupAlign'],'mGroup','tGroup');
		stdT = cell2mat(cellfun(@std,tGroup,'uniformoutput',false));
        if doGroupAlign % && all(stdT(:) < 5)
            disp(['Aligning group ' num2str(ii)]);
            m = mGroup{1}; T = tGroup{1};
            save([fileList{ii}{1} '.align'],'m','T','channel');
            m1 = m;
            for jj=2:length(fileList{ii})
                m = mGroup{jj}; T2 = tGroup{jj};
                
                [T_correct(1),T_correct(2)] = fftalign(m,m1);
                if all(abs(T_correct) < 15)
                    T = T2 + repmat(T_correct,size(T2,1),1);
                else
                    T = T2;
                end
                
                save([fileList{ii}{jj} '.align'],'m','T','channel');
            end
        else
            for jj=1:length(fileList{ii})
                m = mGroup{jj};
                T = tGroup{jj};
                save([fileList{ii}{jj} '.align'],'m','T','channel');
            end
        end

	end
end

function [m,T] = align(fname,idx,channel)
	% Aligns images in fname for all indices in idx
	% Accepts:
	%   fname   - filename
	%   idx     - indices of frames to align
	%   channel - which channel to align
	%   numIdx  - total number of indices (this is for the progressbar)
	%   h       - handle for the progressbar
	% Returns:
	%   m - mean image after the alignment
	%   T - optimal translation for each frame
  
	if(length(idx)==1)
		
		A = sbxread(fname,idx(1),1);
		A = squeeze(A(channel,:,:));
		m = A;
		T = [0 0];
		
	elseif (length(idx)==2)
		
		A = sbxread(fname,idx(1),1);
		B = sbxread(fname,idx(2),1);
		A = squeeze(A(channel,:,:));
		B = squeeze(B(channel,:,:));
		
		[u,v] = fftalign(A,B);
		
		Ar = circshift(A,[u,v]);
		m = (Ar+B)/2;
		T = [[u v] ; [0 0]];
		
	else
		
		idx0 = idx(1:floor(end/2));
		idx1 = idx(floor(end/2)+1 : end);
		
		[A,T0] = align(fname,idx0,channel);
		[B,T1] = align(fname,idx1,channel);
	   
		[u,v] = fftalign(A,B);
		 
		Ar = circshift(A,[u, v]);
		m = (Ar+B)/2;
		T = [(ones(size(T0,1),1)*[u v] + T0) ; T1];
		
	end
end

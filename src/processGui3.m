function varargout = processGui3(varargin)
% PROCESSGUI3 MATLAB code for processGui3.fig
%      PROCESSGUI3, by itself, creates a new PROCESSGUI3 or raises the existing
%      singleton*.
%
%      H = PROCESSGUI3 returns the handle to a new PROCESSGUI3 or the handle to
%      the existing singleton*.
%
%      PROCESSGUI3('CALLBACK',hObject,~,handles,...) calls the local
%      function named CALLBACK in PROCESSGUI3.M with the given input arguments.
%
%      PROCESSGUI3('Property','Value',...) creates a new PROCESSGUI3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before processGui3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to processGui3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help processGui3

% Last Modified by GUIDE v2.5 06-Apr-2017 01:23:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @processGui3_OpeningFcn, ...
                   'gui_OutputFcn',  @processGui3_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before processGui3 is made visible.
function processGui3_OpeningFcn(hObject,~,handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% ~  reserved - to be defined in a future version of MATLAB
% varargin   command line arguments to processGui3 (see VARARGIN)

% Choose default command line output for processGui3
handles.output = hObject;

% Set path to current directory and make a blank file name
handles.filePath = 'Z:\2P\Ferret 2P\Ferret 2P data';
handles.fileName = '';
if ~strcmp('\',handles.filePath(end));
    handles.filePath = [handles.filePath '\'];
end
set(handles.FilePath,'String',handles.filePath);

% Blank preview images
axes(handles.PreviewChannel1);
image(zeros(512,796,3));
set(gca,'XTick',[],'YTick',[]);
axes(handles.PreviewChannel2);
image(zeros(512,796,3));
set(gca,'XTick',[],'YTick',[]);

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = processGui3_OutputFcn(hObject,~,handles)  %#ok<*INUSL>
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%%%%% FILE PANEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function FilePath_CreateFcn(~,~,~) %#ok<*DEFNU>
function FilePath_Callback(hObject,~,handles)
% hObject    handle to FilePath (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
% Get file path
filePath = get(hObject,'String');
if ~strcmp('\',filePath(end))
    filePath = [filePath '\'];
end
% If filepath exists and is different from current file path
if exist(filePath,'dir') && ~strcmp(filePath,handles.filePath)
    % set new file path
    handles.filePath = filePath;
    % reset the gui
    guiReset(handles);
elseif ~exist(filePath,'dir')
    % If no such filepath send a warning
    warndlg('Can not find the chosen directory!','Invalid Path');
    set(handles.FilePath,'String',handles.filePath);
end
guidata(hObject,handles);

function FileName_CreateFcn(~,~,~)
function FileName_Callback(hObject,~,handles)
% hObject    handle to FileName (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
% Get the file name
fileName = get(hObject,'String');
% If the name isn't an sbx file, make it one for checking if it's there
if isempty(strfind(fileName,'.sbx'))
    fileName = strcat(fileName,'.sbx');
end
fn = strcat(handles.filePath,fileName);
if exist(fn,'file') == 2
    % If file is found, truncate file name to the to its root
    fileName = fileName(1:strfind(fileName,'.sbx')-1);
    % Check that file name is different
    if ~strcmp(handles.fileName,fileName)
        % Update the file name
        handles.fileName = fileName;
        % Rest the gui
        guiReset(handles);
    end
else
    % If no such file name send a warning
    warndlg('Can not find the chosen file!','Invalid File');
    set(handles.FileName,'String',handles.fileName);
end
guidata(hObject,handles);

% --- Executes on button press in FindDataFile.
function FindDataFile_Callback(hObject,~,handles)
% hObject    handle to FindDataFile (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
[fileName,filePath] = uigetfile('*.sbx','Choose a data file.','Z:\2P\Ferret 2P\Ferret 2P data');
% fileName = uigetfile('Z:\2P\Ferret 2P\Ferret 2P data\*.sbx');
% filePath = 'Z:\2P\Ferret 2P\Ferret 2P data';
% if user didn't cancel selection
if fileName ~= 0
    fileName = fileName(1:strfind(fileName,'.sbx')-1);
    % Check that file name and path are different
    if ~(strcmp(handles.filePath,filePath) && strcmp(handles.fileName,fileName))
        % Set new file name and path
        handles.fileName = fileName;
        handles.filePath = filePath;
        set(handles.FileName,'String',handles.fileName);
        set(handles.FilePath,'String',handles.filePath);
        guidata(hObject,handles);
        % Reset the GUI
        guiReset(handles);
    end
end

% --- Executes on button press in LoadInfo.
function LoadInfo_Callback(hObject,~,handles)
% hObject    handle to LoadInfo (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

% Only load if file exists
fn = strcat(handles.filePath,handles.fileName);
if exist(strcat(fn,'.sbx'),'file');
    % reset the gui
    guiReset(handles);
    % read data from frame 1
    im = sbxread(fn,0,1);
    % get information about image from the global variable
    global info; %#ok<*TLEV>
    % grab 10 evenly spaced frames
    im = repmat(im,[1 1 1 10]);
    ind = round(0:(info.max_idx-1)/9:info.max_idx);
    for i = 2:10; im(:,:,:,i) = sbxread(fn,ind(i),1); end;
    im=double(im);
    % get max and mins for channel 1
    imCh1 = squeeze(im(1,:,:,:));
    hiCh1 = squeeze(max(max(imCh1,[],1),[],2));
    maxCh1 = mean(hiCh1)+4*std(hiCh1); handles.maxCh1 = maxCh1;
    loCh1 = squeeze(min(min(imCh1,[],1),[],2));
    minCh1 = mean(loCh1)-4*std(loCh1); handles.minCh1 = minCh1;
    % get frame 1 preview of channel 1, stretch the image properly
    im1 = squeeze(im(1,:,:,1));
    % adjust range between 0 and 1
    im1 = (im1-minCh1)/(maxCh1-minCh1); im1(im1>1) = 1; im1(im1<0) = 0;
    % plot the image in grayscale
    axes(handles.PreviewChannel1);
    image(repmat(im1,[1 1 3]));
    set(gca,'XTick',[],'YTick',[]);
    % update preview image text to indicate the frame
    set(handles.PreviewText1,'String',...
        sprintf('Channel 1, Frame 1 of %d',info.max_idx));
    % set slider range for flipping through the preview
    set(handles.SliderChannel1,'Min',1,'Max',info.max_idx,...
        'SliderStep',(1/info.max_idx)*[1 1],'Value',1,'Enable','on');
    % allow true size zoom
    set(handles.ZoomChannel1,'Enable','on');
    
    if info.nchan == 2  % ONLY PLOT SECOND PREVIEW IF 2 CHANNELS OF DATA
        % get max and mins for channel 2
        imCh2 = squeeze(im(2,:,:,:));
        hiCh2 = squeeze(max(max(imCh2,[],1),[],2));
        maxCh2 = mean(hiCh2)+3*std(hiCh2); handles.maxCh2 = maxCh2;
        loCh2 = squeeze(min(min(imCh2,[],1),[],2));
        minCh2 = mean(loCh2)-3*std(loCh2); handles.minCh2 = minCh2;
        % get frame 1 preview of channel 2, stretch the image properly
        im2 = squeeze(im(2,:,:,1));
        % adjust range between 0 and 1
        im2 = (im2-minCh2)/(maxCh2-minCh2); im2(im2>1) = 1; im2(im2<0) = 0;
        % plot the image in grayscale
        axes(handles.PreviewChannel2);
        image(repmat(im2,[1 1 3]));
        set(gca,'XTick',[],'YTick',[]);
        % update preview image text to indicate the frame
        set(handles.PreviewText2,'String',...
            sprintf('Channel 2, Frame 1 of %d',info.max_idx));
        % set slider range for flipping through the preview
        set(handles.SliderChannel2,'Min',1,'Max',info.max_idx,...
            'SliderStep',(1/info.max_idx)*[1 1],'Value',1,'Enable','on');
        % allow true size zoom
        set(handles.ZoomChannel2,'Enable','on');
    end
    
    % If only 1 channel disable use of channel 2
    if info.nchan == 1
        set(handles.PreviewText2,'String','No Data from Channel 2');
        set(handles.AlignChannel2,'Enable','off');
        set(handles.ImageChannel2,'Enable','off');
        set(handles.SignalsChannel2,'Enable','off');
        set(handles.SliderChannel2,'Enable','off');
    end
    
    % Open up the image processing panel
    set(handles.ProcessPanel,'Visible','on');
    % Set the align file, check for completion and which channel
    handles.alignFile = strcat(handles.fileName,'.align');
    set(handles.AlignFile,'String',handles.alignFile);
    afn = strcat(handles.filePath,handles.alignFile);
    if exist(afn,'file')
        set(handles.AlignCheck,'Value',1);
        load(afn,'-mat');
        if channel == 1; set(handles.AlignChannel1,'Value',1); end;
        if channel == 2; set(handles.AlignChannel2,'Value',1); end;
    else
        set(handles.AlignChannel1,'Value',1);
    end
    % Set the image file, check for completion and which channel
    handles.imageFile = strcat(handles.fileName,'.image');
    set(handles.ImageFile,'String',handles.imageFile);
    ifn = strcat(handles.filePath,handles.imageFile);
    if exist(ifn,'file')
        set(handles.ImageCheck,'Value',1);
        load(ifn,'-mat');
        if channel == 1; set(handles.ImageChannel1,'Value',1); end;
        if channel == 2; set(handles.ImageChannel2,'Value',1); end;
        handles.numFramesToSkip = numFramesToSkip;
%         set(handles.numFramesToSkip,'String',num2str(numFramesToSkip));
        set(handles.CreateMask,'Enable','on');
    else
        set(handles.ImageChannel1,'Value',1);
        handles.numFramesToSkip = str2double(get(handles.numFramesToSkip,'String'));
    end
    % Set the mask file, check for completion and which channel
    handles.maskFile = strcat(handles.fileName,'.segment');
    set(handles.MaskFile,'String',handles.maskFile);
    mfn = strcat(handles.filePath,handles.maskFile);
    if exist(mfn,'file')
        set(handles.MaskCheck,'Value',1);
        set(handles.PullSignals,'Enable','on');
    end
    % Set the signals file, check for completion and which channel
    handles.signalsFile = strcat(handles.fileName,'.signals');
    set(handles.SignalsFile,'String',handles.signalsFile);
    sfn = strcat(handles.filePath,handles.signalsFile);
    if exist(sfn,'file')
        set(handles.SignalsCheck,'Value',1);
        load(sfn,'-mat');
        if channel == 1; set(handles.SignalsChannel1,'Value',1); end;
        if channel == 2; set(handles.SignalsChannel2,'Value',1); end;
    else
        set(handles.SignalsChannel1,'Value',1);
    end
    
    % Open up the view data panel
    if get(handles.SignalsCheck,'Value') && get(handles.MaskCheck,'Value')
        set(handles.PlotPanel,'Visible','On');
    end
    
    % save handles
    guidata(hObject,handles);
else
    warndlg('No such data file exists!','File Not Found')
end

% --- Executes on slider movement.
function SliderChannel1_Callback(hObject,~,handles)

% load preview image of the frame indicated by the slider
fn = strcat(handles.filePath,handles.fileName);
im = sbxread(fn,round(get(hObject,'Value'))-1,1);
im=double(im);
% get a preview image from channel one, stretch the image properly
global info;
im = squeeze(im(1,:,:));
% process the image so that values are between 0 and 1
im = (im-handles.minCh1)/(handles.maxCh1-handles.minCh1);
im(im>1) = 1; im(im<0) = 0;
% select only a center portion of the image if zoomed in
if get(handles.ZoomChannel1,'Value')
    im = im(round(size(im,1)/4+(1:size(im,1)/2)),round(size(im,2)/4+(1:size(im,2)/2)));
end
% plot the image in grayscale
axes(handles.PreviewChannel1);
image(repmat(im,[1 1 3]));
set(gca,'XTick',[],'YTick',[]);
% update preview image text to indicate the frame
set(handles.PreviewText1,'String',sprintf('Channel 1, Frame %d of %d',...
    round(get(hObject,'Value')),info.max_idx));
% --- Executes during object creation, after setting all properties.
function SliderChannel1_CreateFcn(hObject,~,~)
if isequal(get(hObject,'BackgroundColor'),get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function SliderChannel2_Callback(hObject,~,handles)
% load preview image of the frame indicated by the slider
fn = strcat(handles.filePath,handles.fileName);
im = sbxread(fn,round(get(hObject,'Value'))-1,1);
im=double(im);
% get a preview image from channel one, stretch the image properly
global info;
im = squeeze(im(2,:,:));
% process the image so that values are between 0 and 1
im = (im-handles.minCh2)/(handles.maxCh2-handles.minCh2);
im(im>1) = 1; im(im<0) = 0;
% select only a center portion of the image if zoomed in
if get(handles.ZoomChannel2,'Value')
    im = im(round(size(im,1)/4+(1:size(im,1)/2)),round(size(im,2)/4+(1:size(im,2)/2)));
end
% plot the image in grayscale
axes(handles.PreviewChannel2);
image(repmat(im,[1 1 3]));
set(gca,'XTick',[],'YTick',[]);
% update preview image text to indicate the frame
set(handles.PreviewText2,'String',sprintf('Channel 2, Frame %d of %d',...
    round(get(hObject,'Value')),info.max_idx));
% --- Executes during object creation, after setting all properties.
function SliderChannel2_CreateFcn(hObject,~,~)
if isequal(get(hObject,'BackgroundColor'),get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in ZoomChannel1.
function ZoomChannel1_Callback(hObject,~,handles)
% load preview image of the frame indicated by the slider
fn = strcat(handles.filePath,handles.fileName);
im = sbxread(fn,round(get(handles.SliderChannel1,'Value'))-1,1);
im=double(im);
% get a preview image from channel one, stretch the image properly
im = squeeze(im(1,:,:));
% process the image so that values are between 0 and 1
im = (im-handles.minCh1)/(handles.maxCh1-handles.minCh1);
im(im>1) = 1; im(im<0) = 0;
% select only a center portion of the image if zoomed in
if get(hObject,'Value')
    im = im(round(size(im,1)/4+(1:size(im,1)/2)),round(size(im,2)/4+(1:size(im,2)/2)));
end
% plot the image in grayscale
axes(handles.PreviewChannel1);
image(repmat(im,[1 1 3]));
set(gca,'XTick',[],'YTick',[]);


% --- Executes on button press in ZoomChannel2.
function ZoomChannel2_Callback(hObject,~,handles)
% load preview image of the frame indicated by the slider
fn = strcat(handles.filePath,handles.fileName);
im = sbxread(fn,round(get(handles.SliderChannel2,'Value'))-1,1);
im=double(im);
% get a preview image from channel one, stretch the image properly
im = squeeze(im(2,:,:));
% process the image so that values are between 0 and 1
im = (im-handles.minCh2)/(handles.maxCh2-handles.minCh2);
im(im>1) = 1; im(im<0) = 0;
% select only a center portion of the image if zoomed in
if get(hObject,'Value')
    im = im(round(size(im,1)/4+(1:size(im,1)/2)),round(size(im,2)/4+(1:size(im,2)/2)));
end
% plot the image in grayscale
axes(handles.PreviewChannel2);
image(repmat(im,[1 1 3]));
set(gca,'XTick',[],'YTick',[]);



%%%%% IMAGE PROCESSING PANEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---- ALIGN FUNCTION ------------------------------------------------------
function AlignCheck_Callback(~,~,~)
function AlignFile_CreateFcn(~,~,~)
function AlignFile_Callback(hObject,~,handles)
% Get align file name
alignFile = get(hObject,'String');
% Set the align file
handles.alignFile = alignFile;
% Check if file exists
fn = strcat(handles.filePath,alignFile);
if exist(fn,'file') && ~isempty(alignFile);
    % if exists mark as such
    set(handles.AlignCheck,'Value',1);
    % also determine which channel was used for alignment
    load(fn,'-mat');
    if channel == 1
        set(handles.AlignChannel1,'Value',1);
        set(handles.AlignChannel2,'Value',0);
    end
    if channel == 2
        set(handles.AlignChannel1,'Value',0);
        set(handles.AlignChannel2,'Value',1);
    end
else
    % otherwise mark as not completed
    set(handles.AlignCheck,'Value',0);
end
% update the align file in handles
guidata(hObject,handles);

% --- Executes on button press in AlignChannel1.
function AlignChannel1_Callback(hObject,~,handles)
if get(hObject,'Value')
    set(handles.AlignChannel2,'Value',0);
else
    set(handles.AlignChannel2,'Value',1);
end

% --- Executes on button press in AlignChannel2.
function AlignChannel2_Callback(hObject,~,handles)
if get(hObject,'Value')
    set(handles.AlignChannel1,'Value',0);
else
    set(handles.AlignChannel1,'Value',1);
end

% --- Executes on button press in AlignFrames.
function AlignFrames_Callback(hObject,~,handles)
% Align frames if a file name is given
if ~isempty(handles.alignFile)
    % Do an overwrite check if file already exists
    if get(handles.AlignCheck,'Value')
        a = questdlg('Overwrite file?','Overwrite Check','Yes','No','Yes');
        if ~strcmp(a,'Yes'); return; end
    end
    % Otherwise start frame alignment
    % Determine which channel to use for aligning frames
    if get(handles.AlignChannel1,'Value')
        channel = 1;
    else
        channel = 2;
    end
    % Start aligning
    fn = strcat(handles.filePath,handles.fileName);
    global info;
    h = waitbar(0,'Aligning frames...');
    [m,T] = align(fn,0:info.max_idx,channel,info.max_idx,h,0); 
    delete(h);
    
    info.aligned.m = m;
    info.aligned.T = T;
    % Save the alignment data
    save(strcat(handles.filePath,handles.alignFile),'m','T','channel');
    
    figure; plot(T(:,2)); hold on; plot(T(:,1),'r');
    legend({'X','Y'}); title('Movement over time');
    ylabel('Movement per frame (pix)'); xlabel('Time');
    
    % Mark as aligned
    set(handles.AlignCheck,'Value',1);
else
    warndlg('You must specify a file to align frames!','No File Warning');
end



%---- IMAGE FUNCTION ------------------------------------------------------
function ImageCheck_Callback(~,~,~)
function ImageFile_CreateFcn(~,~,~)
function ImageFile_Callback(hObject,~,handles)
% Get image file name
imageFile = get(hObject,'String');
% Set the image file
handles.imageFile = imageFile;
% Check if file exists
fn = strcat(handles.filePath,imageFile);
if exist(fn,'file') && ~isempty(imageFile);
    % if exists mark as such
    set(handles.ImageCheck,'Value',1);
    set(handles.CreateMask,'Enable','on');
    % also determine which channel was used to make the image
    load(fn,'-mat');
    if channel == 1
        set(handles.ImageChannel1,'Value',1);
        set(handles.ImageChannel2,'Value',0);
    end
    if channel == 2
        set(handles.ImageChannel1,'Value',0);
        set(handles.ImageChannel2,'Value',1);
    end
    % and the sample frame spacing
    set(handles.numFramesToSkip,'String',numFramesToSkip);
else
    % otherwise mark as not completed
    set(handles.ImageCheck,'Value',0);
    set(handles.CreateMask,'Enable','off');
end
% update the image file in handles
guidata(hObject,handles);

% --- Executes on button press in ImageChannel1.
function ImageChannel1_Callback(hObject,~,handles)
if get(hObject,'Value')
    set(handles.ImageChannel2,'Value',0);
    set(handles.ImageComposite,'Value',0);
else
    set(handles.ImageChannel2,'Value',1);
    set(handles.ImageComposite,'Value',0);
end

% --- Executes on button press in ImageChannel2.
function ImageChannel2_Callback(hObject,~,handles)
if get(hObject,'Value')
    set(handles.ImageChannel1,'Value',0);
    set(handles.ImageComposite,'Value',0);
else
    set(handles.ImageChannel1,'Value',1);
    set(handles.ImageComposite,'Value',0);
end

% --- Executes on button press in ImageComposite.
function ImageComposite_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    set(handles.ImageChannel1,'Value',0);
    set(handles.ImageChannel2,'Value',0);
else
    set(handles.ImageChannel1,'Value',1);
    set(handles.ImageChannel2,'Value',0);
end

function numFramesToSkip_CreateFcn(~,~,~)
function numFramesToSkip_Callback(hObject,~,handles)
numFramesToSkip = str2num(get(hObject,'String')); %#ok<ST2NM>
if ~isempty(numFramesToSkip)
    handles.numFramesToSkip = abs(round(numFramesToSkip));
end
set(hObject,'String',num2str(numFramesToSkip));
% update handles
guidata(hObject,handles);

% --- Executes on button press in CreateImage.
function CreateImage_Callback(hObject,~,handles)
% Create an image to define units if a file is given
if ~isempty(handles.imageFile)
    % Do an overwrite check if file already exists
    if get(handles.ImageCheck,'Value')
        a = questdlg('Overwrite file?','Overwrite Check','Yes','No','Yes');
        if ~strcmp(a,'Yes'); return; end
    end
    
    % Otherwise start creating image for unit selection
    % Determine which channel to use when creating the image
    if get(handles.ImageChannel1,'Value')
        channels = 1;
    elseif get(handles.ImageChannel2,'Value')
        channels = 2;
    else
        channels = [1 2];
    end
    
    % Find the sample spacing
    numFramesToSkip = handles.numFramesToSkip;

    % Create an image, subsampling frames
    fn = strcat(handles.filePath,handles.fileName); 
    
    for ch=1:length(channels)
        channel = channels(ch);
        h = waitbar(0,['Reading frames for channel ' num2str(channel)]);
        z = readskip(fn,1,numFramesToSkip,channel,h);
        delete(h);
        z = double(z);

        % The image will show variance in each pixel, normalized between 0 and 1
        avgImage(ch,:,:) = mean(z,3);
        avgImage(ch,:,:) = avgImage(ch,:,:) - min(min(avgImage(ch,:,:))); 
        avgImage(ch,:,:) = avgImage(ch,:,:)/max(max(avgImage(ch,:,:))); 
    end
    
    if length(channels) > 1;
        g = squeeze(avgImage(1,:,:));
        r = squeeze(avgImage(2,:,:));
        b = zeros(size(g));
        avgImage = [];
        avgImage(:,:,1) = r;
        avgImage(:,:,2) = g;
        avgImage(:,:,3) = b;
    else
        avgImage = repmat(squeeze(avgImage),[1 1 3]);
    end
    
    % Save the image
    save(strcat(handles.filePath,handles.imageFile),'avgImage','channel','numFramesToSkip');
    
    % Mark that image has been created
    set(handles.ImageCheck,'Value',1);
    set(handles.CreateMask,'Enable','on');
    % Show the image in a new figure window
    figure; image(avgImage); truesize; set(gca,'XTick',[],'YTick',[]);
else
    warndlg('You must specify a file to hold the image!','No File Warning');
end


%---- MASK FUNCTION -------------------------------------------------------
function MaskCheck_Callback(~,~,~)
function MaskFile_CreateFcn(~,~,~)
function MaskFile_Callback(hObject,~,handles)
% Get mask file name
maskFile = get(hObject,'String');
% Set the mask file
handles.maskFile = maskFile;
% Check if file exists
fn = strcat(handles.filePath,handles.maskFile);
if exist(fn,'file') && ~isempty(maskFile)
    set(handles.MaskCheck,'Value',1);
    set(handles.PullSignals,'Enable','on');
else
    set(handles.MaskCheck,'Value',0);
    set(handles.PullSignals,'Enable','off');
end
% update the mask file in handles
guidata(hObject,handles);
% See if components are ready to launch StandardFormat
checks = get([handles.MaskCheck handles.SignalsCheck],'Value');
if checks{1} && checks{2} 
    set(handles.StandardFormat,'Enable','on');
else
    set(handles.StandardFormat,'Enable','off');
end


% --- Executes on button press in CreateMask.
function CreateMask_Callback(hObject,~,handles)
% Open a GUI to define units if a file is given
if ~isempty(handles.maskFile)
    % Open GUI to define units
    maskGui('imagePath',handles.filePath,'imageFile',handles.imageFile,...
        'maskPath',handles.filePath,'maskFile',handles.maskFile);
    
    % Check that mask file now exists
    mfn = strcat(handles.filePath,handles.maskFile);
    if exist(mfn,'file')
        set(handles.MaskCheck,'Value',1);
        set(handles.PullSignals,'Enable','on');
    else
        set(handles.PullSignals,'Enable','off');
    end
    
    % See if components are ready to launch StandardFormat
    checks = get([handles.MaskCheck handles.SignalsCheck ],'Value');
    if checks{1} && checks{2} 
        set(handles.StandardFormat,'Enable','on');
    else
        set(handles.StandardFormat,'Enable','off');
    end
else
    warndlg('You must specify a file to open/save units!','No File Warning');
end


%---- SIGNALS FUNCTION ----------------------------------------------------
function SignalsCheck_Callback(~,~,~)
function SignalsFile_CreateFcn(~,~,~)
function SignalsFile_Callback(hObject,~,handles)
% Get signals file name
signalsFile = get(hObject,'String');
% Set the signals file
handles.signalsFile = signalsFile;
% Check if file exists
fn = strcat(handles.filePath,signalsFile);
if exist(fn,'file') && ~isempty(signalsFile)
    % if exists mark as such
    set(handles.SignalsCheck,'Value',1);
    % also determine which channel signals were taken from
    load(fn,'-mat');
    if channel == 1
        set(handles.SignalsChannel1,'Value',1);
        set(handles.SignalsChannel2,'Value',0);
    end
    if channel == 2
        set(handles.SignalsChannel1,'Value',0);
        set(handles.SignalsChannel2,'Value',1);
    end
else
    % otherwise mark as not completed
    set(handles.SignalsCheck,'Value',0);
end
% update the signals file in handles
guidata(hObject,handles);
% See if components are ready to launch StandardFormat
checks = get([handles.MaskCheck handles.SignalsCheck],'Value');
if checks{1} && checks{2} 
    set(handles.StandardFormat,'Enable','on');
else
    set(handles.StandardFormat,'Enable','off');
end

% --- Executes on button press in SignalsChannel1.
function SignalsChannel1_Callback(hObject,~,handles)
if get(hObject,'Value')
    set(handles.SignalsChannel2,'Value',0);
else
    set(handles.SignalsChannel2,'Value',1);
end

% --- Executes on button press in SignalsChannel2.
function SignalsChannel2_Callback(hObject,~,handles)
if get(hObject,'Value')
    set(handles.SignalsChannel1,'Value',0);
else
    set(handles.SignalsChannel1,'Value',1);
end

% --- Executes on button press in PullSignals.
function PullSignals_Callback(hObject,~,handles)
% Pull signals from data if a file is given
if ~isempty(handles.signalsFile)
    % Do an overwrite check if file already exists
    if get(handles.SignalsCheck,'Value')
        a = questdlg('Overwrite file?','Overwrite Check','Yes','No','Yes');
        if ~strcmp(a,'Yes'); return; end
    end
%     % Otherwise start pulling signals for each unit
%     % Determine which channel to pull signals from
    if get(handles.SignalsChannel1,'Value')
        channel = 1;
    else
        channel = 2;
    end
%     % If frames have been aligned, use alignment for pulling signals
%     if get(handles.AlignCheck,'Value')
%         afn = strcat(handles.filePath,handles.alignFile);
%     else
%         afn = [];
%     end
    % Pull signals
    fn = strcat(handles.filePath,handles.fileName);   
    signals = pullsigs(fn); 
    % Save the signals
    save(strcat(handles.filePath,handles.signalsFile),'signals','channel');
    % Mark that the signals have been pulled
    set(handles.SignalsCheck,'Value',1);
    
    % See if components are ready to launch StandardFormat
    checks = get([handles.MaskCheck handles.SignalsCheck],'Value');
    if checks{1} && checks{2} 
        set(handles.StandardFormat,'Enable','on');
    else
        set(handles.StandardFormat,'Enable','off');
    end
else
    warndlg('You must specify a file to pull signals!','No File Warning');
end



%%%%% DATA VIEWING PANEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in StandardFormat.
function StandardFormat_Callback(hObject,~,handles)

% Throw path information into a settings structure to be used by the data
% viewing gui
S.filePath = handles.filePath;
S.infoFile = [handles.fileName '.mat'];
S.imageFile = handles.imageFile;
S.maskFile = handles.maskFile;
S.signalsFile = handles.signalsFile;
S.eventsFile = [handles.fileName(1:6) 'u' handles.fileName(7:end) '.analyzer'];

standardDataFormat(S);

% --- Executes on button press in EventAverage.
function EventAverage_Callback(hObject,~,handles)
% Pass files, which will be loaded in the viewdataGui opening function
eventaverageGui('fn',fn,'mfn',mfn,'sfn',sfn,'ifn',ifn);

%%%%% RESET FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function guiReset(handles)
set([handles.SliderChannel1 handles.SliderChannel2],'Enable','off');
set([handles.ZoomChannel1 handles.ZoomChannel2],'Enable','off','Value',0);
set(handles.PreviewText1,'String','Channel 1, No Data Loaded');
set(handles.PreviewText2,'String','Channel 2, No Data Loaded');
axes(handles.PreviewChannel1);
image(zeros(512,796,3)); set(gca,'XTick',[],'YTick',[]);
axes(handles.PreviewChannel2);
image(zeros(512,796,3)); set(gca,'XTick',[],'YTick',[]);

set(handles.ProcessPanel,'Visible','off');
set([handles.AlignCheck handles.ImageCheck handles.MaskCheck handles.SignalsCheck],'Value',0);
set([handles.CreateMask handles.PullSignals],'Enable','off');
set([handles.AlignChannel1 handles.AlignChannel2],'Value',0);
set([handles.ImageChannel1 handles.ImageChannel2],'Value',0);
set([handles.SignalsChannel1 handles.SignalsChannel2],'Value',0);
set([handles.AlignChannel2 handles.ImageChannel2 handles.SignalsChannel2],'Enable','on');
% set(handles.numFramesToSkip,'String','200');

set(handles.PlotPanel,'Visible','off');

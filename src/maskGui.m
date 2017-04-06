function varargout = maskGui(varargin)
% MASKGUI MATLAB code for maskGui.fig
%      MASKGUI, by itself, creates a new MASKGUI or raises the existing
%      singleton*.
%
%      H = MASKGUI returns the handle to a new MASKGUI or the handle to
%      the existing singleton*.
%
%      MASKGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MASKGUI.M with the given input arguments.
%
%      MASKGUI('Property','Value',...) creates a new MASKGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before maskGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to maskGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help maskGui

% Last Modified by GUIDE v2.5 06-Apr-2017 00:32:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @maskGui_OpeningFcn, ...
                   'gui_OutputFcn',  @maskGui_OutputFcn, ...
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

% --- Executes just before maskGui is made visible.
function maskGui_OpeningFcn(hObject,~,handles,varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to maskGui (see VARARGIN)

% Choose default command line output for maskGui
handles.output = hObject;

%%%%% SETTING UP GUI HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check for inputs, assign if given
handles.imagePath = [pwd '\']; handles.imageFile = '';
handles.maskPath = [pwd '\'];  handles.maskFile = '';
for i = 1:floor(length(varargin)/2)
    handles.(varargin{2*i-1}) = varargin{2*i};
end
% Set up paths and files
set(handles.ImagePath,'String',handles.imagePath);
set(handles.ImageFile,'String',handles.imageFile);
set(handles.MaskPath,'String',handles.maskPath);
set(handles.MaskFile,'String',handles.maskFile);
% Allow saving if a mask file is specified
if exist(handles.maskPath,'dir') && ~isempty(handles.MaskFile)
    set(handles.SaveMask,'Enable','on');
end

% Load image if exists
if exist(fullfile(handles.imagePath,handles.imageFile),'file')==2
    load(fullfile(handles.imagePath,handles.imageFile),'-mat');
    handles.image = avgImage;
else % Otherwise load a blank image
    handles.image = repmat(zeros(512,796),1,1,3);
end

% Load mask if exists
if exist(fullfile(handles.maskPath,handles.maskFile),'file')==2
    load(fullfile(handles.maskPath,handles.maskFile),'-mat');
    load(fullfile(handles.imagePath,handles.imageFile),'-mat');
    handles.mask = mask;
    % If any units exist, update the image with the their ROIs
    im = handles.image;
    if max(handles.mask(:))
        % Update the image with the unit's ROI
        [i,j] = find(handles.mask > 0);
        for k = 1:length(i); im(i(k),j(k),3) = 1; end;
    end
    axes(handles.Image); image(im);
    set(handles.Image,'XTick',[],'YTick',[]);
    % Assign Mask Flags
    if ~exist('maskFlags','var'); handles.maskFlags = ones(max(mask(:)),1);
    else handles.maskFlags = maskFlags; end;
else % Otherwise load a blank mask
    handles.mask = zeros(512,796);
    handles.maskFlags = [];
end
% Set xlimit and ylimit
handles.xlim = [0.5 796.5];
handles.ylim = [0.5 512.5];
% Update image
handles.unitNumber = 0;
handles.unitNumber = UpdateUnitNumber(handles);

% Update handles structure
guidata(hObject, handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Outputs from this function are returned to the command line.
function varargout = maskGui_OutputFcn(hObject,~,handles)  %#ok<*INUSL>
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%%% IMAGE LOADER FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ImagePath_CreateFcn(~,~,~) %#ok<*DEFNU>
function ImagePath_Callback(hObject,~,handles)
imagePath = get(hObject,'String');
if exist(imagePath,'dir')
    handles.imagePath = imagePath;
    guidata(hObject,handles);
else
    set(handles.ImagePath,'String',handles.imagePath);
    warndlg('Image path does not exist!','Invalid Path');
end

function ImageFile_CreateFcn(~,~,~)
function ImageFile_Callback(hObject,~,handles)
imageFile = get(hObject,'String');
if exist(fullfile(handles.imagePath,imageFile),'file')
    handles.imageFile = imageFile;
    guidata(hObject,handles);
else
    set(handles.ImageFile,'String',handles.imageFile);
    warndlg('Image file does not exist!','Invalid File');
end

% --- Executes on button press in FindImage.
function FindImage_Callback(hObject,~,handles)
% Open up a user interface to select an image file
[imageFile,imagePath] = uigetfile('*.image');
if imageFile ~= 0
    handles.imagePath = imagePath;
    handles.imageFile = imageFile;
    set(handles.ImagePath,'String',imagePath);
    set(handles.ImageFile,'String',imageFile);
    guidata(hObject, handles);
end

% --- Executes on button press in LoadImage.
function LoadImage_Callback(hObject,~,handles)
if exist(fullfile(handles.imagePath,handles.imageFile),'file')==2
    % Load image if exists
    load(fullfile(handles.imagePath,handles.imageFile),'-mat');
    handles.image = avgImage;
    handles.unitNumber = UpdateUnitNumber(handles);
    guidata(hObject, handles);
elseif isempty(handles.imageFile)
    a = questdlg('Load a blank image?','Blank Image','Yes','No','Yes');
    if strcmp(a,'Yes');
        handles.image = zeros(512,796,3);
        handles.unitNumber = UpdateUnitNumber(handles);
    end
else
    warndlg('Image file not found!','File Not Found');
end


%%%%% MASK PANEL FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MaskPath_CreateFcn(~,~,~)  
function MaskPath_Callback(hObject,~,handles)
maskPath = get(hObject,'String');
if exist(maskPath,'dir')
    handles.maskPath = maskPath;
    guidata(hObject,handles);
else
    set(handles.MaskPath,'String',handles.maskPath);
    warndlg('Specified path does not exist!','Invalid Path');
end

function MaskFile_CreateFcn(~,~,~)
function MaskFile_Callback(hObject,~,handles)
maskFile = get(hObject,'String');
handles.maskFile = maskFile;
guidata(hObject,handles);
% Disable saving if mask file is empty
if isempty(handles.maskFile)
    set(handles.SaveMask,'Enable','off');
else
    set(handles.SaveMask,'Enable','on');
end

% --- Executes on button press in FindMask.
function FindMask_Callback(hObject,~,handles)
% Open up a user interface to select a mask file
[maskFile,maskPath] = uigetfile('*.segment');
if maskFile ~= 0
    % If a file is selected, update the path and files
    handles.maskPath = maskPath;
    handles.maskFile = maskFile;
    set(handles.MaskPath,'String',handles.maskPath);
    set(handles.MaskFile,'String',handles.maskFile);
    set(handles.SaveMask,'Enable','on');
    guidata(hObject, handles);
end

% --- Executes on button press in LoadMask.
function LoadMask_Callback(hObject,~,handles)
if exist(fullfile(handles.maskPath,handles.maskFile),'file')==2
    % Load mask if exists
    load(fullfile(handles.maskPath,handles.maskFile),'-mat');
    handles.mask = mask;
    handles.unitNumber = 0;
    handles.unitNumber = UpdateUnitNumber(handles);
    % Assign Mask Flags
    if ~exist('maskFlags','var'); handles.maskFlags = ones(max(mask(:)),1);
    else handles.maskFlags = maskFlags; end;
    % Update handles
    guidata(hObject, handles);
else
    warndlg('ROIs file not found!','File Not Found');
end

% --- Executes on button press in ClearMask.
function ClearMask_Callback(hObject,~,handles)
a = questdlg('Clear unit ROIs?','Clear Confirm','Yes','No','Yes');
if strcmp(a,'Yes')
    handles.mask = zeros(512,796);
    handles.unitNumber = 0;
    handles.unitNumber = UpdateUnitNumber(handles);
    handles.maskFlags = [];
end

% --- Executes on button press in SaveMask.
function SaveMask_Callback(hObject,~,handles)
% Get mask
mask = handles.mask;
maskFlags = handles.maskFlags;
singleCellMasks = makeInvividualMasks(mask);
% if file exists, confirm overwrite is ok
if exist(fullfile(handles.maskPath,handles.maskFile),'file') == 2
    a = questdlg('Overwrite ROIs?','Overwrite Confirm','Yes','No','Yes');
    if strcmp(a,'Yes')
        save(fullfile(handles.maskPath,handles.maskFile),'mask','singleCellMasks','maskFlags');
        warndlg('ROIs saved, file overwritten!','Save Confirm');
    end
else % if file doesn't exist, then save mask data
    save(fullfile(handles.maskPath,handles.maskFile),'mask','singleCellMasks','maskFlags');
    warndlg('ROIs saved!','Save Confirm');
end

function singleCellMasks = makeInvividualMasks(mask)
nUnit = max(mask(:));
singleCellMasks = zeros(size(mask,1),size(mask,2),nUnit);
for u=1:nUnit
    singleCellMasks(:,:,u) = mask == u;
end


%%%%% MODIFY MASK PANEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in AddROI.
function AddROI_Callback(hObject,~,handles)
% Have user draw an ellipse, double click to finish
h = imellipse; wait(h);
% Create a mask from that image
mask = createMask(h);
% Now we're done with the ellipse, delete it
delete(h);

% Find the unit number corresponding to this ROI
handles.unitNumber = max(handles.mask(:))+1;
set(handles.UnitNumber,'String',num2str(handles.unitNumber));
% Update the master mask
[i,j] = find(mask);
for k = 1:length(i); handles.mask(i(k),j(k)) = handles.unitNumber; end;
% Assign a mask flag of 1 -- normal unit
handles.maskFlags = [handles.maskFlags;1];

% Call this whenever updating unit number
handles.unitNumber = UpdateUnitNumber(handles);

% Update the handles
guidata(hObject, handles);

function UnitNumber_CreateFcn(~,~,~)
function UnitNumber_Callback(hObject,~,handles)
handles.unitNumber = str2double(get(hObject,'String'));
handles.unitNumber = UpdateUnitNumber(handles);
guidata(hObject,handles);

% --- Executes on button press in UpUnit.
function UpUnit_Callback(hObject,~,handles)
handles.unitNumber = handles.unitNumber+1;
handles.unitNumber = UpdateUnitNumber(handles);
guidata(hObject, handles);

% --- Executes on button press in DownUnit.
function DownUnit_Callback(hObject,~,handles)
handles.unitNumber = handles.unitNumber-1;
handles.unitNumber = UpdateUnitNumber(handles);
guidata(hObject, handles);

% --- Executes on button press in ChangeROI.
function ChangeROI_Callback(hObject,~,handles)
% Only do this if on a valid unit
if handles.unitNumber > 0
    % Get the current unit
    mask = handles.mask == handles.unitNumber;
    [i,j] = find(mask);
    
    % Have user redraw ellipse, double click to finish
    axes(handles.Image)
    h = imellipse(gca,[min(j) min(i) max(j)-min(j) max(i)-min(i)]);
    wait(h);
    % Create a mask from that image
    mask = createMask(h);
    % Now we're done with the ellipse, delete it
    delete(h);
    
    % Update the master mask
    for k = 1:length(i)
        handles.mask(i(k),j(k)) = 0;
    end
    [i,j] = find(mask);
    for k = 1:length(i)
        handles.mask(i(k),j(k)) = handles.unitNumber;
    end
    
    % Now we need update the image and unit number text
    handles.unitNumber = UpdateUnitNumber(handles);
    
    % Update the handles
    guidata(hObject, handles);
end


% --- Executes on button press in DeleteROI.
function DeleteROI_Callback(hObject,~,handles)
% hObject    handle to DeleteROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% remove the mask flag
if handles.unitNumber == 1
    handles.maskFlags = handles.maskFlags(handles.unitNumber+1:end);
else
    handles.maskFlags = [handles.maskFlags(1:handles.unitNumber-1);handles.maskFlags(handles.unitNumber+1:end)];
end
% erase the mask
[i,j] = find(handles.mask == handles.unitNumber);
for k = 1:length(i)
    handles.mask(i(k),j(k)) = 0;
end
% lower number of remaining masks
if max(max(handles.mask)) > handles.unitNumber
    [I,J] = find(handles.mask > handles.unitNumber);
    for k = 1:length(I)
        handles.mask(I(k),J(k)) = handles.mask(I(k),J(k))-1;
    end
end

handles.unitNumber = UpdateUnitNumber(handles);
% Update the handles
guidata(hObject, handles);

% --- Executes on slider movement.
function UnitSlider_Callback(hObject,~,handles)
% hObject    handle to UnitSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% --- Executes during object creation, after setting all properties.
function UnitSlider_CreateFcn(hObject,~,handles)
% hObject    handle to UnitSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function unitNumber = UpdateUnitNumber(handles)
% Get the proposed unit number
unitNumber = handles.unitNumber;

% Ensure it is numeric and in range of existing units
if ~isnumeric(unitNumber); unitNumber = 0; end;
if unitNumber < 0; unitNumber = 0; end;
if unitNumber > max(handles.mask(:)); unitNumber = max(handles.mask(:)); end;

% Update image to show current unit in magenta and other units in blue
axes(handles.Image);
im = handles.image;
if max(handles.mask(:))
    % Update the image with all ROIs
    [i,j] = find(handles.mask > 0);
    for k = 1:length(i); im(i(k),j(k),3) = 1; end;
end
if unitNumber > 0
    % Update the image with the selected ROI
    [i,j] = find(handles.mask == unitNumber);
    for k = 1:length(i); im(i(k),j(k),1) = 1; end;
end
% Show ROIs
image(im); set(handles.Image,'XTick',[],'YTick',[]);
set(handles.Image,'XLim',handles.xlim,'YLim',handles.ylim);

% Update the unit number text
set(handles.UnitNumber,'String',num2str(unitNumber));
if unitNumber > 0
    set(handles.MaskFlag,'String',num2str(handles.maskFlags(unitNumber)));
else
    set(handles.MaskFlag,'String','');
end


function MaskFlag_CreateFcn(~,~,~)
function MaskFlag_Callback(hObject, eventdata, handles)
% hObject    handle to MaskFlag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaskFlag as text
%        str2double(get(hObject,'String')) returns contents of MaskFlag as a double
if handles.unitNumber > 0
    handles.maskFlags(handles.unitNumber) = str2double(get(hObject,'String'));
else
    set(handles.MaskFlag,'String','');
end
guidata(hObject,handles);

% --- Executes on button press in ZoomButton.
function ZoomButton_Callback(hObject, ~, handles)
[x,y,b] = ginput(1);
if b == 1
    xd = diff(get(gca,'XLim'))/4;
    yd = diff(get(gca,'YLim'))/4;
    handles.xlim = [x-xd x+xd];
    handles.ylim = [y-yd y+yd];
    set(gca,'XLim',handles.xlim,'YLim',handles.ylim);
else
    handles.xlim = [0.5 796.5];
    handles.ylim = [0.5 512.5];
    set(gca,'XLim',handles.xlim,'YLim',handles.ylim);
end
guidata(hObject,handles);


% --- Executes on button press in pushbutton_shiftUp.
function pushbutton_shiftUp_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_shiftUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mask = circshift(handles.mask,-1);

% Now we need update the image and unit number text
handles.unitNumber = UpdateUnitNumber(handles);

% Update the handles
guidata(hObject, handles);

% --- Executes on button press in pushbutton_shiftDown.
function pushbutton_shiftDown_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_shiftDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mask = circshift(handles.mask,1);

% Now we need update the image and unit number text
handles.unitNumber = UpdateUnitNumber(handles);

% Update the handles
guidata(hObject, handles);

% --- Executes on button press in pushbutton_shiftRight.
function pushbutton_shiftRight_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_shiftRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mask = circshift(handles.mask,[0 1]);

% Now we need update the image and unit number text
handles.unitNumber = UpdateUnitNumber(handles);

% Update the handles
guidata(hObject, handles);

% --- Executes on button press in pushbuttonLeft.
function pushbuttonLeft_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mask = circshift(handles.mask,[0 -1]);

% Now we need update the image and unit number text
handles.unitNumber = UpdateUnitNumber(handles);

% Update the handles
guidata(hObject, handles);
